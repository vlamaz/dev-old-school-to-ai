# Context

The harness builds the context the model sees on every turn: system prompt, instruction files, tool definitions, the conversation, and tool results. See [Harness](../02-agentic-engineering/02-harness.md) for the concept, [Context window](../01-ai-foundations/01-LLMs.md) for the limit, and [Context Engineering](../01-ai-foundations/06-context-engineering.md) for techniques.

In Claude Code, OpenCode, and GitHub Copilot CLI, a **good context window** is not about adding more files. It's about adding the right files.

## How Each Tool Loads Context

Only instruction files are loaded automatically. Everything else (README, specs, docs, source files) enters the context only when the agent reads it, you reference it, or an instruction file imports it.

|                       | Claude Code                                                                                                                 | OpenCode                                                                                      | GitHub Copilot CLI                                                                                                                    |
| --------------------- | --------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------- |
| Project instructions  | `CLAUDE.md` or `.claude/CLAUDE.md`, plus `CLAUDE.local.md` (personal, gitignored). `AGENTS.md` by default only if none exist. | `AGENTS.md`. `CLAUDE.md` is a fallback, used only if no `AGENTS.md` exists.                   | `AGENTS.md`, `CLAUDE.md`, `GEMINI.md`, and `.github/copilot-instructions.md` (all merged).                                            |
| Personal instructions | `~/.claude/CLAUDE.md`, `~/.claude/rules/`                                                                                   | `~/.config/opencode/AGENTS.md` (falls back to `~/.claude/CLAUDE.md`)                          | `~/.copilot/copilot-instructions.md`, `~/.copilot/instructions/**/*.instructions.md`                                                  |
| Scoped rules          | `.claude/rules/*.md` with `paths:` frontmatter                                                                              | `instructions` array in `opencode.json` (globs and URLs)                                      | `.github/instructions/**/*.instructions.md` with `applyTo:` (or `paths:`) frontmatter. Also reads `.claude/rules/`.                   |
| File imports          | `@path` (loaded at launch)                                                                                                  | Not automatic. Use the `instructions` array, or tell the agent in `AGENTS.md` to read a file. | `@path`, relative to the instruction file or absolute, in `AGENTS.md`, `CLAUDE.md` and `copilot-instructions.md`                      |
| `/init` generates     | `CLAUDE.md`                                                                                                                 | `AGENTS.md`                                                                                   | `.github/copilot-instructions.md`                                                                                                     |
| Memory                | Auto memory written by Claude, stored outside the repo                                                                      | No built-in memory file documented                                                            | Built-in memory, not a repository file                                                                                                |
| Check what is loaded  | `/context`, `/memory`                                                                                                       | Not documented                                                                                | `/instructions`, `/env`                                                                                                               |

Notes:

- Instruction files are advisory context, not enforcement. To enforce behavior, use [permissions](04-tools-and-permissions.md) or [hooks](06-hooks.md).
- Keep instruction files short and specific. Claude Code recommends under 200 lines per `CLAUDE.md`. Put sometimes-relevant knowledge in [skills](05-skills.md) or scoped rules.
- Do not assume files are interchangeable between tools. The table shows which files each tool reads.

### Claude Code

