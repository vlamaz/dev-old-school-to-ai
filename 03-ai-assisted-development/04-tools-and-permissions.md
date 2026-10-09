# Tools & Permissions

Tools are what let the agent act: read files, search, edit, run shell commands, fetch URLs, start subagents. The model only *requests* a tool call; the harness decides whether it runs, runs it, and returns the result (see [Tools](../01-ai-foundations/05-tools.md) and [Harness](../02-agentic-engineering/02-harness.md)). Permissions are the harness's rules for that decision.

Three layers, from soft to hard:

```text
Instruction files (CLAUDE.md, AGENTS.md)   → advice; the model can ignore it
Permission rules and modes                 → enforced by the harness, per tool call
Sandbox (OS level)                         → enforced by the operating system, for shell commands
```

Use instruction files for preferences, permissions for "never do this", and a sandbox or container when you let the agent run unattended. Hooks add custom checks on top (see [Hooks](06-hooks.md)). For the threat model (prompt injection, secrets, untrusted tools) see [Security](../02-agentic-engineering/05-security.md).

## Claude Code

### Built-in tools

The main ones:

| Tool                  | What it does                                  | Asks permission (Manual mode) |
| --------------------- | --------------------------------------------- | ----------------------------- |
| `Read`                | Read a file                                   | No                            |
| `Glob`, `Grep`        | Find files, search contents                   | No                            |
| `Edit`, `Write`       | Change or create files                        | Yes                           |
| `Bash` / `PowerShell` | Run shell commands                            | Yes, except read-only commands |
| `WebFetch`            | Fetch a URL                                   | Yes                           |
| `WebSearch`           | Search the web                                | Yes                           |
| `Agent`               | Start a [subagent](08-agents.md)              | No                            |
| `Skill`               | Run a [skill](05-skills.md)                   | Yes                           |
| `LSP`                 | Go to definition, find references, type errors | No                           |

On macOS, Linux, and WSL, `Glob` and `Grep` are left out by default and Claude searches with `find` and `grep` through `Bash`. Claude Code doesn't build a vector index of your code; it searches with these tools (agentic search, see [RAG](../01-ai-foundations/04-rag.md)). The full list is in the [tools reference](https://code.claude.com/docs/en/tools-reference).

MCP tools appear as `mcp__<server>__<tool>`, for example `mcp__github__create_issue` (see [MCP](07-mcp.md)).

### Permission rules

Rules live in the `permissions` block of a settings file, and you can edit them with `/permissions`. Format: `Tool` or `Tool(specifier)`.

```json
{
  "permissions": {
    "allow": ["Bash(npm run *)", "Bash(git commit *)", "WebFetch(domain:docs.github.com)"],
    "ask": ["Bash(git push *)"],
    "deny": ["Read(./.env)", "Read(./secrets/**)", "Bash(rm -rf *)", "mcp__github__delete_repository"]
  }
}
```

- Rules are checked in order **deny → ask → allow**. The first match wins, and a deny can't be overridden by a more specific allow.
- A deny that names a whole tool (`"WebFetch"`) removes the tool from Claude's context.
- Put `*` after the subcommand: `Bash(git log *)` allows only `git log`; `Bash(git *)` allows every git command.
- Bash rules match the command as written. `Bash(git push *)` doesn't catch `git -C . push`. Treat Bash deny rules as guardrails, not a security boundary.
- Settings files, in precedence order: managed policy, CLI flags, `.claude/settings.local.json`, `.claude/settings.json`, `~/.claude/settings.json`. A deny at any level wins.
- One-off flags: `--allowedTools`, `--disallowedTools`, and `--tools` (restricts which built-in tools exist at all).

When you answer "Yes, and don't ask again" to a prompt, the rule is saved to `.claude/settings.local.json`.

### Permission modes

Cycle with `Shift+Tab`, or start with `--permission-mode <mode>`. Set the default with `defaultMode` in settings.

| Mode                | Runs without asking                                    | Use for                                  |
| ------------------- | ------------------------------------------------------ | ---------------------------------------- |
| `default` (Manual)  | Reads only                                             | Sensitive work, reviewing every step     |
| `acceptEdits`       | Reads, file edits, common filesystem commands          | Iterating on code you're reviewing       |
| `plan`              | Reads and read-only commands; no edits                 | Exploring and designing before coding    |
| `auto`              | Most actions; a classifier model reviews risky ones    | Long tasks with fewer interruptions      |
| `dontAsk`           | Only pre-approved tools; everything else is denied     | Locked-down scripts and CI               |
| `bypassPermissions` | Everything (except a few protected actions)            | Only inside an isolated container or VM  |

