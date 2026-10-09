# Agents

All three tools let you define **configured agents**: named presets with their own system prompt, model, and tools. Most are used as **subagents**: the main agent hands one a task, the subagent works in its own context window, and only its final summary comes back. This keeps exploration noise out of the main conversation and lets you restrict what each agent can do.

For the concepts (what an agent is, primary agents vs subagents, orchestration patterns) see [Agents](../02-agentic-engineering/01-agents.md) and [Multi-Agent Systems](../02-agentic-engineering/03-multi-agent-systems.md).

**Subagent or not?**

- Use a subagent when the work is self-contained, produces a lot of output you don't need (searching, reading logs, running tests), or needs tighter tool restrictions.
- Stay in the main conversation for back-and-forth work, quick changes, or phases that share a lot of context.
- Use a [skill](05-skills.md) instead when you want a reusable workflow that runs in the main context.

The three tools use different file formats and fields. An agent file written for one tool doesn't carry over to another, except where noted under Copilot CLI.

## Claude Code

**Built-in subagents:**

| Agent             | Purpose                                                                    |
| ----------------- | -------------------------------------------------------------------------- |
| `Explore`         | Fast, read-only codebase search. Claude uses it to keep search results out of the main context |
| `Plan`            | Read-only research while in plan mode                                      |
| `general-purpose` | Complex multi-step tasks, including code changes                           |

**Locations** (on name clashes, the higher one wins):

```text
Managed settings        (organization)
--agents '<json>'       (current session)
.claude/agents/         (project)
~/.claude/agents/       (all your projects)
<plugin>/agents/        (where the plugin is enabled)
```

**Example:** `.claude/agents/code-reviewer.md`

```markdown
---
name: code-reviewer
description: Reviews code for quality, bugs, and security. Use after writing or changing code.
tools: Read, Glob, Grep, Bash
model: sonnet
---

You are a senior code reviewer. Review the current diff (git diff) and focus on:

- Bugs and edge cases
- Security issues
- Readability and maintainability

Report findings ordered by severity, with file and line. Do not edit files.
```

**Frontmatter:**

| Field                       | Meaning                                                                   |
| --------------------------- | ------------------------------------------------------------------------- |
| `name`, `description`       | Required. The description tells Claude when to delegate                   |
| `tools`, `disallowedTools`  | Allowlist or denylist of tools. Omit `tools` to inherit everything        |
| `model`                     | `sonnet`, `opus`, `haiku`, `fable`, a full ID, or `inherit`               |
| `effort`                    | Effort level while the subagent runs                                      |
| `permissionMode`            | `default`, `acceptEdits`, `plan`, `auto`, `dontAsk`, `bypassPermissions`  |
| `maxTurns`                  | Stop after this many agentic turns                                        |
| `skills`, `mcpServers`, `hooks` | Preload skills, give MCP servers, scope hooks to this subagent       |
| `memory`                    | Persistent memory scope: `user`, `project`, or `local`                    |
| `background`                | Always run in the background                                              |
| `isolation: worktree`       | Run in a temporary git worktree (safe parallel edits)                     |

There is **no `temperature` field**. Unknown fields are silently ignored.

**Using them:**

- Claude delegates automatically based on `description`. Ask explicitly in plain language ("use the code-reviewer subagent"), or mention it: `@agent-code-reviewer`.
- `claude --agent code-reviewer` runs the whole session as that agent.
- `/agents` no longer opens an editor: ask Claude to create the agent, or write the file yourself.
- Deny a subagent with a permission rule: `"deny": ["Agent(Explore)"]`.
- For parallel, long-running work: background sessions (`claude --bg "<task>"`, `claude agents` to monitor them) and agent teams, where several sessions coordinate. See [Multi-Agent Systems](../02-agentic-engineering/03-multi-agent-systems.md).

