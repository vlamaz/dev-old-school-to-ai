# Agents

Agents are specialized AI assistants that can be configured for specific tasks and workflows. They allow you to create focused tools with custom prompts, models, and tool access.

`AGENT = MODEL + HARNESS`

## Agent anatomy

```text
                   Agent
                     │
       ┌─────────────┼─────────────┐
       │             │             │
       ▼             ▼             ▼
    Context       Skills        Memory
       │             │             │
       └──────┬──────┼──────┬──────┘
              │      │      │
              ▼      ▼      ▼
            Tools / MCP Servers
                     │
                     ▼
                    LLM
```

## How an Agent Works

Most agents follow a loop:

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

Primary agents are the main assistants you interact with directly.

OpenCode comes with two built-in primary agents, Build and Plan.

Invoked using `Shift+Tab`.

## Subagents

Subagents are specialized assistants that primary agents can invoke for specific tasks. You can also manually invoke them by @ mentioning them in your messages.

```shell
@general help me search for this function
```

## Agent Structure

**Locations:**

```text
Global: ~/.config/opencode/agents/
Per-project:
    .opencode/agents/
    .claude/agents/
```

**Example:**

`~/.config/opencode/agents/review.md`

```markdown
---
description: Reviews code for quality and best practices
mode: subagent
model: anthropic/claude-sonnet-4-20250514
temperature: 0.1
permission:
  edit: deny
  bash: deny
---

You are in code review mode. Focus on:

- Code quality and best practices
- Potential bugs and edge cases
- Performance implications
- Security considerations

Provide constructive feedback without making direct changes.
```

### Agent Params

**Description**: Brief description

**Temperature**: Control the randomness and creativity of the LLM’s responses with the temperature config.

Temperature values typically range from 0.0 to 1.0:

- 0.0-0.2: Very focused and deterministic responses, ideal for code analysis and planning
- 0.3-0.5: Balanced responses with some creativity, good for general development tasks
- 0.6-1.0: More creative and varied responses, useful for brainstorming and exploration

**Max steps**: Control the maximum number of agentic iterations an agent can perform before being forced to respond with text only. This allows users who wish to control costs to set a limit on agentic actions.

**Disable**: Set to true to disable the agent.

**Prompt**: Specify a custom system prompt file for this agent with the prompt config. The prompt file should contain instructions specific to the agent’s purpose.

**Model**: Override model.

**Permissions**: You can configure permissions to manage what actions an agent can take. Each permission key can be set to:

- "ask" — Prompt for approval before running the tool
- "allow" — Allow all operations without approval
- "deny" — Disable the tool