Admins can disable `auto` and `bypassPermissions` through managed settings.

### Sandbox

`/sandbox` (or `"sandbox": { "enabled": true }` in settings) runs shell commands inside an OS-level sandbox: Seatbelt on macOS, `bubblewrap` on Linux and WSL2. Native Windows has no sandbox; use WSL2.

By default, sandboxed commands can write only to the working directory and a temp directory, and network access goes through a proxy with an allowlist of domains (empty at first). Reads are mostly open, including `~/.ssh`, so add `sandbox.filesystem.denyRead` for credential paths. With the sandbox on, sandboxed commands can run without prompts, because the sandbox is the boundary. Claude may ask to retry a failed command outside the sandbox; decline unless you expected it.

The sandbox covers shell commands and their child processes only. The `Read`, `Edit` and `WebFetch` tools, local MCP servers, and hooks run outside it and follow permission rules instead (a sandbox `denyRead` doesn't stop the `Read` tool, so pair it with a `Read(...)` deny rule). To isolate everything, run Claude Code in a dev container or VM.

## OpenCode

### Built-in tools

`read`, `edit`, `write`, `apply_patch`, `grep`, `glob`, `bash`, `webfetch`, `websearch`, `todowrite`, `skill`, `question`, and `lsp` (experimental). Subagents are launched through the `task` permission. MCP tools are prefixed with the server name, so a rule like `"mymcp_*"` matches every tool from one server.

### Permissions

The `permission` key in `opencode.json` takes `"allow"`, `"ask"`, or `"deny"`, either for everything or per tool, with glob patterns. The **last matching rule wins**, so put the catch-all first:

```json
{
  "$schema": "https://opencode.ai/config.json",
  "permission": {
    "edit": "ask",
    "bash": {
      "*": "ask",
      "git status *": "allow",
      "git diff *": "allow",
      "git push *": "deny"
    },
    "webfetch": "ask"
  }
}
```

- Defaults are permissive: most tools are `allow`. `.env` files are denied for `read`, and `external_directory` (paths outside the project) and `doom_loop` (the same tool call repeated three times) default to `ask`.
- `edit` covers all file changes (`edit`, `write`, `apply_patch`).
- Agents can override permissions in their own config (see [Agents](08-agents.md)). The built-in **Plan** agent asks before edits and shell commands, so it's OpenCode's equivalent of plan mode.

### Sandbox

OpenCode doesn't document a built-in sandbox. Use permissions plus a container or VM for unattended runs.

## GitHub Copilot CLI

### Built-in tools

Tool names used in rules and hooks include `view` (read), `create`, `edit`, `glob`, `grep`, `bash` / `powershell`, `web_fetch`, `web_search`, `task` (subagents), and `ask_user`. MCP tools are addressed by server name: `MyServer(tool_name)`.

### Permissions

Read-only operations run without asking. File writes, non-read-only shell commands, and URL access ask first. Approvals for "this repo" are saved to `~/.copilot/permissions-config.json`.

Command-line rules use `Kind(argument)`, where the kind is `shell`, `write`, `read`, `url`, `memory`, or an MCP server name:

```shell
copilot --allow-tool='shell(git:*)' --deny-tool='shell(git push)' --deny-tool='read(.env)'
```

- Deny always wins over allow, even with `--allow-all`.
- `shell(git:*)` matches `git` followed by a space, so it doesn't match `gitea`.
- `--available-tools` and `--excluded-tools` control which tools the model sees at all (for example `--excluded-tools='web_fetch, web_search'`).
- `--allow-all-tools` is required for non-interactive `copilot -p` runs that use tools. `--allow-all` (alias `--yolo`) also allows all paths and URLs; use it only in an isolated environment.
- In a session: `/permissions` switches mode, `/allow-all` (alias `/yolo`) allows everything, `/permissions reset` or `/reset-allowed-tools` revokes session approvals.

### Modes

`Shift+Tab` cycles **standard → plan → autopilot**. Plan mode explores and writes a plan without editing project files. Autopilot keeps working until the task is complete. Start in them with `--plan`, `--autopilot`, or `--mode`.

### Sandbox

Copilot CLI has an OS-level shell sandbox: `/sandbox` to configure it, `--sandbox` or `--no-sandbox` for one session. Organizations can enforce it through managed policy.
