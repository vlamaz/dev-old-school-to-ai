# Spec-Driven Development (SDD)

Spec-Driven Development (SDD) is a software development approach where you write and refine specifications first, and those specifications become the primary source of truth for design, implementation, testing, and AI-assisted coding.

With tools like Claude Code, OpenCode, Cursor, GitHub Copilot, and other AI coding agents, developers discovered that AI produces much better results when given a detailed specification rather than vague prompts.

Instead of saying: `Build a taxi booking page`

you create a specification describing:

- User goals
- Business rules
- UI behavior
- Edge cases
- API interactions
- Acceptance criteria
- Non-functional requirements

Then the AI generates the implementation from that specification, and the specification is kept up to date as the system changes.

```text
  Requirement
  ↓
  Specification
  ↓
  Review & refine
  ↓
  Implementation
  ↓
  Verify against the spec (tests)
  ↓
  Update the spec
```

This chapter starts with the concepts and a generic workflow, then covers EARS for writing the requirements themselves, and finishes with OpenSpec as a concrete framework.

## Topics in this Chapter

1. [SDD Fundamentals](01-sdd-fundamentals.md)
2. [EARS (Easy Approach to Requirements Syntax)](02-ears.md)
3. [OpenSpec](03-openspec.md)
