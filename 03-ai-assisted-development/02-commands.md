# Commands

The commands I use most in each tool, grouped by task. Each tool has many more: run `/help` (all three tools), or check the official references linked at the end of each section.

## Comparison by Task

"—" means the tool has no direct equivalent. Even when the name is the same, the behavior can differ, so check the tool's own section.

| Task                       | Claude Code                    | OpenCode                         | GitHub Copilot CLI               |
| -------------------------- | ------------------------------ | -------------------------------- | -------------------------------- |
| Start in current folder    | `claude`                       | `opencode`                       | `copilot`                        |
| One-shot, non-interactive  | `claude -p "<prompt>"`         | `opencode run "<prompt>"`        | `copilot -p "<prompt>"`          |
| Continue last session      | `claude -c`                    | `opencode -c`                    | `copilot --continue`             |
| Resume a specific session  | `claude -r [id\|name]`         | `opencode -s <id>`               | `copilot --resume[=<id>]`        |
| Pick a session (in TUI)    | `/resume`                      | `/sessions`                      | `/resume`                        |
| New empty session          | `/clear`                       | `/new`                           | `/clear` or `/new`               |
| Summarize to free context  | `/compact`                     | `/compact`                       | `/compact`                       |
| Show context usage         | `/context`                     | —                                | `/context`                       |
| Usage and cost             | `/usage`                       | `opencode stats` (CLI)           | `/usage`                         |
| Change model               | `/model`                       | `/models`                        | `/model`                         |
| Change effort              | `/effort`                      | `Ctrl+T` (model variant)         | `/model` (effort per model)      |
| Plan before coding         | `/plan` or `Shift+Tab`         | `Tab` to the Plan agent          | `/plan` or `Shift+Tab`           |
| Undo changes               | `/rewind` (or `Esc` `Esc`)     | `/undo`, `/redo`                 | `/undo` or `/rewind`             |
| Side question              | `/btw`                         | —                                | `/ask` or `/btw`                 |
| Generate instructions file | `/init` → `CLAUDE.md`          | `/init` → `AGENTS.md`            | `/init` → `.github/copilot-instructions.md` |
| MCP servers                | `/mcp`                         | `opencode mcp` (CLI)             | `/mcp`                           |
| Skills                     | `/skills`                      | — (loaded by the agent)          | `/skills`                        |
| Agents                     | `/agents`                      | `opencode agent` (CLI)           | `/agent`                         |
| Permissions                | `/permissions`                 | `permission` in `opencode.json`  | `/permissions`                   |
| Update the tool            | `claude update`                | `opencode upgrade`               | `/update`                        |

## Claude Code

**CLI:**

