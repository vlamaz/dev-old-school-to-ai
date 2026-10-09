# Harness

A **harness** is the software around a model that turns it into an agent. It builds the model's context, exposes and executes tools, enforces permissions, manages memory, and runs the agent loop.

The model provides the reasoning; the harness provides everything the model needs to act in the real world.

When you use **Claude Code**, the model is _Claude_ (Opus, Sonnet or Haiku, whichever you choose) and _Claude Code_ is the harness. OpenCode and GitHub Copilot CLI are harnesses too.

## Why Do We Need a Harness?

An LLM alone can only generate text:

```text
User
  ↓
LLM
  ↓
Text Response
```

Example:

```text
User:
Explain OAuth2.

LLM:
[Generates explanation]
```

The model cannot:

- Read files
- Search repositories
- Query databases
- Run commands
- Create pull requests

It can only *ask* for those things. To actually do them, and to become an agent, it needs:

- Tools
- Context
- Memory
- Permissions
- Execution logic (the loop)

The harness provides all of these.

## What a Harness Does

Think of a harness as the operating system for an AI agent.

```text
                 Harness
                    │
    ┌──────────┬────┴─────┬─────────────┐
    │          │          │             │
 Context     Tools      Memory     Permissions
    │          │          │             │
    └──────────┴────┬─────┴─────────────┘
                    │
                   LLM
```

The harness manages everything except the reasoning itself.

### Main Responsibilities

1. **Context Management**

   Collects information for the model.

   Examples:

   ```text
   System prompt and tool definitions
   Project instruction files (CLAUDE.md, AGENTS.md)
   Current files
   Git changes
   Conversation history
   Tool results
   Specifications
   ```

   Before each model call, the harness builds the model's context window.

   Example:

   ```text
   User:
   Implement booking cancellation.
   ```

   The harness loads the project instructions automatically. The model then uses tools to read what it needs:

   ```text
   specs/booking.md
   src/bookings/
   ```

   A good harness continuously manages context. It decides or helps decide:
   - Which files to load up front
   - What to leave for the model to fetch on demand
   - When to summarize (compact) a long conversation
   - What to push into subagents so the main context stays small

   Instead of providing the entire codebase, the harness lets the model find only what is relevant to the task.

   Coding harnesses like Claude Code do this mainly with **agentic search**: the model calls search and read tools (grep, glob, read file) iteratively until it has what it needs. There is no vector index. Some tools, such as Cursor, also index the codebase with embeddings (RAG). See [RAG](../01-ai-foundations/04-rag.md).

   Context windows are finite, and quality degrades as they fill up. When a conversation gets long, harnesses **compact** it: they replace older messages with a summary. See [Context Engineering](../01-ai-foundations/06-context-engineering.md).

2. **Tool Management**

   The harness exposes tools to the model.

   Examples:

   ```text
   Read File
   Write File
   Search Code
   Git
   Terminal
   MCP tools (GitHub, databases, ...)
   ```

   The model can request:

   ```text
   Read auth service
   ```

   The harness executes the request and returns the result.

   ```text
   LLM:
   Read AuthService.ts

   Harness:
   Reads file

   Harness:
   Returns file content

   LLM:
   Analyzes auth service
   ```

   The model doesn't execute tools. It returns a structured tool call (tool name + JSON arguments matching the tool's schema). It is the harness that turns that request into an actual action. See [Tools](../01-ai-foundations/05-tools.md).

3. **Permission Management**

   The harness controls what the agent may do.

   Example:

   ```text
   ✅ Read files
   ✅ Search repository
   ✅ Run tests

   ❓ Edit files (ask first)

   ❌ Delete repository
   ❌ Deploy to production
   ```

   Typical mechanisms: allow / ask / deny rules per tool or command, permission modes (from "ask for everything" to "auto-accept edits"), sandboxing, and hooks that can block a tool call.

   This matters because the model can be tricked: a file, web page or MCP response can contain instructions (prompt injection). Permissions are the last line of defense. See [Security and Safety](05-security.md) and [Tools and Permissions](../03-ai-assisted-development/04-tools-and-permissions.md).

4. **Memory Management**

   The model has no memory of its own. Every session starts with an empty context window. "Memory" means files the harness saves and re-injects into context at the start of each session.

   Examples of what goes there:

   ```text
   Architecture decisions
   Team conventions
   Build and test commands
   Known constraints
   ```

   Where it lives depends on the tool: `CLAUDE.md` plus auto memory in Claude Code, `AGENTS.md` in OpenCode and GitHub Copilot CLI, and ADR documents in the repo for any tool.

   This helps the agent remain consistent over time. See [Memory](04-memory.md).

