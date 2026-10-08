# Agentic Engineering

Agentic engineering is a software development discipline where human engineers set goals and validate work while AI agents autonomously plan, write, test, and iterate on code.

## Agentic Engineering vs. Vibe Coding

**Vibe coding** allows developers to automate and prototype quickly with a few natural language prompts using LLMs or agentic systems.

Without the proper expertise in using LLMs for software engineering purposes, vibe coding can produce what is called **AI slop**, code that is not useful or breaks existing code. Such broken code often increases the technical debt of engineering teams with much of their time spent understanding, debugging and refactoring the code.

**Agentic engineering** works by combining human engineering expertise with AI agents that can perform specific software development tasks.

- “Agentic”: An orchestration of agents writes the code, and the human developer oversees and validates the output. As the agent or multi-agent system iterates through the subtasks, we maintain a human-in-the-loop.

- “Engineering”: There is a level of expertise required to use agentic workflows for meaningful code production that does not jeopardize the code quality. This skill is one that can be developed and improved.

Think of it like:

```text
Vibe Coding         = AI as a coding assistant
Agentic Engineering = AI as a software worker
```

| Area            | Vibe Coding                | Agentic Engineering               |
| :-------------- | :------------------------- | :-------------------------------- |
| Goal            | Write code quickly         | Solve tasks autonomously          |
| Human Role      | Driver                     | Supervisor                        |
| Planning        | Minimal                    | Explicit                          |
| Architecture    | Often emerges later        | Designed first                    |
| Tool Usage      | Mostly code generation     | Multiple tools                    |
| Testing         | Human-driven               | Automated                         |
| Iteration       | Manual                     | Agent-driven                      |
| Scalability     | Small-medium projects      | Medium-large projects             |
| Reliability     | Variable                   | Higher when engineered properly   |
| Primary focus   | Speed and experimentation  | Production-quality engineering    |
| Best suited for | Prototypes and exploration | Professional software development |

## Topics in this Chapter

1. [Harness](01-harness.md)
2. [Agents](02-agents.md)
