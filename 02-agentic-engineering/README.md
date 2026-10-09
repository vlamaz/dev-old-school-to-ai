# Agentic Engineering

Agentic engineering is a software development discipline where human engineers set goals, design the process and validate the work, while AI agents plan, write, test and iterate on code.

This chapter builds on [Chapter 01](../01-ai-foundations/) (LLMs, context windows, tool calling, RAG) and explains the concepts behind the tools covered in [Chapter 03](../03-ai-assisted-development/): what an agent is, the harness around it, how several agents work together, memory, security, and how to evaluate and observe agents.

## From Vibe Coding to Agentic Engineering

Using AI to write code is not one thing. It is easier to think of it as three rungs, separated by how much engineering rigor the human brings, not by how autonomous the AI is:

```text
Vibe coding              → accept AI output without reading or reviewing it
AI-assisted coding       → AI suggests or writes code, the human reviews every change
Agentic engineering      → agents work autonomously inside an engineered process
                           (specs, tests, permissions, review)
```

**Vibe coding** (a term coined by Andrej Karpathy in February 2025) means giving in to the vibes: you describe what you want in natural language, accept whatever the AI produces, and don't really read the code. It is great for prototypes, throwaway scripts and exploration. Vibe coders often use the same autonomous agents that professionals use; what is missing is review and verification.

Without that verification, vibe coding can produce **AI slop**: low-quality code that doesn't really work, breaks existing code, or nobody understands. That code increases the technical debt of a team, which then spends its time understanding, debugging and refactoring it.

**AI-assisted coding** is pair programming with an AI: autocomplete, chat, or an agent making changes that the developer reviews one by one. The human is still the driver.

**Agentic engineering** combines human engineering expertise with AI agents that carry out whole tasks:

- "Agentic": one or more agents write the code, run the tools and iterate, while the human stays in the loop at defined checkpoints (plan approval, review, merge).
- "Engineering": the human designs the process that makes the output trustworthy: specifications, tests, linters, permissions and review. This is a skill that can be learned and improved.

| Area            | Vibe Coding                           | Agentic Engineering                       |
| :-------------- | :------------------------------------ | :---------------------------------------- |
| Goal            | Get something working quickly         | Deliver production-quality changes        |
| Human role      | Prompter and accepter                 | Designer, supervisor and reviewer         |
| Code review     | Little or none                        | Required                                  |
| Planning        | Minimal                               | Explicit (specs, plans)                   |
| Architecture    | Emerges (or doesn't)                  | Designed first                            |
| Testing         | Often minimal or ad hoc               | Automated, plus human review of results   |
| Iteration       | Re-prompt until it looks right        | Agent iterates against tests and checks   |
| Reliability     | Variable                              | Higher when engineered properly           |
| Best suited for | Prototypes, exploration, throwaways   | Professional software development         |

## The Human Side of the Loop

The agent has its own loop (see [Agents](01-agents.md#the-agent-loop)). The engineer runs an outer loop around it:

```text
Write or refine the spec
      ↓
Agent plans → human approves the plan
      ↓
Agent implements and runs tests, linters, type checks
      ↓
Human reviews the diff
      ↓
Merge (or feed the review back to the agent)
```

The quality of the result depends mostly on the quality of the verification: tests, type checks and linters are the signals the agent uses to correct itself.

## Topics in this Chapter

1. [Agents](01-agents.md)
2. [Harness](02-harness.md)
3. [Multi-Agent Systems](03-multi-agent-systems.md)
4. [Memory](04-memory.md)
5. [Security and Safety](05-security.md)
6. [Evaluation and Observability](06-evaluation-and-observability.md)

Others:

- [Glossary](../01-ai-foundations/glossary.md)
