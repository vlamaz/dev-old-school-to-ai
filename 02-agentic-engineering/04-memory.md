# Memory

A model has no memory of its own. It is stateless: every call only knows what is in its context window, and every new session starts empty.

What we call **memory** in an agent is information the harness persists across sessions and re-injects into the context. In this repo, "memory" always means that. The context window is not memory; it is the model's input limit. See [LLMs](../01-ai-foundations/01-LLMs.md).

## Kinds of Memory

```text
┌───────────────────┬───────────────────────────────┬──────────────────────┐
│ Kind              │ Examples                      │ Lifetime             │
├───────────────────┼───────────────────────────────┼──────────────────────┤
│ Session context   │ Conversation, tool results    │ One session          │
│ (not memory)      │                               │ (until compacted)    │
├───────────────────┼───────────────────────────────┼──────────────────────┤
│ Working state     │ Todo list, plan file,         │ One task             │
│                   │ scratch notes, progress file  │ (can span sessions)  │
├───────────────────┼───────────────────────────────┼──────────────────────┤
│ Long-term memory  │ Instruction files, memory     │ Across sessions      │
│                   │ files, ADRs, docs             │                      │
└───────────────────┴───────────────────────────────┴──────────────────────┘
```

### Session Context

The conversation itself: your messages, the model's replies, files it read, command outputs. It disappears when the session ends, and gets summarized (compacted) when it grows too large. Anything important that only lives here will be lost.

### Working State

Notes about the current task, written to files so they survive compaction or a new session:

- A todo list the agent keeps while working on a multi-step task
- A plan file (`plan.md`) approved before implementation
- A progress file for long tasks: what is done, what is next, what was tried and failed

A useful habit for long tasks: ask the agent to update a progress file before you end a session, and to read it at the start of the next one.

### Long-Term Memory

Knowledge that should apply to every session:

- **Instruction files** written by humans: project conventions, build and test commands, architecture notes. `CLAUDE.md` in Claude Code, `AGENTS.md` in OpenCode and GitHub Copilot CLI (Claude Code can also read `AGENTS.md`).
- **Memory files written by the agent**: some harnesses let the agent save what it learns (your corrections, preferences, project quirks). Claude Code calls this auto memory.
- **Project documentation**: ADRs, specs and READMEs in the repo. These are not loaded automatically, but the agent can be pointed to them.

These files are loaded into context at the start of each session. Per-tool file names, locations and loading rules are in [Context](../03-ai-assisted-development/01-context.md).

## Memory Is Context, Not Configuration

Memory files are read by the model like any other text. They *request* behavior; they don't enforce it. The model can ignore or misread an instruction, especially in a long context.

If something must always happen (or never happen), use a deterministic mechanism instead: a hook, a permission rule, a linter or a test. See [Hooks](../03-ai-assisted-development/06-hooks.md).

## Writing Good Memory

- **Keep it short.** Memory is loaded on every session and consumes context. A few hundred focused lines beat a long manual.
- **Be specific.** "Run `npm test -- --watch=false` before committing" beats "make sure tests pass".
- **Write what the agent can't infer.** Don't describe what is obvious from the code; describe conventions, gotchas and decisions.
- **Link instead of copying.** Point to `docs/architecture.md` rather than pasting it.
- **Scope it.** Put rules that only apply to one folder or file type in a scoped file, if the tool supports it, rather than in the root file.

## Staleness

Memory goes out of date, and stale memory is worse than none: the agent will confidently follow an instruction that is no longer true.

Typical causes:

- A command, path or library changed, and the memory file didn't
- Auto memory saved a one-off correction as a permanent rule
- Two memory files contradict each other

Practices:

- Review memory files like code: keep them in the repo, change them in pull requests.
- When the agent makes the same mistake twice, fix the memory file, not just the code.
- Periodically read the agent-written memory and delete what is wrong or no longer useful.
- Prefer facts that are checked by tooling (a test, a lint rule) over facts only written in prose.

## Shared Memory Between Agents

Subagents start with their own, fresh context. They usually receive the project instruction files, but not the primary agent's conversation. If a subagent needs a decision made earlier, it must be in its task description or in a file it can read. See [Multi-Agent Systems](03-multi-agent-systems.md#when-not-to-use-multiple-agents).
