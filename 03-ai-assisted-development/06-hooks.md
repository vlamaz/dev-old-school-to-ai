# Hooks

A hook is your own code that the harness runs automatically at a lifecycle event: before a tool runs, after a file is edited, when the agent stops. Unlike instructions, hooks always run, so they are the place for guardrails, formatting, and notifications. For the concept, see [Harness: Hooks](../02-agentic-engineering/02-harness.md).

Typical uses:

- **Guardrails:** block dangerous commands or edits to protected files before they happen.
- **Automation:** run a formatter or linter after every edit.
- **Quality gates:** run tests when the agent says it's done, and send it back if they fail.
- **Context:** inject the current branch, ticket, or environment at session start.
- **Notifications:** alert you when the agent needs input.

Each tool has its own hook system, event names, and config format. They don't carry over, with one exception noted under Copilot CLI.

## Claude Code

**Where hooks are configured** (entries from all levels are merged):

| Location                       | Scope                                   |
| ------------------------------ | --------------------------------------- |
| `~/.claude/settings.json`      | All your projects                       |
| `.claude/settings.json`        | One project, shared through the repo    |
| `.claude/settings.local.json`  | One project, just you                   |
| Managed policy settings        | Organization-wide                       |
| Plugin `hooks/hooks.json`      | While the plugin is enabled             |
| Skill or subagent frontmatter  | While that skill or subagent is active  |

`/hooks` shows what is configured.

### Format

`hooks` is an object keyed by **event name**. Each event has a list of matcher groups; each group has a `matcher` (a tool name, or alternatives like `Edit|Write`) and a list of handlers.

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "if": "Bash(rm *)",
            "command": "${CLAUDE_PROJECT_DIR}/.claude/hooks/block-recursive-rm.sh"
          }
        ]
      }
    ],
    "PostToolUse": [
      {
        "matcher": "Edit|Write",
        "hooks": [
          { "type": "command", "command": "jq -r '.tool_input.file_path' | xargs npx prettier --write" }
        ]
      }
    ]
  }
}
```

The optional `if` field narrows a handler further, using [permission rule syntax](04-tools-and-permissions.md#permission-rules).

### Example: block recursive `rm`

The hook receives the event as JSON on stdin. Parse the field you need instead of grepping the whole payload, and write the reason to **stderr**:

```bash
#!/bin/bash
# .claude/hooks/block-recursive-rm.sh
COMMAND=$(jq -r '.tool_input.command')

if echo "$COMMAND" | grep -Eq '(^|[;&|[:space:]])rm[[:space:]]+-[a-zA-Z]*[rR]'; then
  echo "Blocked: recursive rm is not allowed. Delete specific files instead." >&2
  exit 2
fi

