# AI-Assisted Development

This chapter is about the three coding harnesses I use day to day: **Claude Code**, **OpenCode**, and **GitHub Copilot CLI**, with Claude Code as the main focus. The concepts behind them (agents, the agent loop, harnesses, skills, hooks, MCP) are covered in [Agentic Engineering](../02-agentic-engineering/README.md). This chapter is the practical side: commands, files, config, and workflows.

## Claude Code

Anthropic's agentic coding tool. Runs in the terminal, IDEs (VS Code, JetBrains), the desktop app, and the web.

- Install (macOS, Linux, WSL): `curl -fsSL https://claude.ai/install.sh | bash`
- Install (Windows PowerShell): `irm https://claude.ai/install.ps1 | iex`, or `winget install Anthropic.ClaudeCode`
- User config: `~/.claude/` (`settings.json`, `CLAUDE.md`, `skills/`, `agents/`, `rules/`), plus `~/.claude.json` (user and local MCP servers, per-project state)
- Project config: `.claude/` (`settings.json`, `settings.local.json`, `skills/`, `agents/`, `rules/`), `CLAUDE.md`, `.mcp.json`

Links:

- [Official documentation](https://code.claude.com/docs)
- [Quickstart](https://code.claude.com/docs/en/quickstart)
- [VS Code extension](https://code.claude.com/docs/en/vs-code)

## OpenCode

Open-source coding agent with a terminal UI. Works with many model providers (`/connect` to add one).

- Install: `curl -fsSL https://opencode.ai/install | bash`, or `npm install -g opencode-ai`. On Windows: `scoop install opencode` or `choco install opencode` (WSL is recommended).
- User config: `~/.config/opencode/` (`opencode.json`, `AGENTS.md`, `agents/`, `commands/`, `skills/`, `plugins/`)
- Project config: `opencode.json`, `AGENTS.md`, `.opencode/` (`agents/`, `commands/`, `skills/`, `plugins/`)

Links:

- [Official documentation](https://opencode.ai/docs/)

## GitHub Copilot CLI

GitHub Copilot's coding agent in the terminal. Uses your Copilot subscription and its model list.

- Install: `npm install -g @github/copilot`, or `winget install GitHub.Copilot` on Windows
- User config: `~/.copilot/` (`settings.json`, `mcp-config.json`, `copilot-instructions.md`, `agents/`, `skills/`, `hooks/`)
- Project config: `.github/` (`copilot-instructions.md`, `instructions/`, `agents/`, `skills/`, `hooks/`), `AGENTS.md`, `.mcp.json`

Links:

- [Official documentation](https://docs.github.com/en/copilot/concepts/copilot-surfaces/copilot-cli)
- [Command reference](https://docs.github.com/en/copilot/reference/copilot-cli-reference/cli-command-reference)

## Scope

- Prioritize Claude Code information and examples. Every note has a Claude Code section first, then OpenCode, then GitHub Copilot CLI.
- Keep each tool's guidance in its own section.
- Don't assume commands, file names, or config formats carry over between tools. Some files are read by more than one tool (`AGENTS.md`, `.claude/skills/`), and each note says so explicitly where it applies.

## Topics in this Chapter

1. [Context](01-context.md)
2. [Commands](02-commands.md)
3. [Models & Effort](03-models-and-effort.md)
4. [Tools & Permissions](04-tools-and-permissions.md)
5. [Skills & Commands](05-skills.md)
6. [Hooks](06-hooks.md)
7. [MCP](07-mcp.md)
8. [Agents](08-agents.md)
9. [Workflows](09-workflows.md)