| Command                        | Description                                                                                  |
| ------------------------------ | -------------------------------------------------------------------------------------------- |
| `claude`                       | Start an interactive session in the current folder                                           |
| `claude "query"`               | Start an interactive session with an initial prompt                                          |
| `claude -p "query"`            | Run once without the interactive UI and print the result (headless, scripts, CI)             |
| `claude -c`                    | Continue the most recent conversation in this folder                                         |
| `claude -r [id\|name]`         | Resume a specific session, or open the picker                                                |
| `claude -n <name>`             | Name the session (shown in `/resume`)                                                        |
| `claude -w [name]`             | Start in an isolated git worktree under `.claude/worktrees/`                                 |
| `claude --model <alias\|id>`   | Set the model for this session (`opus`, `sonnet`, `haiku`, `fable`, or a full ID)            |
| `claude --effort <level>`      | Set the effort level for this session                                                        |
| `claude --permission-mode <m>` | Start in a permission mode (`default`, `acceptEdits`, `plan`, `auto`, `dontAsk`, `bypassPermissions`) |
| `claude --remote-control`      | Start a session you can also control from claude.ai or the Claude app (alias `--rc`)         |
| `claude --advisor <model>`     | Turn on the advisor tool: the main model consults a second model (`fable`, `opus`, `sonnet`) for guidance |
| `claude update`                | Update to the latest version                                                                 |
| `claude --help`                | Show help (it doesn't list every flag; see the CLI reference)                                |

**Slash commands:**

| Command          | Description                                                                                         |
| ---------------- | --------------------------------------------------------------------------------------------------- |
| `/usage`         | Session cost, plan usage limits, and activity stats (aliases `/cost`, `/stats`)                     |
| `/resume`        | Resume a previous conversation                                                                      |
| `/clear`         | Start a new conversation with empty context. The old one stays resumable (aliases `/new`, `/reset`) |
| `/compact`       | Summarize the conversation to free context. Accepts focus instructions                              |
| `/context`       | Visualize current context usage as a colored grid                                                   |
| `/model`         | Switch model. Left/right arrows adjust effort                                                       |
| `/effort`        | Set effort: `low`, `medium`, `high`, `xhigh`, `max`, or `auto` (back to the default)                |
| `/plan`          | Enter plan mode, optionally with a task: `/plan fix the auth bug`                                   |
| `/rewind`        | Restore code and/or conversation to an earlier point (aliases `/checkpoint`, `/undo`)               |
| `/btw`           | Ask a side question without adding it to the conversation                                           |
| `/rename`        | Rename the current session                                                                          |
| `/init`          | Generate a `CLAUDE.md` for the project                                                              |
| `/memory`        | Edit `CLAUDE.md` files and manage auto memory                                                       |
| `/permissions`   | Manage allow, ask, and deny rules                                                                   |
| `/sandbox`       | Toggle OS-level sandboxing for shell commands                                                       |
| `/skills`        | List available skills                                                                               |
| `/hooks`         | View hook configuration                                                                             |
| `/mcp`           | Manage MCP server connections and authentication                                                    |
| `/agents`        | Reminds you to ask Claude to create subagents, or to edit `.claude/agents/` directly                |
| `/plugin`        | Manage plugins and marketplaces                                                                     |
| `/config`        | Open settings                                                                                       |
| `/doctor`        | Diagnose installation, settings, and `CLAUDE.md` problems                                           |
| `/remote-control`| Make this session available from claude.ai (alias `/rc`)                                            |
| `/help`          | Show help and available commands                                                                    |

**Shortcuts:**

| Shortcut     | Description                                                                                   |
| ------------ | --------------------------------------------------------------------------------------------- |
| `Shift+Tab`  | Cycle permission modes: Manual → Accept edits → Plan → Auto (when available)                  |
| `Esc`        | Interrupt Claude. It keeps the work done so far                                               |
| `Esc` `Esc`  | With empty input, open the rewind menu                                                        |
| `@`          | Mention a file path (autocomplete). `@agent-<name>` invokes a subagent                        |
| `/<skill>`   | Invoke a skill by name                                                                        |
| `!`          | Shell mode: run a command and add its output to the session                                   |

**Links:**

- [CLI reference](https://code.claude.com/docs/en/cli-reference)
- [Commands](https://code.claude.com/docs/en/commands)
- [Interactive mode and shortcuts](https://code.claude.com/docs/en/interactive-mode)
- [Advisor tool](https://code.claude.com/docs/en/advisor)

## OpenCode

**CLI:**

| Command                        | Description                                                         |
| ------------------------------ | ------------------------------------------------------------------- |
| `opencode`                     | Open the TUI in the current folder                                  |
| `opencode --prompt "<text>"`   | Open the TUI with an initial prompt                                 |
| `opencode run "<text>"`        | Run once without the TUI (scripts, CI)                              |
| `opencode -c`                  | Continue the last session                                           |
| `opencode -s <id>`             | Continue a specific session                                         |
| `opencode -m <provider/model>` | Set the model                                                       |
| `opencode --agent <name>`      | Start with a specific agent                                         |
| `opencode run --variant <v>`   | Set the model variant (provider-specific reasoning effort)          |
| `opencode models`              | List available models                                               |
| `opencode stats`               | Token usage and cost statistics                                     |
| `opencode mcp add\|list\|auth` | Manage MCP servers                                                  |
| `opencode agent create\|list`  | Manage agents                                                       |
| `opencode upgrade`             | Update OpenCode                                                     |
| `opencode --help`              | Show help and available commands                                    |

**Slash commands:**

| Command     | Description                                                                      |
| ----------- | -------------------------------------------------------------------------------- |
| `/connect`  | Add a provider and its API key                                                   |
| `/sessions` | List and switch sessions (aliases `/resume`, `/continue`)                        |
| `/new`      | Start a new session (alias `/clear`)                                             |
| `/compact`  | Compact the current session (alias `/summarize`)                                 |
| `/models`   | List and pick models                                                             |
| `/init`     | Create or update `AGENTS.md`                                                     |
| `/undo`     | Remove the last message, later responses, and their file changes                 |
| `/redo`     | Redo after `/undo`                                                               |
| `/details`  | Toggle tool execution details                                                    |
| `/thinking` | Toggle visibility of thinking blocks (display only)                              |
| `/share`    | Share the session (`/unshare` stops sharing)                                     |
| `/export`   | Export the conversation to Markdown                                              |
| `/editor`   | Compose the message in your external editor                                      |
| `/help`     | Show help                                                                        |

**Shortcuts:**

| Shortcut    | Description                                          |
| ----------- | ---------------------------------------------------- |
| `Tab`       | Cycle primary agents (Build ↔ Plan)                  |
| `Shift+Tab` | Cycle primary agents in reverse                      |
| `Ctrl+T`    | Cycle model variants (reasoning effort)              |
| `Esc`       | Interrupt the session                                |
| `@`         | Fuzzy-search a file and add it, or invoke a subagent |
| `!`         | Run a shell command; output is added as a tool result |

**Links:**

- [CLI](https://opencode.ai/docs/cli/)
- [TUI commands](https://opencode.ai/docs/tui/)
- [Keybinds](https://opencode.ai/docs/keybinds/)

## GitHub Copilot CLI

**CLI:**

| Command                     | Description                                                              |
| --------------------------- | ------------------------------------------------------------------------ |
| `copilot`                   | Start an interactive session in the current folder                       |
| `copilot -p "<prompt>"`     | Run once and exit (scripts, CI). Needs tool approvals up front           |
| `copilot --continue`        | Resume the most recent session in this folder                            |
| `copilot --resume[=<id>]`   | Resume a specific session, or pick one                                   |
| `copilot --model=<model>`   | Set the model (`auto` lets Copilot choose)                               |
| `copilot --effort=<level>`  | Set reasoning effort (`low` … `max`). Alias `--reasoning-effort`         |
| `copilot --plan`            | Start in plan mode                                                       |
| `copilot --autopilot`       | Keep working until the task is complete                                  |
| `copilot --agent=<name>`    | Use a custom agent                                                       |
| `copilot --help`            | Show help                                                                |

**Slash commands:**

| Command         | Description                                                                         |
| --------------- | ----------------------------------------------------------------------------------- |
| `/usage`        | Session usage metrics, including per-model token totals                             |
| `/resume`       | Switch to a different session (alias `/continue`)                                   |
| `/clear`        | Start a new conversation (aliases `/new`, `/reset`). `/new worktree` uses a new worktree |
| `/compact`      | Summarize history to reduce context usage                                           |
| `/context`      | Show context window usage                                                           |
| `/model`        | Select the model or Auto, and its reasoning effort (alias `/models`)                |
| `/plan`         | Create an implementation plan before coding                                         |
| `/autopilot`    | Start or refocus autopilot mode                                                     |
| `/undo`         | Roll the session back to an earlier turn (alias `/rewind`)                          |
| `/ask`          | Ask a side question without adding it to history (alias `/btw`)                     |
| `/rename`       | Rename the current session                                                          |
| `/init`         | Generate `.github/copilot-instructions.md`                                          |
| `/instructions` | View and toggle instruction files                                                   |
| `/env`          | Show loaded instructions, MCP servers, skills, agents, hooks, plugins               |
| `/mcp`          | Manage MCP server configuration                                                     |
| `/skills`       | List, add, and remove skills                                                        |
| `/agent`        | Browse and select custom agents                                                     |
| `/fleet`        | Run parts of a task in parallel subagents                                           |
| `/review`       | Run the code review agent on your changes                                           |
| `/permissions`  | Switch permission mode; `/permissions reset` clears session approvals               |
| `/sandbox`      | Configure the OS-level shell sandbox                                                |
| `/update`       | Update the CLI                                                                      |
| `/help`         | Show help                                                                           |

**Shortcuts:**

| Shortcut    | Description                                                     |
| ----------- | --------------------------------------------------------------- |
| `Shift+Tab` | Cycle modes: standard → plan → autopilot                        |
| `Esc`       | Cancel the current operation. Press twice to interrupt the turn |
| `@`         | Include a file's contents in the context                        |
| `!`         | Run a shell command directly, bypassing Copilot                 |

**Links:**

- [Command reference](https://docs.github.com/en/copilot/reference/copilot-cli-reference/cli-command-reference)