exit 0
```

This is a guardrail, not a sandbox: a determined command can delete files in other ways (`find -delete`, a script). For real isolation use the [sandbox](04-tools-and-permissions.md#sandbox) or a container. The script needs `jq` and must be executable.

### Exit codes and output

| Exit code       | Effect                                                                                                    |
| --------------- | --------------------------------------------------------------------------------------------------------- |
| `0`             | Success. For most events stdout goes to the debug log; for `SessionStart` and `UserPromptSubmit` it's added to the context |
| `2`             | Block (on events that can block). Stderr is fed back to Claude as the reason                              |
| Other non-zero  | Non-blocking error. The action continues                                                                  |

For finer control, exit 0 and print JSON. For example, a `PreToolUse` hook can return `"permissionDecision": "deny"` (or `"allow"`, `"ask"`) with a reason.

### Main events

Claude Code has over 30 events; these are the ones I use most:

| Event              | Fires                                         | Typical use                                                          |
| ------------------ | --------------------------------------------- | -------------------------------------------------------------------- |
| `SessionStart`     | A session starts, resumes, or is cleared      | Inject context (branch, ticket), check dependencies                   |
| `UserPromptSubmit` | Before Claude processes your prompt           | Add context, block prompts containing secrets                        |
| `PreToolUse`       | Before a tool call runs (can block it)        | Security gates: dangerous commands, protected files                  |
| `PermissionRequest`| When a permission prompt would appear         | Auto-approve or deny specific requests                               |
| `PostToolUse`      | After a tool call **succeeds**                | Run formatters or linters on edited files                            |
| `PostToolUseFailure` | After a tool call fails                     | Log failures                                                         |
| `Notification`     | Claude Code sends a notification (e.g. needs permission, idle) | Desktop or Slack alerts                             |
| `Stop`             | Claude finishes responding                    | Run tests; block to make Claude keep working until they pass         |
| `SubagentStop`     | A subagent finishes                           | Check a subagent's output                                            |
| `PreCompact`       | Before context compaction                     | Save state before the conversation is summarized                     |
| `SessionEnd`       | The session ends                              | Cleanup, logging                                                     |

Notes:

- `PostToolUse` can't undo anything: the tool already ran. Use `PreToolUse` to prevent.
- `Stop` fires every time Claude finishes a response, not only when a task is complete. A `Stop` hook that blocks needs a way out, or Claude loops.
- Besides `command`, handlers can be `http` (POST to a URL), `prompt` or `agent` (a model judges the event), or `mcp_tool`.

Reference: [Hooks guide](https://code.claude.com/docs/en/hooks-guide) · [Hooks reference](https://code.claude.com/docs/en/hooks)

## OpenCode

OpenCode has no settings-based hooks. The equivalent is a **plugin**: a JavaScript or TypeScript module that returns handlers for events.

**Locations:** `.opencode/plugins/` (project) or `~/.config/opencode/plugins/` (global). They load automatically at startup.

**Example:** block reading `.env` files (`.opencode/plugins/env-protection.js`):

```js
export const EnvProtection = async ({ project, client, $, directory, worktree }) => {
  return {
    "tool.execute.before": async (input, output) => {
      if (input.tool === "read" && output.args.filePath.includes(".env")) {
        throw new Error("Do not read .env files")
      }
    },
  }
}
```

Useful handlers:

| Handler               | Fires                                                    |
| --------------------- | -------------------------------------------------------- |
| `tool.execute.before` | Before a tool runs. Throw an error to block it           |
| `tool.execute.after`  | After a tool runs                                        |
| `event`               | Any event, e.g. `session.idle` when the agent finishes   |
| `shell.env`           | Inject environment variables into shell commands         |

Reference: [OpenCode plugins](https://opencode.ai/docs/plugins/)

## GitHub Copilot CLI

**Where hooks are configured** (all sources are combined):

- `.github/hooks/*.json` in the repository
- `~/.copilot/hooks/*.json` (user)
- A `hooks` block in `.github/copilot/settings.json`, `.github/copilot/settings.local.json`, or `~/.copilot/settings.json`
- Plugins, and machine-wide policy files

**Format:** a versioned file with **camelCase** event names. Each handler can give separate Bash and PowerShell commands:

```json
{
  "version": 1,
  "hooks": {
    "preToolUse": [
      {
        "type": "command",
        "matcher": "bash|powershell",
        "bash": "./.github/hooks/check-command.sh",
        "powershell": "./.github/hooks/check-command.ps1",
        "timeoutSec": 10
      }
    ]
  }
}
```

The script gets JSON on stdin (`toolName`, `toolArgs`, `cwd`…). To deny the call, exit 2 or print `{"permissionDecision": "deny", "permissionDecisionReason": "..."}`. For `preToolUse`, any crash also denies (fail-closed), but a timeout lets the call through.

**Events:** `sessionStart`, `userPromptSubmitted`, `preToolUse`, `permissionRequest`, `postToolUse`, `postToolUseFailure`, `agentStop`, `subagentStart`, `subagentStop`, `preCompact`, `notification`, `errorOccurred`, `sessionEnd`.

**Claude Code compatibility:** Copilot CLI also reads hooks from the repository's `.claude/settings.json` and `.claude/settings.local.json`. Hooks written with Claude's PascalCase names (`PreToolUse`) get Claude-style matchers and a snake_case payload (`tool_name`, `tool_input`). Copilot maps its own tool names to Claude's for matching (`bash` → `Bash`), but the tools and payloads still differ, so test shared hooks in both tools.

Reference: [Copilot hooks reference](https://docs.github.com/en/copilot/reference/hooks-reference)
