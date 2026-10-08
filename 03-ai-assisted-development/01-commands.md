# AI Coding Tools CLI & Commands

## Claude Code

Claude Code CLI options and commands.

**CLI:**

| Command         | Description                      |
| --------------- | -------------------------------- |
| `claude`        | Opens claude in current folder   |
| `claude --help` | Show help and available commands |
| `claude -r`     | Resumes conversation             |
| `claude -rc`    | Remote control                   |

**Commands:**

| Command        | Description                                                                                     |
| -------------- | ----------------------------------------------------------------------------------------------- |
| `/usage`       | Show session cost, plan usage, and activity stats                                               |
| `/resume`      | Resume a previous conversation                                                                  |
| `/context`     | Visualize current context usage as a colored grid                                               |
| `/compact`     | Free up context by summarizing the conversation so far                                          |
| `/clear`       | Start a new session with empty context; previous session stays on disk (resumable with /resume) |
| `/model`       | Set the AI model for Claude Code                                                                |
| `/effort`      | Set effort level for model usage (low \| medium \| hard)                                        |
| `/permissions` | Manage allow and deny tool permission rules                                                     |
| `/init`        | Initialize a new CLAUDE.md file with codebase documentation (AGENTS.md)                         |
| `/memory`      | Edit CLAUDE.md files and memory settings                                                        |
| `/btw`         | Ask a quick side question without interrupting the main conversation                            |
| `/rewind`      | Restore the code and/or conversation to a previous point                                        |
| `/rename`      | Renames current conversation                                                                    |
| `/mcp`         | Manage MCP servers                                                                              |
| `/agents`      | (removed) Ask Claude to create/manage subagents, or edit .claude/agents/                        |
| `/help`        | Show help and available commands                                                                |
| `Shift+Tab`    | Mode: Manual \| Accept edits \| Auto \| Plan                                                    |
| `Esc`          | Claude intrerruption                                                                            |
| `@`            | Referencia ficheros o skills                                                                    |
| `!`            | Shell mode                                                                                      |

**Links:**

- [Claude Code Official Docs](https://code.claude.com/docs)

## OpenCode

OpenCode CLI options and commands.

**CLI:**

| Command                   | Description                              |
| ------------------------- | ---------------------------------------- |
| `opencode`                | Opens OpenCode in current folder         |
| `opencode run <text>`     | Interacts with OpenCode programmatically |
| `opencode --help`         | Shows help and available commands        |
| `opencode -s <id>`        | Resumes conversation                     |
| `opencode -c`             | Resumes last conversation                |
| `opencode -prompt <text>` | Prompt to use                            |

**Commands:**

| Command     | Description                                                                                     |
| ----------- | ----------------------------------------------------------------------------------------------- |
| `/stats`    | Show session cost, plan usage, and activity stats                                               |
| `/sessions` | Resume a previous conversation                                                                  |
| `/compact`  | Free up context by summarizing the conversation so far                                          |
| `/new`      | Start a new session with empty context; previous session stays on disk (resumable with /resume) |
| `/models`   | Set the AI model for OpenCode                                                                   |
| `/effort`   | Set effort level for model usage (low \| medium \| hard)                                        |
| `/init`     | Guided setup for creating or updating AGENTS.md                                                 |
| `/btw`      | Ask a quick side question without interrupting the main conversation                            |
| `/undo`     | Undo changes                                                                                    |
| `/redo`     | Redo changes                                                                                    |
| `/mcps`     | Manage MCP servers                                                                              |
| `/agents`   | (removed) Ask Claude to create/manage subagents, or edit .claude/agents/                        |
| `/help`     | Show help and available commands                                                                |
| `/details`  | Show tool execution details                                                                     |
| `/share`    | Share session                                                                                   |
| `/update`   | Update OpenCode                                                                                 |
| `Shift+Tab` | Mode: Build \| Plan                                                                             |
| `Esc`       | OpenCode intrerruption                                                                          |
| `@`         | Referencia ficheros o skills                                                                    |
| `!`         | Shell mode                                                                                      |

**Links:**

- [OpenCode Official Docs](https://opencode.ai/docs)

## GitHub Copilot CLI

GitHub Copilot CLI commands.

**Commands:**

| Command     | Description                                                                                     |
| ----------- | ----------------------------------------------------------------------------------------------- |
| `/usage`    | Show session cost, plan usage, and activity stats                                               |
| `/resume`   | Resume a previous conversation                                                                  |
| `/context`  | Visualize current context usage as a colored grid                                               |
| `/compact`  | Free up context by summarizing the conversation so far                                          |
| `/new`      | Start a new session with empty context; previous session stays on disk (resumable with /resume) |
| `/model`    | Set the AI model for Claude Code                                                                |
| `/init`     | Initialize a new CLAUDE.md file with codebase documentation (AGENTS.md)                         |
| `/ask`      | Ask a quick side question without interrupting the main conversation                            |
| `/undo`     | Restore the code and/or conversation to a previous point                                        |
| `/rename`   | Renames current conversation                                                                    |
| `/mcp`      | Manage MCP servers                                                                              |
| `/agents`   | (removed) Ask Claude to create/manage subagents, or edit .claude/agents/                        |
| `/help`     | Show help and available commands                                                                |
| `Shift+Tab` | Mode: Standard \| Plan \| Autopilot                                                             |
| `Esc`       | Claude intrerruption                                                                            |
| `@`         | Referencia ficheros o skills                                                                    |
| `!`         | Shell mode                                                                                      |
