# Multi-Agent Systems

A multi-agent system is one where several agents (or several model calls with different roles) work together on a task. Before reaching for one, it helps to know the simpler patterns and what multiple agents cost.

This note assumes you know the [agent loop](01-agents.md#the-agent-loop) and the difference between [primary agents and subagents](01-agents.md#primary-agents-and-subagents).

## Workflows vs Agents

Anthropic's ["Building effective agents"](https://www.anthropic.com/engineering/building-effective-agents) separates two kinds of systems:

- **Workflows**: LLMs and tools orchestrated through predefined code paths. You decide the steps in advance.
- **Agents**: the LLM directs its own process and tool usage, deciding the next step at runtime.

Start with the simplest thing that works: a single model call, then a workflow, and only then an agent or several agents. Each step up adds cost, latency and unpredictability.

### The Five Workflow Patterns

1. **Prompt chaining**: the output of one call is the input of the next.

   ```text
   Write spec → Review spec → Generate code
   ```

2. **Routing**: classify the input and send it to a specialized handler.

   ```text
   Request → Classifier → Bug fix flow | Feature flow | Question flow
   ```

3. **Parallelization**: run independent calls at the same time and combine them. Two variants: *sectioning* (split the task into independent parts) and *voting* (run the same task several times and compare).

   ```text
   PR ─┬─► Security review ────┐
       ├─► Performance review ─┼─► Combined report
       └─► Style review ───────┘
   ```

4. **Orchestrator-workers**: a central model breaks the task down at runtime, delegates to workers and combines the results. This is the primary agent / subagent pattern.

5. **Evaluator-optimizer**: one call produces, another evaluates and gives feedback, in a loop. For example, a writer agent and a reviewer agent, or code plus tests.

   ```text
   Generate → Evaluate → (feedback) → Generate → ... → Accept
   ```

## Primary Agent as Orchestrator

In the orchestrator-workers pattern, the **primary agent** acts like a project manager:

- Understands the user's goal
- Creates a plan
- Delegates work to subagents
- Aggregates the results
- Produces the final response

**Subagents** act as specialists. Each one runs in its own context window, focuses on one concern and returns a summary.

```text
User
 │
 ▼
Primary Agent
 │
 ├──► Explore subagent  ──► "Auth lives in src/auth, uses JWT"
 │
 ├──► Review subagent   ──► "3 issues found in the diff"
 │
 ▼
Primary Agent
 │
 ▼
Final Response
```

Common subagent roles:

- Explorer / researcher (read-only search across the codebase)
- Planner or architect
- Implementer
- Reviewer, QA or test writer
- Security reviewer
- Documentation writer

In Claude Code, subagents can also spawn their own subagents (nesting is limited, three levels by default), so the flat "primary + specialists" picture is a simplification. Per-tool details are in [Agents](../03-ai-assisted-development/08-agents.md).

## Why Use Subagents

- **Context isolation**: the subagent's exploration stays out of the main conversation. Only its summary comes back. This is the main benefit.
- **Tool restriction**: a reviewer can be read-only.
- **Model choice**: cheap, fast models for search; strong models for design.
- **Parallelism**: independent tasks can run at the same time.
- **Focused instructions**: each subagent gets a prompt for one job.

## When Not to Use Multiple Agents

Multiple agents are not free:

- **Cost**: Anthropic reported that single agents use about 4× the tokens of a chat interaction, and their multi-agent research system about 15×.
- **Lost context**: each subagent only knows what it was told in its task description. Decisions made in one context are invisible to the others.
- **Coordination**: agents working on the same code can make conflicting choices.
- **Debugging**: it is harder to see what happened inside a subagent.

Anthropic notes that multi-agent systems fit best on broad, parallelizable, read-heavy work such as research, and are a poor fit when agents need to share a lot of context or depend on each other. Coding often falls in the second group.

Rule of thumb:

```text
Single agent      → most coding tasks, small to medium changes
Subagents         → high-volume exploration, isolated reviews,
                    independent tasks you can describe completely
Parallel writers  → only on truly independent parts
                    (separate files or worktrees), with a review step after
```

## Parallel vs Sequential

Parallelize only independent work. Run dependent steps in sequence.

Wrong: running Architect, Backend and QA at the same time. Backend and QA need the design first, so they guess, and the results don't fit together.

Right:

```text
User
 │
 ▼
Primary Agent
 │
 ▼
Architect Agent ──► Design
 │
 ▼
Backend Agent ──► Implementation
 │
 ├───────────────┬───────────────┐
 ▼               ▼               ▼
QA Agent    Security Agent   Docs Agent      (independent: in parallel)
 │               │               │
 └───────────────┴───────────────┘
                 │
                 ▼
           Primary Agent
                 │
                 ▼
           Final Result
```

Reviews of the same finished change are a good use of parallelism: they read the same input and don't depend on each other.

## Failure Handling

A robust orchestrator assumes that subagents will sometimes fail.

Common failures:

- Timeout or running out of turns or budget
- Tool failure
- MCP server unavailable
- Invalid or incomplete response
- Hallucinated response (looks fine, is wrong)
- Agent crash

Strategies:

- **Retry**: retry transient failures (timeouts, network, unavailable servers) a few times with backoff. Only retry steps that are safe to repeat. Retrying a non-idempotent step (a write, a commit, a push) needs a check or rollback first.
- **Failure isolation**: when subagents run in parallel, one failure should not discard the others' results. Collect every result and its status, then decide (like `Promise.allSettled()` in JavaScript, as opposed to `Promise.all()`).
- **Graceful degradation**: decide in advance which results are required and which are optional. A missing docs review can be a warning; a missing security review should fail the task.
- **Fallbacks**: another agent, model or data source can take over.
- **Verification instead of confidence**: retries don't detect hallucinations, and a model's self-reported confidence is poorly calibrated. Check results against something external: tests, type checks, schema validation, a reviewer agent, citations.

### Example Retry Policy (Illustrative)

If you build your own orchestrator (for example with an agent SDK), you will need per-role policies. The values below are **made up to illustrate the idea**, not recommendations. Real coding subagents often run for minutes, so limits are usually expressed as turns or token budgets rather than seconds. Tools like Claude Code, OpenCode and Copilot CLI don't expose this kind of matrix; their equivalents are turn limits, permissions and the primary agent deciding to re-delegate.

```text
┌──────────────────┬────────────────┬─────────┬──────────┬───────────────┐
│ Role             │ Limit          │ Retries │ Backoff  │ On failure    │
├──────────────────┼────────────────┼─────────┼──────────┼───────────────┤
│ Explorer         │ 30 turns       │ 1       │ None     │ Continue      │
│ Architect        │ 20 turns       │ 1       │ None     │ Fail task     │
│ Implementer      │ 50 turns       │ 0 *     │ -        │ Fail task     │
│ Reviewer / QA    │ 30 turns       │ 1       │ None     │ Warn          │
│ Security review  │ 30 turns       │ 1       │ None     │ Fail task     │
│ Documentation    │ 15 turns       │ 1       │ None     │ Continue      │
│ MCP call         │ 30 seconds     │ 3       │ Exp      │ Fallback      │
└──────────────────┴────────────────┴─────────┴──────────┴───────────────┘
* Writes are not idempotent: inspect or roll back before retrying.
```

**Rule of Thumb**

```text
Critical roles      → retry transient errors, then fail
Important roles     → retry, then warn
Optional roles      → retry once, then ignore
External services   → retry with backoff, then fallback
```

## Links

- [Building effective agents (Anthropic)](https://www.anthropic.com/engineering/building-effective-agents)
- [How we built our multi-agent research system (Anthropic)](https://www.anthropic.com/engineering/multi-agent-research-system)
- [Don't Build Multi-Agents (Cognition)](https://cognition.com/blog/dont-build-multi-agents)