- `CLAUDE.md` and `CLAUDE.local.md` files in the working directory and every directory above it load at launch. Files in subdirectories load on demand, when Claude works with files there.
- Rules in `.claude/rules/` without `paths:` load at launch. Rules with `paths:` load only when Claude touches matching files. This is the main way to keep context small in a large repo.
- `@path` imports help organize a long file but don't save context: imported files load at launch too.
- `AGENTS.md`: by default Claude Code reads it only when there is no `CLAUDE.md`, `.claude/CLAUDE.md` or `CLAUDE.local.md` in the working directory or above. To load both, set **Project instructions** to `claude-md-and-agents-md` in `/config`, or import it (see [Using AGENTS.md with Claude Code](#using-agentsmd-with-claude-code)).
- Auto memory: Claude writes notes to `~/.claude/projects/<project>/memory/`. The index, `MEMORY.md`, loads every session (first 200 lines or 25KB). It's local to your machine. A `MEMORY.md` in the project root is **not** loaded automatically. Manage it with `/memory`. See [Memory](../02-agentic-engineering/04-memory.md).
- `/context` shows what is using the context window. `/compact` summarizes the conversation; `/clear` starts fresh.

### OpenCode

- Searches upward from the current directory for `AGENTS.md`, then `CLAUDE.md`. The first match wins, so an `AGENTS.md` hides a `CLAUDE.md` in the same place.
- Global: `~/.config/opencode/AGENTS.md`, falling back to `~/.claude/CLAUDE.md`.
- Extra rule files go in the `instructions` array of `opencode.json`. They are combined with `AGENTS.md`:

  ```json
  {
    "$schema": "https://opencode.ai/config.json",
    "instructions": ["docs/coding-standards.md", ".cursor/rules/*.md"]
  }
  ```

- `@file` references inside `AGENTS.md` are **not** parsed. Use `instructions`, or tell the agent to read the file when needed.
- `OPENCODE_DISABLE_CLAUDE_CODE=1` turns off all `.claude` compatibility (`CLAUDE.md`, `.claude/skills`).

### GitHub Copilot CLI

- Loads every instruction source at once and merges them: `AGENTS.md`, `CLAUDE.md`, `GEMINI.md`, `.github/copilot-instructions.md`, `.github/instructions/`, `.claude/rules/` (in the Git root and the current directory), plus the personal files in `~/.copilot/`.
- Because everything is merged, a repo with both `AGENTS.md` and a `CLAUDE.md` that imports it may load the same text twice. Check with `/instructions`, which also lets you toggle files.
- `/env` shows everything loaded: instructions, MCP servers, skills, agents, hooks.
- `--no-custom-instructions` starts a session without them.

## Project Essential Files

Except for the instruction files, none of these are loaded automatically. Reference them in your prompt (for example `@specs/booking/requirements.md`) or import them from an instruction file.

### README.md

The project entry point. Human documentation: what the project is.

```markdown
# Taxi Booking Platform

## Purpose

Allows users to book taxis.

## Tech Stack

- React
- Node.js
- PostgreSQL

## Architecture

Hexagonal Architecture
```

Provides: project overview, tech stack, architecture summary.

### AGENTS.md

The main instructions file for AI agents. It is a cross-tool convention: native in OpenCode and Copilot CLI, and read by Claude Code only when no `CLAUDE.md` exists (by default). It holds workflow guidance: how AI agents should work in this repo.

```markdown
# Agent Instructions

## Architecture

Use Hexagonal Architecture.

## Commands

- Build: `npm run build`
- Test: `npm test`
- Lint: `npm run lint`

## Coding Standards

- TypeScript strict mode
- ESLint required

## Testing

All business logic requires tests.

## Workflow

Plan before implementing.
```

Should contain at least:

- Project overview
- Build and test commands
- Code style guidelines
- Testing instructions
- Security considerations

Include only what the agent cannot infer from the code. Avoid file-by-file descriptions, long tutorials, and information that changes frequently.

Location:

```text
project/
└── AGENTS.md
```

Examples: <https://agents.md/#examples>

#### Using AGENTS.md with Claude Code

To keep `AGENTS.md` as the single source and still add Claude-specific notes, create a `CLAUDE.md` that imports it:

```markdown
@AGENTS.md

## Claude Code

Use plan mode for changes under `src/billing/`.
```

Prefer the import over a symlink on Windows, where symlinks need Developer Mode or Administrator rights. Copilot CLI reads both files, so it sees `AGENTS.md` through both paths.

### Shared Knowledge

Long-term knowledge (decisions, lessons learned) does not have a standard file across tools, and each tool's memory is local to one machine (see above). For knowledge the whole team and every tool should share, commit it instead:

- Decisions and their reasons: [ADRs](#adrs)
- Rules and conventions: `AGENTS.md` (or `CLAUDE.md`)
- Requirements: [Specifications](#specifications)

### Specifications

Often the most useful task-specific context. Not loaded automatically: reference the relevant spec in your prompt.

```markdown
# Booking Requirements

Users can:

- Create bookings
- Cancel bookings
- Schedule rides
```

Provides: what to build, why it exists, acceptance criteria.

The folder layout depends on the SDD framework you use. One common layout:

```text
specs/
├── booking/
│   ├── requirements.md
│   ├── design.md
│   └── tasks.md
```

See: [Spec-Driven Development (SDD)](../04-spec-driven-development/README.md)

### Architecture Documents

```text
docs/
├── architecture.md
├── api.md
└── domain-model.md
```

Example:

```markdown
# Architecture

Frontend
↓
API
↓
Application Layer
↓
Domain Layer
```

Provides: system design, boundaries, dependencies.

Keep it to decisions and boundaries that are not obvious from the code. Leave out what the agent can derive by reading the codebase, such as directory layouts and dependency lists.

### Domain Knowledge

```text
knowledge/
├── glossary.md
├── business-rules.md
└── taxi-domain.md
```

Example:

```markdown
A booking cannot be cancelled
after driver pickup.
```

Provides: business terminology and business rules.

### ADRs

Architecture Decision Records, usually in `docs/adr/`.

```markdown
ADR-001

Use PostgreSQL.

Reason:
Strong transactional consistency.
```

Provides: why decisions were made.

### Coding Standards

Usually `docs/coding-standards.md`, or a scoped rule file if it only applies to part of the code.

```markdown
- Use async/await
- Avoid any types
- Prefer Result pattern
```

Provides: consistency and quality rules.

## Context Priority

A suggested order of importance for a task. This is a heuristic, not tool behavior; the tools load instruction files automatically and everything else on demand.

```text
1. User Request
2. Relevant Spec
3. AGENTS.md / CLAUDE.md (loaded automatically)
4. Relevant ADRs and Business Rules
5. Architecture Docs
6. Relevant Source Files
```

For example, to implement booking cancellation, point the agent to the relevant files:

```text
Implement booking cancellation following @specs/booking/requirements.md
and @docs/business-rules.md. The code lives in src/booking/.
```

Don't load:

```text
payment files
notification files
unrelated docs
```

For long tasks, keep the main context clean: delegate exploration to a [subagent](08-agents.md), `/compact` between phases, and `/clear` between unrelated tasks.
