# Agents

An **agent** is a model running in a loop with tools, deciding its own next step toward a goal.

A plain LLM call answers once and stops. An agent keeps going: it reads files, runs commands, looks at the results and decides what to do next, until the task is done.

```text
AGENT = MODEL + HARNESS (+ configuration)
```

- **Model**: the LLM that reasons and decides (for example Claude).
- **Harness**: the software around the model that builds its context, executes its tool calls, enforces permissions and runs the loop. See [Harness](02-harness.md).
- **Configuration**: instructions, available tools, permissions and settings for this particular job.

Coding agents you will meet:

- Claude Code (Anthropic), the priority in this repo
- OpenCode (open source, works with many model providers)
- GitHub Copilot CLI
- Others: OpenAI Codex CLI, Cursor (agent mode in the IDE), Devin (hosted autonomous agent)

Vendors market these products as "agents". Strictly, each product is a harness, and it becomes an agent once a model is running inside it.

## Anatomy of an Agent

```text
                  Agent
                    │
     ┌──────────────┴──────────────┐
     ▼                             ▼
   Model                        Harness
 (decides)                         │
                ┌──────────┬───────┼────────┬─────────────┐
                ▼          ▼       ▼        ▼             ▼
             Context     Tools   Memory  Permissions    Hooks
           (+ Skills)  (+ MCP)
```

- **Model**: the brain. It only produces text and tool-call requests.
- **Context**: everything the model sees on each call: instructions, conversation, file contents, tool results. **Skills** are packaged instructions that get loaded into context when relevant.
- **Tools**: what it can do (read, edit, search, run commands). **MCP** servers are one source of extra tools and data.
- **Memory**: information persisted across sessions (memory files) and re-injected into context. See [Memory](04-memory.md).
- **Permissions**: what it is allowed to do without asking. See [Security and Safety](05-security.md).
- **Hooks**: scripts the harness runs on lifecycle events. They run around the loop and are never sent to the model.

## The Agent Loop

This is the canonical description of the loop used in this repo. Other notes link here.

```text
messages = [system prompt, tool definitions, user request]

loop:
    response = call_model(messages)

    if response has no tool calls:
        return response            # the model thinks it is done

    for each tool_call in response:
        if not permitted(tool_call):
            result = "denied" (or ask the user)
        else:
            result = harness.execute(tool_call)
        messages.append(tool_call, result)

    if turn, token or time budget exceeded:
        stop
```

In words:

1. The harness calls the model with the context and the list of tools.
2. If the model returns tool calls, the harness checks permissions, executes them and appends the results to the conversation.
3. The harness calls the model again with the updated conversation.
4. The loop stops when the model replies without requesting any tool, or when a turn, budget or permission limit is hit.

The model never executes anything itself. It requests a tool with a structured block (tool name + JSON arguments); the harness runs it and returns the result. See [Tools](../01-ai-foundations/05-tools.md).

### A Mental Model: Observe, Think, Act

It is often useful to describe what happens inside that loop in human terms:

```text
Observe → Think → Plan → Act → Evaluate → (repeat)
```

This is a mental model only. In the real loop, "observe" is reading tool results, "think and plan" happen in the model's response (often with extended thinking), "act" is a tool call, and "evaluate" is usually running tests or checks through another tool call.

### Example

User: `Create a Booking API`

```text
Observe   Read requirements.md and AGENTS.md
Think     Needs endpoints, validation and tests
Plan      1. Create API contract  2. Implement service  3. Write tests
Act       Write files, run commands
Evaluate  Run the tests and read the results
Repeat    Fix failures until the tests pass, then summarize
```

For a step-by-step trace of the same loop from the harness side, see [Harness: a concrete trace](02-harness.md#a-concrete-trace).

## ReAct

**ReAct** (Reasoning + Acting, Yao et al., 2022) is the pattern of alternating reasoning traces with actions and observations:

```text
Thought → Action → Observation → Thought → ...
```

The original paper implemented it by prompting the model to write `Thought:`, `Action:` and `Observation:` lines as plain text. Modern agents implement the same idea through native tool calling: the model reasons (often with interleaved thinking between tool calls), emits a structured tool call, and receives the result. The agent loop above is a ReAct-style loop.

## Configured Agents

Most harnesses also let you define **configured agents**: named presets with their own instructions, model, and tool access. For example, a `code-reviewer` agent that can only read files and uses a cheaper model.

This is a feature of the harness, not a different kind of AI: underneath it is the same model running the same loop with a different configuration. How to define them differs per tool; see [Agents in Claude Code, OpenCode and Copilot CLI](../03-ai-assisted-development/08-agents.md).

## Primary Agents and Subagents

- **Primary agent**: the agent that receives your request and owns the conversation. It can do the work itself or delegate parts of it.
- **Subagent**: an agent invoked by another agent for a specific task. It runs in its **own context window** and returns only a summary to its parent.

```text
User
  ↓
Primary Agent ──► Subagent (own context)
  ↑                    │
  └──── summary ◄──────┘
```

The main reason to use subagents is **context isolation**: a subagent can read fifty files to answer a question, and the primary agent only receives the short answer, keeping its own context clean.

In Claude Code and OpenCode you can also invoke a subagent yourself by @-mentioning it.

When to use several agents, how to coordinate them, and how to handle failures is covered in [Multi-Agent Systems](03-multi-agent-systems.md).

## Links

- [ReAct: Synergizing Reasoning and Acting in Language Models](https://arxiv.org/abs/2210.03629)
- [Building effective agents (Anthropic)](https://www.anthropic.com/engineering/building-effective-agents)
