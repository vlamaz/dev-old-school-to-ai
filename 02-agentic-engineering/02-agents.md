# Agents

Agents are specialized AI assistants that can be configured for specific tasks and workflows. They allow you to create focused tools with custom prompts, models, and tool access.

`AGENT = MODEL + HARNESS`

Top Coding & Development Agents:

- Claude Code
- OpenAI Codex
- Cursor & Devin

## Anatomy of an agent

An agent is usually made of several components:

- LLM: The brain
- Context: What It Knows
- Memory: What It Remembers
- Tools: What It Can Do
- Skills: How It Works
- MCPs: What It Can Access
- Hooks: Automation (on specific events)

```text
                    Agent
                      │
     ┌────────────────┼────────────────┐
     │                │                │
     ▼                ▼                ▼
   Context         Memory           Tools
     │                │                │
     └──────────┬─────┼─────┬──────────┘
                │     │     │
                ▼     ▼     ▼
              Skills Hooks MCPs
                     │
                     ▼
                    LLM
```

## How an Agent Works

Most agents run continuously until the goal is completed, following a loop:

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
  ↓
Repeat
```

This is often called the **Agent Loop**.

### Example

User: `Create a Booking API`

**Observe**

Read:

```text
requirements.md
AGENTS.md
```

**Think**

Determine:

```text
Need:
- Endpoints
- Validation
- Tests
```

**Plan**

```text
1. Create API contract
2. Implement service
3. Write tests
```

**Act**

Use tools:

```text
ReadFile
WriteFile
Search
```

**Evaluate**

```text
Run tests
Check results
```

**Repeat**

Until complete.

### ReAct loop pattern

A ReAct Loop (Reasoning and Acting) is an agentic execution pattern that alternates reasoning traces with concrete actions.

Most modern agents use this pattern.

## Primary agents

A Primary Agent is the main agent that receives the user's goal and coordinates the work.

Think of it as the project manager.

```text
User
  ↓
Primary Agent
  ↓
Result
```

Responsibilities:

- Understand user goals
- Create plans
- Delegate work
- Aggregate results
- Produce final response

## Subagents

Subagents are specialized assistants that primary agents can invoke for specific tasks. You can also manually invoke them by @ mentioning them in your messages.

A Subagent is a specialized agent responsible for a specific task.

Think of them as specialists.

```text
Primary Agent
      │
 ┌────┼────┐
 ▼    ▼    ▼
QA  Security Architect
```

Each subagent focuses on one concern.

Example:

```text
Primary Agent
      │
 ├──────────────┐
 ▼              ▼
Architect     Implementation
Agent         Agent
 │              │
 ▼              ▼
Design      Generate Code
```

### Common Subagent Types

- Architect Agent
- Implementation Agent
- QA Agent
- Security Agent
- Documentation Agent

### When to Use Subagents

Use a single agent for:

- Simple tasks
- Small repositories
- Quick questions

Use subagents for:

- Large codebases
- Complex features
- Architecture reviews
- Multi-step workflows

### Primary/subagent message flow

A good way to think about it is that the **Primary Agent** acts as an orchestrator, while **Subagents** act as specialists.

```text
User
 │
 ▼
Primary Agent
 │
 ├──► Architect Agent
 │         │
 │         └──► Design Recommendation
 │
 ├──► Backend Agent
 │         │
 │         └──► Implementation Plan
 │
 ├──► QA Agent
 │         │
 │         └──► Test Strategy
 │
 ▼
Primary Agent
 │
 ▼
Final Response`
```

Sequence diagram:

```text
┌────────┐
│  User  │
└────┬───┘
     │
     ▼
┌───────────────┐
│ Primary Agent │
└───────┬───────┘
        │
        ├─────────────────► Architect Agent
        │                  │
        │◄─────────────────┘
        │
        ├─────────────────► Backend Agent
        │                  │
        │◄─────────────────┘
        │
        ├─────────────────► QA Agent
        │                  │
        │◄─────────────────┘
        │
        ▼
┌───────────────┐
│ Final Result  │
└───────────────┘
```

## Multi-Agent Workflow

```text
User
 │
 ▼
Primary Agent
 │
 ├──► Architect Agent
 │         │
 │         └──► Design Recommendation
 │
 ├──► Backend Agent
 │         │
 │         └──► Implementation Plan
 │
 ├──► QA Agent
 │         │
 │         └──► Test Strategy
 │
 ▼
Primary Agent
 │
 ▼
Final Response
```

A powerful multi-agent system doesn't call subagents one after another. Instead, it delegates work in parallel and then aggregates the results.

```text
User
 │
 ▼
Primary Agent
 │
 ├─────────────┬─────────────┬─────────────┐
 ▼             ▼             ▼             ▼
Architect   Backend        QA        Security
 Agent       Agent        Agent        Agent
 │             │             │             │
 └─────────────┴─────────────┴─────────────┘
                      │
                      ▼
               Primary Agent
                      │
                      ▼
                Final Result
```

Sequece diagram:

```text
User
 │
 ▼
┌───────────────────┐
│   Primary Agent   │
└─────────┬─────────┘
          │
          ├──────────────┬──────────────┬──────────────┐
          │              │              │              │
          ▼              ▼              ▼              ▼
 ┌────────────┐ ┌────────────┐ ┌────────────┐ ┌────────────┐
 │ Architect  │ │  Backend   │ │     QA     │ │  Security  │
 │   Agent    │ │   Agent    │ │   Agent    │ │   Agent    │
 └─────┬──────┘ └─────┬──────┘ └─────┬──────┘ └─────┬──────┘
       │              │              │              │
       └──────────────┴──────────────┴──────────────┘
                              │
                              ▼
                    ┌───────────────────┐
                    │   Primary Agent   │
                    └─────────┬─────────┘
                              │
                              ▼
                        Final Answer
```

## Failure & Timeout Handling in Multi-Agent Systems

A robust harness assumes that subagents will fail sometimes.

Common failures:

- Timeout
- Tool failure
- MCP unavailable
- Invalid response
- Hallucinated response
- Agent crash

A good Primary Agent must handle these gracefully.

Strategies:

- Retry Strategy: Instead of failing immediately, retry 2-3 times.
- Parallel Execution with Failure Isolation: all subagents running in parallel, If one agent fails, not the whole workflow fails: use `Promise.allSettled()`
- Failure-Tolerant Flow
- Fallback Agents: Sometimes another agent can take over.
- Confidence-Based Aggregation: The Primary Agent can score results. This helps avoid false confidence.
