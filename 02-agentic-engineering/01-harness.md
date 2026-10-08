# Harness

A Harness is the software layer that transforms a LLM into a practical AI agent.

The LLM provides intelligence and reasoning, while the harness provides everything the model needs to operate in the real world.

When you use **Claude Code**, the model is _Claude_ (Opus, Sonnet, whichever you choose) and _Claude Code_ is the harness.

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

To do those things, it needs a harness.

To become an agent, it needs:

- Tools
- Memory
- Context
- Permissions
- Execution logic

The harness provides all of these.

## What a Harness Does

Think of a harness as the operating system for an AI agent.

```text
                 Harness
                    │
    ┌───────────────┼───────────────┐
    │               │               │
 Context         Tools          Memory
    │               │               │
    └───────────────┼───────────────┘
                    │
                   LLM
```

The harness manages everything except the reasoning itself.

### Main Responsibilities

1. **Context Management**

   Collects information for the model.

   Examples:

   ```text
   README.md
   AGENTS.md
   Memory files (tool-specific)
   Current files
   Git changes
   Conversation history
   Specifications
   ```

   Before sending a request, the harness builds the model's context window.

   Example:

   ```text
   User:
   Implement booking cancellation.
   ```

   The harness may automatically read:

   ```text
   specs/booking.md
   AGENTS.md
   src/bookings/
   ```

   before asking the model to work.

   A good harness continuously manages context.

   The harness decides:
   - Which files to load
   - Which files to ignore
   - What summaries to generate
   - What information is most relevant

   Instead of providing the entire codebase, a harness retrieves only the information relevant to the task.

   RAG Helps Solve the Problem: A retrieval system can search the repository and select only the most relevant documents.

2. **Tool Management**

   The harness exposes tools to the model.

   Examples:

   ```text
   Read File
   Write File
   Search Code
   Git
   MCP
   Database
   Terminal
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

   The model doesn't execute them; it simply writes down which ones it wants to use and with what parameters. That request remains text. It is the harness that converts it into an actual action.

3. **Permission Management**

   The harness controls what the AI may do.

   Example:

   ```text
   ✅ Read files
   ✅ Search repository
   ✅ Run tests
    
   ❌ Delete repository
   ❌ Deploy to production
   ```

   This provides safety and governance.

4. **Memory Management**

   The harness maintains project knowledge.

   Examples:

   ```text
   Architecture decisions
   Business rules
   Known constraints
   Past tasks
   ```

   Often stored in files such as:

   ```text
   MEMORY.md
   ADR documents
   Knowledge base files
   ```

   This helps the agent remain consistent over time.

5. **Workflow Orchestration and Execution**

   Most agents follow a reasoning **loop**:

   ```text
    Observe
      ↓
    Think
      ↓
    Plan
      ↓
    Act
      ↓
    Review
   ```

   The harness coordinates that entire process: asks the model what to do, do it, tell it what happened, and ask it again. Until it's ready. (A loop!)

   The loop continuously consumes:
   - Context
   - Tool results
   - Memory

   and decides the next action.

   **Loop architecture**

   ```javascript
    while goal_not_completed:

        Observe()

        Think()

        Select_Tool()

        Execute_Tool()

        Evaluate()

    return result
   ```

#### Example

Example based on **Claude Code**:

**User Request**

```text
Implement booking cancellation
```

**Harness Workflow**

```text
1. Read AGENTS.md
2. Read specifications
3. Search related code
4. Build context
5. Generate implementation
6. Modify files
7. Run tests
8. Summarize results
```

The user sees one request. The harness coordinates dozens of underlying operations.

<u>Another example:</u>

You want to add a "like" button to the posts. So, you tell the agent:

```text
Add a 'like' button to the posts
```

Here is what happens next:

1. The harness constructs the message the model will receive: instructions on how to operate, your request, the project's self-documentation (team conventions, file locations), and the list of available tools along with their parameters.
2. The model responds with text—"I need to find where each post is rendered"—and requests to use the search tool.
3. The harness executes that search on your actual files and returns three files: `Post.tsx`, `PostList.tsx`, and `useUserData.ts`.
4. The model decides the button belongs in the first file and requests to open `Post.tsx`.
5. The harness opens the file and sends its content to the model.
6. The model proposes the change: adding the button here, using this specific code.
7. The harness applies the change to the actual file.
8. The model requests to run the tests.
9. The harness runs them and returns the result: one test failed, along with the error message.
10. The model reads the error and requests the next change. The cycle begins again.

## Harness Components

A modern harness typically includes:

```text
Harness
│
├── Context Builder
├── Tool Registry
├── Memory Manager
├── Planner
├── Agent Loop
├── Permissions
├── Hooks
├── Skills
└── MCP Integration
```

### Context Builder

Determines:

```text
What should the model know?
```

### Skills

Provide reusable workflows.

```text
Create API
Review PR
Generate Specification
```

The harness loads it when needed, instead of always keeping it in the context.

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

- Frontmatter: YAML block at the beginning of the file containing the name and description. The name becomes the command you use to invoke it. The description is what Claude reads to decide whether or not to activate it.

- Body: The instructions in Markdown. This is where you write the workflow, your expertise, the tools to be used, and the available resources

A skill can include many other supporting files.

### Hooks

Run automatically on events.

```text
Session Start
Pre Tool Use
Post Tool Use
Task Complete
```

Hooks let you automate behavior around the agent lifecycle.

**Hook Lifecycle**

```text
Session Start
      ↓
User Request
      ↓
Pre-Tool Hook
      ↓
Tool Execution
      ↓
Post-Tool Hook
      ↓
Response
      ↓
Stop Hook
```

### MCP (Model Context Protocol)

Connects to external systems.

```text
GitHub
Azure DevOps
Jira
PostgreSQL
```

## Harness vs Agent

People often confuse the two.

**Simple Analogy**

```text
Driver  =   Agent     -> The driver makes decisions.
Car     =   Harness   -> The car provides the capabilities needed to move.
```

### Agent

The decision-maker.

```text
Booking Agent
Security Agent
QA Agent
```

The agent reasons about what to do.

### Harness

The runtime system.

```text
Claude Code
OpenCode
Cursor Agent Runtime
```

The harness enables the agent to act.

## Harness vs MCP

### Harness

Manages:

```text
Context
Memory
Tools
Permissions
Execution
```

### MCP

Provides:

```text
External Tools
External Data Sources
```

Example:

```text
Harness
  ↓
MCP Server
  ↓
Azure DevOps
```

The harness uses MCP servers as additional capabilities.

## Why Harnesses Matter

As AI systems become more capable, success depends less on the model and more on the surrounding runtime.

A good harness:

- Provides the right context
- Exposes the right tools
- Maintains useful memory
- Enforces safety controls
- Coordinates workflows

In many modern agentic systems, the harness is what transforms a powerful model into a productive software engineering assistant.

## Links

- [Harness Engineering: Anatomy, Architecture, and Evolution of Coding Agents](https://arxiv.org/pdf/2609.00006)
- [Harness Engineering: explicado desde cero](https://x.com/santtiagom_/status/2098782814837543075?s=48&t=LWJX1wskZJYIvWw94vt2kw)
