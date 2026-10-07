# Harness & Context

An AI agent harness (also called AI scaffolding) is the software infrastructure that wraps around a Large Language Model (LLM) to turn it into an active, functional AI agent. See [Harness](../02-agentic-engineering/01-harness.md).

In Claude Code, OpenCode, and GitHub Copilot CLI, a **good context window** is not about adding more files. It's about adding the right files.

## How Each Tool Loads Context

Only instruction files are loaded automatically. Everything else (README, specs, docs, source files) enters the context only when the agent reads it, you reference it, or an instruction file imports it.

|                       | Claude Code                                                                                                 | OpenCode                                                                                      | GitHub Copilot CLI                                                                                    |
| --------------------- | ----------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------- |
| Project instructions  | `CLAUDE.md` or `.claude/CLAUDE.md`. `AGENTS.md` is read only if no `CLAUDE.md` or `CLAUDE.local.md` exists. | `AGENTS.md`. `CLAUDE.md` is a fallback, used only if no `AGENTS.md` exists.                   | `AGENTS.md`, `CLAUDE.md`, `GEMINI.md`, and `.github/copilot-instructions.md` (all merged).            |
| Personal instructions | `~/.claude/CLAUDE.md`                                                                                       | `~/.config/opencode/AGENTS.md` (falls back to `~/.claude/CLAUDE.md`)                          | `~/.copilot/copilot-instructions.md`                                                                  |
| Scoped rules          | `.claude/rules/*.md` with `paths:` frontmatter                                                              | `instructions` array in `opencode.json` (globs and URLs)                                      | `.github/instructions/**/*.instructions.md` with `applyTo:` frontmatter. Also reads `.claude/rules/`. |
| File imports          | `@path` (loaded at launch)                                                                                  | Not automatic. Use the `instructions` array, or tell the agent in `AGENTS.md` to read a file. | `@path` (files must be inside the repository)                                                         |
| `/init` generates     | `CLAUDE.md`                                                                                                 | `AGENTS.md`                                                                                   | `.github/copilot-instructions.md`                                                                     |
| Memory                | Auto memory written by Claude, stored outside the repo (see [Memory](#memory))                              | No built-in memory file documented                                                            | Built-in memory, not a repository file                                                                |
| Check what is loaded  | `/context`, `/memory`                                                                                       | Not documented                                                                                | `/instructions`, `/env`                                                                               |

Notes:

- Instruction files are advisory context, not enforcement. Use hooks (Claude Code, Copilot CLI) or permission rules to enforce behavior.
- For one file shared by all tools, keep `AGENTS.md` and add a `CLAUDE.md` for Claude Code that imports it (see [AGENTS.md](#agentsmd)).
- Keep instruction files short and specific. Claude Code recommends under 200 lines per `CLAUDE.md`. Put sometimes-relevant knowledge in skills or scoped rules.
- Do not assume commands or files are interchangeable between tools.

## Project Essential Files

Except for the instruction files, none of these are loaded automatically. Reference them in your prompt (for example `@specs/booking/requirements.md`) or import them from an instruction file.

### README.md

The project entry point. Contains human documentation: what the project is.

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

Provides:

- Project overview
- Tech stack
- Architecture summary

Location:

```text
project/
└── README.md
```

### AGENTS.md

The main instructions file for AI agents. It is a cross-tool convention: native in OpenCode and Copilot CLI, and read by Claude Code only when no `CLAUDE.md` exists.
Workflow guidance: how AI agents should work.

```markdown
# Agent Instructions

## Architecture

Use Hexagonal Architecture.

## Coding Standards

- TypeScript strict mode
- ESLint required

## Testing

All business logic requires tests.

## Workflow

Plan before implementing.
```

Provides:

- Rules
- Conventions
- Constraints

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

**Using it with Claude Code**

Claude Code does not read `AGENTS.md` when a `CLAUDE.md` exists. To keep `AGENTS.md` as the single source, create a `CLAUDE.md` that imports it:

```markdown
@AGENTS.md

## Claude Code

Use plan mode for changes under `src/billing/`.
```

Prefer the import over a symlink on Windows, where symlinks need Developer Mode or Administrator rights.

### Memory

Long-term knowledge (decisions, lessons learned) does not have a standard file across tools.

- **Claude Code**: `MEMORY.md` is the index of _auto memory_. Claude writes it, it lives in `~/.claude/projects/<project>/memory/`, it is local to your machine, and only its first 200 lines (or 25KB) load each session. A `MEMORY.md` in the project root is **not** loaded automatically.
- **OpenCode**: no built-in memory file is documented.
- **GitHub Copilot CLI**: built-in memory exists, but it is not a repository file.

For knowledge the whole team and every tool should share, commit it instead:

- Decisions and their reasons: [ADRs](#adrs)
- Rules and conventions: `AGENTS.md` (or `CLAUDE.md`)
- Requirements: [Specifications](#specifications)

### Specifications

Often the most useful task-specific context. Not loaded automatically: reference the relevant spec in your prompt.

Example:

```markdown
# Booking Requirements

Users can:

- Create bookings
- Cancel bookings
- Schedule rides
```

Provides:

- What to build
- Why it exists
- Acceptance criteria

Location:

```text
specs/
├── booking/
│   ├── requirements.md
│   ├── design.md
│   └── tasks.md
```

See: [Spec-Driven Development (SDD)](../04-spec-driven-development/README.md)

### Architecture Documents

Location:

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

Provides:

- System design
- Boundaries
- Dependencies

Keep it to decisions and boundaries that are not obvious from the code. Claude Code recommends leaving out what it can derive by reading the codebase, such as directory layouts and dependency lists.

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

Provides:

- Business terminology
- Business rules

### ADRs

Architecture Decision Records.

Location:

```text
docs/
└── adr/
```

Example:

```markdown
ADR-001

Use PostgreSQL.

Reason:
Strong transactional consistency.
```

Provides:

- Why decisions were made

### Coding Standards

Location:

```text
docs/
└── coding-standards.md
```

Example:

```markdown
- Use async/await
- Avoid any types
- Prefer Result pattern
```

Provides:

- Consistency
- Quality rules

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
