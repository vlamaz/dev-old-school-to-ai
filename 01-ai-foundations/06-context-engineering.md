# Context Engineering

**Prompt Engineering** focuses on instructions.

**Context Engineering** focuses on providing the right information: deciding what goes into the model's context window, when, and in what form.

Good context engineering means sending the smallest set of information that lets the model do the task well.

This note assumes you know what a context window is and why quality drops as it fills (context rot). See [Context Window](01-LLMs.md#context-window).

## What Is Context?

Context is all the information available to the model when generating a response.

Examples:

```text
System Prompt
    +
User Prompt
    +
Chat History
    +
Instruction files (CLAUDE.md, AGENTS.md...)
    +
Memory
    +
Tool Definitions
    +
Tool Outputs (source code, docs, command results)
    +
Specifications
    =
Context
```

Good results usually depend less on clever wording and more on whether the model has the right context: requirements, architecture, business rules, examples, constraints, and relevant knowledge.

Context is the fuel that powers effective AI-assisted development.

## Sources of Context

1. **User Prompt**

   Direct instructions.

2. **Conversation History**

   Previous messages provide continuity.

3. **Documentation**

   Examples:

   ```text
   README.md
   CONTRIBUTING.md
   docs/*
   ```

4. **Agent Instructions**

   Files the tool loads automatically at the start of a session to guide AI behavior.

   Examples:

   ```text
   AGENTS.md
   CLAUDE.md
   .github/copilot-instructions.md
   ```

   Which files are loaded depends on the tool. For example, Claude Code reads `CLAUDE.md`, and reads `AGENTS.md` by default only when there is no `CLAUDE.md`. See [Context](../03-ai-assisted-development/01-context.md) for each tool.

5. **Memory**

   Project knowledge persisted across sessions and re-injected into the context. Memory is tool-specific: a `MEMORY.md` in the project root is not loaded automatically.

   Examples:

   ```text
   Claude Code auto memory (~/.claude/projects/<project>/memory/MEMORY.md)
   Decisions recorded as ADRs
   ```

   See [Memory](../02-agentic-engineering/04-memory.md).

6. **Specifications**

   Examples:

   ```text
   Requirements
   User Stories
   EARS
   OpenSpec documents
   Design documents
   ```

7. **External Knowledge**

   Examples:

   ```text
   RAG
   Knowledge Bases
   Wikis
   MCP Servers
   Databases
   ```

## Common Context Files

Some files are loaded automatically by the tool; others are only read when the agent (or you) references them.

```text
project/
│
├── AGENTS.md / CLAUDE.md   ← loaded automatically (depends on the tool)
├── README.md               ← read on demand
│
├── specs/                  ← read on demand; layout depends on the SDD framework
│
├── docs/
│   ├── architecture.md
│   ├── api.md
│   └── adr/
│
└── knowledge/
    ├── glossary.md
    └── business-rules.md
```

Keep the auto-loaded files short and point from them to the detailed ones. Everything in an auto-loaded file costs tokens in every session. Claude Code's docs, for example, suggest keeping each `CLAUDE.md` under about 200 lines.

## Context Engineering Techniques

### 1. Just-in-Time Retrieval

Don't load everything up front. Give the agent lightweight references (file paths, links, queries) and let it load the content with tools when it needs it.

```text
Up front:   "Architecture decisions are in docs/adr/"
On demand:  agent reads docs/adr/0007-auth.md when working on auth
```

This is how coding agents explore a repository with search and read tools. See [RAG vs Agentic Search](04-rag.md#rag-vs-agentic-search).

### 2. Progressive Disclosure

Show a short summary first and load the details only when relevant. Skills work this way: the tool only keeps each skill's name and description in context, and loads the full instructions when the skill is used. See [Skills](../03-ai-assisted-development/05-skills.md).

### 3. Subagents for Context Isolation

Delegate a noisy subtask (searching a large codebase, reading many logs) to a subagent. It works in its own context window and returns only a short summary, keeping the main conversation clean. See [Agents](../02-agentic-engineering/01-agents.md).

### 4. Compaction

Compaction takes a conversation nearing the context window limit, summarizes it, and continues in a fresh context with that summary.

In **Claude Code**:

- Compaction runs automatically when the context gets close to full, or manually with `/compact`, optionally with instructions on what to focus on.
- The conversation is replaced by a structured summary: requests, key decisions, files examined or changed, errors and fixes, pending tasks.
- Startup content (system prompt, `CLAUDE.md`, memory) reloads, and Claude Code re-reads up to five of the most recently modified files from the session.
- Full tool outputs and intermediate reasoning are gone after compaction.

Summaries lose detail. For long tasks, compacting at a natural break point (or starting a new session with `/clear`) works better than letting the context fill up mid-task.

### 5. Tool Result Clearing

Old tool outputs (a file read 40 steps ago, a long test log) are rarely needed again in full. Removing or shortening them is one of the safest ways to free context.

### 6. Structured Note-Taking

For long tasks, have the agent write progress to a file (`progress.md`, a task list, a plan) and re-read it later. The notes survive compaction and new sessions, because they live outside the context window.

### 7. Prompt Caching

Model APIs can cache a stable prefix of the prompt (system prompt, tool definitions, instruction files) so repeated requests are cheaper and faster. Caching only works if that prefix stays identical, so keep stable content first and changing content last. Coding tools handle this for you; it matters when you build your own agents.

### 8. Monitor Your Context

Know what is filling the window. In Claude Code, `/context` shows current context usage by category (system prompt, tools, memory files, messages) and suggests what to trim.

## Common Context Problems

- **Too much context**: large irrelevant files, dozens of MCP tools, or long logs dilute the important parts.
- **Stale context**: outdated instruction files, specs or memory lead the model to follow old rules.
- **Conflicting context**: two files that say different things. The model has to guess.
- **Context poisoning**: a wrong conclusion or hallucination early in the session gets repeated as fact. Clearing and restarting is often faster than correcting.
- **Untrusted context**: web pages, issues or tool results containing instructions. See [Prompt Injection](02-prompt-engineering.md#prompt-injection).

## Links

- [Anthropic - Effective context engineering for AI agents](https://www.anthropic.com/engineering/effective-context-engineering-for-ai-agents)
- [Claude Code - Explore the context window](https://code.claude.com/docs/en/context-window)
- [LangChain - Context Engineering](https://www.langchain.com/blog/context-engineering-for-agents)
- [Context Engineering Guide](https://www.promptingguide.ai/guides/context-engineering-guide)
