# Harness

An AI agent harness (also called AI scaffolding) is the software infrastructure that wraps around a Large Language Model (LLM) to turn it into an active, functional AI agent.

Building a highly reliable AI worker depends less on upgrading to a slightly larger model and more on building a robust harness. A well-engineered harness minimizes a model's tendency to hallucinate by forcing it to verify its own work through automated code execution, step-by-step validation loops, and heavily constrained operating environments.

## Why Do We Need a Harness?

An LLM alone can only generate text:

```text
User
  ↓
LLM
  ↓
Answer
```

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

   Before sending a request, the harness builds the context window.

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

   before Claude starts reasoning.

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
   Completed work
   ```

   This helps the agent remain consistent over time.

5. **Workflow Execution**

   Most agents follow a reasoning loop:

   ```text
   Observe
   ↓
   Think
   ↓
   Plan
   ↓
   Act
   ↓
   Evaluate
   ```

   The harness orchestrates this loop.

#### Example

**User Request**

```text
Implement booking cancellation.
```

**Harness Workflow**

```text
Read requirements
  ↓
Search existing code
  ↓
Read relevant files
  ↓
Generate implementation
  ↓
Run tests
  ↓
Return results
```

The user sees one request.

The harness coordinates many internal actions.

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
