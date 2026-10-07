# Harness & Context

An AI agent harness (also called AI scaffolding) is the software infrastructure that wraps around a Large Language Model (LLM) to turn it into an active, functional AI agent. See [Harness](../03-agentic-engineering/01-harness.md).

For a Claude Code-style harness, a **good context window** is not about adding more files. It's about adding the right files.

## Project Essential Files

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

The most important file for AI agents.
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

Location:

```text
project/
└── AGENTS.md
```

Examples: <https://agents.md/#examples>

### MEMORY.md

Long-term project knowledge.

```markdown
# Project Decisions

- OAuth2 authentication
- PostgreSQL selected over MongoDB

# Lessons Learned

Driver API rate limits require caching.
```

Provides:

- Historical decisions
- Project memory
- Lessons learned

```text
project/
└── MEMORY.md
```

### Specifications

The most valuable context after `AGENTS.md`.

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

When building a context window, I'd load files in this order:

```text
1. User Request
2. Relevant Spec
3. AGENTS.md
4. MEMORY.md
5. README.md
6. Architecture Docs
7. Business Rules
8. Relevant Source Files
```

For example:

```text
Implement booking cancellation
```

Load:

```text
specs/booking/requirements.md
AGENTS.md
MEMORY.md
docs/business-rules.md
src/booking/\*
```

Don't load:

```text
payment files
notification files
unrelated docs
```
