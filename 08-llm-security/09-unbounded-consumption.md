# Unbounded Consumption

Unbounded consumption (LLM10) is when an LLM application lets a user, a bug or a runaway process use resources without limit. The resources are tokens, time, compute and money. A single abusive request, or one broken agent loop, can cause an outage or a large bill. The financial side is sometimes called **denial of wallet**.

## Forms It Takes

- **Denial of service**: very long inputs, requests for huge outputs, or floods of concurrent requests exhaust capacity and slow everyone down.
- **Denial of wallet**: abuse or bugs drive up API bills. A public endpoint without limits can cost a lot in one night.
- **Runaway agents**: a loop that retries a failing step forever, or two agents that keep handing the same work back and forth.
- **Model extraction**: systematic querying to copy a model's behavior or to build a training set from its outputs.

## Example

```text
An agent is asked: "Fix all failing tests."
  ↓
One test can't pass because of an environment problem.
  ↓
The agent retries, reads the logs, retries, for hours.
  ↓
No turn limit and no budget → hundreds of dollars of tokens spent overnight
```

## How to Avoid It

- **Limit every level.** Cap input size, output tokens, turns per task, tool calls per run, and wall-clock time.
- **Budget per user and per key.** Set token and cost budgets with alerts, and stop when they are reached.
- **Authenticate and rate-limit.** Require login for expensive endpoints, and apply per-user rate limits and queues.
- **Use the provider's spending controls.** Set spending limits and alerts in the provider's console, so the bill cannot grow silently.
- **Stop loops in code.** Detect repeated identical actions and stop them, rather than trusting the model to notice it is stuck. See [Guardrails](../02-agentic-engineering/05-security.md#guardrails).
- **Spend less per request.** Use smaller models for simple steps, reuse repeated prompt prefixes through [prompt caching](../01-ai-foundations/06-context-engineering.md#7-prompt-caching), and don't send context the task doesn't need.
- **Monitor.** Track tokens, cost and request patterns per user, and alert on anomalies. See [Evaluation and Observability](../02-agentic-engineering/06-evaluation-and-observability.md).
- **Slow down extraction.** Limit how much of the model's behavior one user can sample, and watch for systematic query patterns.

## Related Notes

- [Harness](../02-agentic-engineering/02-harness.md), where loop limits and budgets are usually enforced
- [Guardrails](../02-agentic-engineering/05-security.md#guardrails) for the agent-side limits on loops and budgets