5. **The Agent Loop**

   The harness runs the loop: ask the model what to do, do it, tell it what happened, and ask again, until the model stops requesting tools or a limit is hit. The canonical description is in [Agents: The Agent Loop](01-agents.md#the-agent-loop).

### A Concrete Trace

You want to add a "like" button to the posts. So, you tell the agent:

```text
Add a 'like' button to the posts
```

Here is what happens next:

1. The harness constructs the message the model will receive: instructions on how to operate, your request, the project's instruction files (team conventions, file locations), and the list of available tools along with their parameters.
2. The model responds with text ("I need to find where each post is rendered") and requests the search tool.
3. The harness executes that search on your actual files and returns three files: `Post.tsx`, `PostList.tsx`, and `useUserData.ts`.
4. The model decides the button belongs in the first file and requests to open `Post.tsx`.
5. The harness opens the file and sends its content to the model.
6. The model proposes the change: adding the button here, using this specific code.
7. The harness checks permissions (maybe asks you) and applies the change to the actual file.
8. The model requests to run the tests.
9. The harness runs them and returns the result: one test failed, along with the error message.
10. The model reads the error and requests the next change. The cycle repeats until the tests pass and the model replies without requesting a tool.

The user sees one request. The harness coordinates dozens of underlying operations.

## Harness Components

A modern coding harness typically includes:

```text
Harness
│
├── Context Builder     (instructions, files, compaction)
├── Tool Registry       (built-in tools + MCP tools)
├── Agent Loop
├── Permissions         (rules, modes, sandbox)
├── Memory              (instruction and memory files)
├── Planning            (plan mode, todo lists)
├── Skills
├── Hooks
├── Subagents
└── MCP Client
```

### Planning

Many harnesses have a **plan mode**: the agent explores and proposes a plan without editing anything, and you approve it before implementation. During execution, agents often keep a todo list to track progress on multi-step tasks. See [Workflows](../03-ai-assisted-development/09-workflows.md).

### Skills

Packaged, reusable workflows and expertise.

```text
Create API
Review PR
Generate Specification
```

Skills use **progressive disclosure**:

1. Only each skill's `name` and `description` are always in context.
2. The body of `SKILL.md` is loaded when the skill is activated (the model decides it is relevant, or you invoke it).
3. Bundled files and scripts are read or run only when the instructions reference them.

So you can install many skills without filling the context window.

**Anatomy of a Skill**

```text
my-skill/
├── SKILL.md          # Required: metadata + instructions
├── scripts/          # Optional: executable code
├── references/       # Optional: documentation
├── assets/           # Optional: templates, resources
└── ...               # Any additional files or directories
```

The only mandatory file is `SKILL.md`. It has two parts:

- Frontmatter: YAML block at the beginning of the file with the `name` and `description`. The description is what the model reads to decide whether to activate the skill, so it should say what the skill does and when to use it.
- Body: the instructions in Markdown. This is where you write the workflow, your expertise, the tools to use and the available resources.

Agent Skills is an open format supported by several harnesses (Claude Code, OpenCode, GitHub Copilot). How skills are invoked differs per tool; in Claude Code, for example, the name also becomes a `/` command. See [Skills](../03-ai-assisted-development/05-skills.md).

### Hooks

Scripts the harness runs automatically on lifecycle events.

The key difference from instructions: hooks are **deterministic**. An instruction in `CLAUDE.md` *asks* the model to format code; a hook that runs the formatter after every edit *guarantees* it. A hook can also block a tool call, for example refusing `rm -rf`.

Main events in Claude Code (names differ in other tools):

```text
SessionStart
      ↓
UserPromptSubmit
      ↓
┌──► PreToolUse        (can block the call)
│         ↓
│    Tool execution
│         ↓
└─── PostToolUse       (repeats for every tool call in the loop)
      ↓
Stop                   (the agent finished responding)
      ↓
SessionEnd
```

Others include `SubagentStop` and `PreCompact`. See [Hooks](../03-ai-assisted-development/06-hooks.md).

### MCP (Model Context Protocol)

An open protocol to connect agents to external systems.

```text
GitHub
Azure DevOps
Jira
PostgreSQL
```

The harness is the MCP **client** (host). MCP servers expose three kinds of things:

- **Tools**: actions the model can call (create issue, run query).
- **Resources**: data the harness can read and add to context (a file, a ticket).
- **Prompts**: reusable prompt templates.

```text
Harness (MCP client)
  ↓
MCP Server
  ↓
Azure DevOps
```

The harness uses MCP servers as additional capabilities, under the same permission rules as built-in tools. See [MCP](../03-ai-assisted-development/07-mcp.md).

## Harness vs Agent

People often confuse the two.

**Simple Analogy**

```text
Driver          =   Model     -> makes the decisions
Car             =   Harness   -> provides the capabilities, controls and safety
Driver + Car    =   Agent     -> actually gets somewhere
```

- The **model** reasons about what to do.
- The **harness** is the runtime: Claude Code, OpenCode, GitHub Copilot CLI.
- An **agent** is the two running together. A "Security Agent" or "QA Agent" is a configuration (instructions, tools, model) running inside a harness. See [Configured Agents](01-agents.md#configured-agents).

## Harness vs MCP

| Harness                                      | MCP                                        |
| :------------------------------------------- | :----------------------------------------- |
| Runs the loop, owns context and permissions  | A protocol for connecting external systems |
| Is the MCP client                            | Servers expose tools, resources, prompts   |
| One per session                              | Many servers per harness                   |

## Why Harnesses Matter

Both the model and the harness matter. The same model can produce very different results in different harnesses, because the harness decides what the model sees, which tools it has and how safely they run.

A good harness:

- Provides the right context, and keeps it small
- Exposes the right tools
- Maintains useful memory
- Enforces safety controls
- Gives the agent ways to verify its own work (tests, linters)

In many modern agentic systems, the harness is what turns a powerful model into a productive software engineering assistant.

## Links

- [Harness Engineering: Anatomy, Architecture, and Evolution of Coding Agents](https://arxiv.org/abs/2609.00006)
- [Harness Engineering: explicado desde cero](https://x.com/santtiagom_/status/2098782814837543075?s=48&t=LWJX1wskZJYIvWw94vt2kw)