Reference: [Subagents](https://code.claude.com/docs/en/sub-agents)

## OpenCode

OpenCode has two kinds of agent:

- **Primary agents** you talk to directly. `Tab` switches between them. Built-in: **Build** (all tools, the default) and **Plan** (asks before edits and shell commands).
- **Subagents** the primary agent delegates to, or you invoke with `@`. Built-in: **General** (multi-step tasks), **Explore** (fast, read-only), **Scout** (read-only research in external docs and dependencies).

```text
@general help me search for this function
```

**Locations:**

```text
Global:      ~/.config/opencode/agents/<name>.md
Per-project: .opencode/agents/<name>.md
```

Or under the `agent` key in `opencode.json`. The file name is the agent name. `opencode agent create` creates one interactively.

**Example:** `.opencode/agents/review.md`

```markdown
---
description: Reviews code for quality and best practices
mode: subagent
model: anthropic/claude-sonnet-5-5
permission:
  edit: deny
  bash: deny
---

You are in code review mode. Focus on:

- Code quality and best practices
- Potential bugs and edge cases
- Performance implications
- Security considerations

Provide constructive feedback without making direct changes.
```

**Options:**

| Option          | Meaning                                                                                  |
| --------------- | ---------------------------------------------------------------------------------------- |
| `description`   | Required. What the agent does and when to use it                                         |
| `mode`          | `primary`, `subagent`, or `all` (default)                                                |
| `model`         | `provider/model-id`. Subagents default to the model of the agent that invoked them        |
| `prompt`        | Custom system prompt file, e.g. `"{file:./prompts/review.txt}"`                          |
| `permission`    | `ask`, `allow`, or `deny` per tool, with glob patterns for `bash` (see [Tools & Permissions](04-tools-and-permissions.md#opencode)) |
| `steps`         | Maximum agentic iterations before the agent must answer with text (`maxSteps` is deprecated) |
| `temperature`, `top_p` | Sampling randomness. Lower is more focused                                        |
| `hidden`        | Hide a subagent from the `@` menu                                                        |
| `disable`       | `true` disables the agent                                                                |
| `color`         | Color in the UI                                                                          |

About `temperature`: many recent models, including current Claude models, reject non-default sampling settings or ignore them. Prefer reasoning effort (model variants, see [Models & Effort](03-models-and-effort.md)) and clear instructions. If you do set it, low values (0.0–0.2) suit analysis and planning; higher values give more varied output.

Reference: [OpenCode agents](https://opencode.ai/docs/agents/)

## GitHub Copilot CLI

**Built-in agents** include `explore` (fast codebase questions), `task` (runs tests and builds, returns a short summary), `general-purpose`, `code-review`, `security-review`, `research`, and `rubber-duck` (a second opinion from a different model).

**Locations** (on ID clashes, the first one wins):

```text
~/.copilot/agents/            (user)
.github/agents/               (project, from the current folder up to the Git root)
.claude/agents/               (project, Claude-compatible)
<plugin>/agents/              (plugins)
```

Files are Markdown named `<name>.agent.md` or `<name>.md`. Copilot CLI also reads `.claude/agents/`, but its frontmatter fields differ from Claude Code's, so check that a shared agent behaves the same in both tools.

**Example:** `.github/agents/reviewer.agent.md`

```markdown
---
description: Reviews the current changes for bugs and security issues. Does not edit files.
tools: ["view", "glob", "grep", "bash"]
reasoningEffort: high
---

Review the current diff. Report findings by severity with file and line.
```

**Frontmatter:** `description` (required), `name`, `tools` (default `["*"]`), `model` or `models` (priority list), `reasoningEffort`, `mcp-servers`, `infer` (allow automatic delegation, default `true`), and `include-custom-instructions` (subagents don't get `AGENTS.md` and other instruction files unless this is `true`).

**Using them:** `/agent` to pick one, `copilot --agent=<name>` to start with it, or ask for it by name. `/fleet` runs parts of a task in parallel subagents, `/tasks` shows running ones, and `/subagents` sets which model each agent uses.

Reference: [Copilot CLI command reference: custom agents](https://docs.github.com/en/copilot/reference/copilot-cli-reference/cli-command-reference)
