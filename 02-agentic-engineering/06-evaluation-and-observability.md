# Evaluation and Observability

Agents are non-deterministic: the same request can produce different results on different runs, and a small change to a prompt, skill, model or tool can make things better on one task and worse on another.

- **Evaluation** answers: *is the agent (or my setup) good enough, and did my change make it better or worse?*
- **Observability** answers: *what did the agent actually do, and what did it cost?*

## Evaluation

### What to Evaluate

You rarely evaluate "the model". In practice you evaluate your **setup**: instruction files, skills, subagent prompts, tools, MCP servers, model and effort choice. Changing any of these is a change that can regress.

Look at:

- **Outcome**: did the task succeed? (tests pass, the bug is fixed, the spec is met)
- **Process**: did it use the right tools, stay within scope, avoid forbidden actions?
- **Cost**: tokens, money, time, number of turns
- **Reliability**: how often does it succeed across several runs?

### Golden Tasks

A **golden task** is a realistic task with a known good outcome, kept as a fixed test case:

```markdown
## Task: add pagination to GET /bookings

- Repo state: commit abc123
- Prompt: "Add cursor-based pagination to GET /bookings, max 50 items per page"
- Success: existing tests pass, new tests in tests/bookings/pagination.test.ts pass,
  no changes outside src/bookings/ and tests/
```

Build a small set (10 to 30 is a good start) from real work: tasks the agent did well, and especially tasks where it failed. Prefer success criteria that are checked by code (tests, a diff check, a script) over human judgment.

### Measuring Reliability

Because results vary, run each task several times:

- **pass@k**: at least one of k runs succeeded. Useful when a human picks the best attempt.
- **pass^k** (pass all k): every one of k runs succeeded. Better for unattended agents, where you need consistent success.
- **Success rate**: successes / runs, tracked over time.

A single successful run proves little.

### LLM-as-Judge

When the result can't be checked by code (quality of a summary, readability of a refactor, a review comment), you can use another model call to grade it against a rubric.

Caveats:

- Judges have biases: they tend to prefer longer answers, the first option shown, and output from their own model family.
- Scores drift when you change the judge's model or prompt.
- A vague rubric produces noisy scores. Use specific yes/no criteria ("Does the summary mention the breaking change?") rather than "rate 1 to 10".
- Calibrate: compare the judge with human grading on a sample before trusting it.

Use code-based checks where you can, and LLM-as-judge only for what remains.

### Regression Suites

Treat prompts, skills, instruction files and agent configurations like code:

```text
Change a skill or prompt
      ↓
Run the golden tasks (several runs each)
      ↓
Compare success rate, cost and turns with the previous version
      ↓
Merge only if it is not worse
```

Add a golden task every time you fix a real failure, the same way you add a regression test for a bug.

### Benchmarks

Public benchmarks such as SWE-bench measure models and agents on real GitHub issues. They are useful for comparing models, but they don't tell you how an agent will do on *your* codebase, with *your* conventions. Some benchmarks have also leaked into training data. Your own golden tasks matter more.

## Observability

### Transcripts and Traces

A **transcript** is the full record of a session: the prompts, the model's responses, every tool call with its arguments and results. A **trace** is the same information organized as a tree of timed steps (model call → tool call → subagent → ...).

Reading transcripts is the most effective way to improve an agent. Look for:

- Where it went wrong first (the first bad step, not the last)
- Tools that failed or were called repeatedly
- Missing context it had to search for every time (a candidate for the instruction file)
- Instructions it ignored

Coding harnesses keep session transcripts locally and let you resume or review past sessions. For subagents, check what task description they received and what summary they returned.

### Tokens, Cost and Context

Track:

- **Tokens** per session and per task (input, output, cached)
- **Cost** in money
- **Context usage**: how full the context window is, and what is filling it (instruction files, MCP tool definitions, file reads)
- **Turns and duration**

Harnesses show this interactively (in Claude Code, for example, with commands for usage and context). See [Commands](../03-ai-assisted-development/02-commands.md).

### OpenTelemetry

For teams, interactive commands are not enough. **OpenTelemetry** (OTel) is the open standard for exporting metrics, logs and traces to a monitoring backend (Prometheus, Grafana, Datadog, Honeycomb and others).

Claude Code can export OpenTelemetry metrics and events when telemetry is enabled with `CLAUDE_CODE_ENABLE_TELEMETRY=1` and the standard `OTEL_*` exporter settings. Exported data includes sessions, token usage, cost, lines of code changed, commits and pull requests, and tool decisions. Prompt text and tool details are redacted unless you explicitly enable them.

Typical uses:

- Cost per team or per project
- Adoption and usage trends
- Error rates of tools and MCP servers
- Detecting runaway sessions (unusual token use)

### Agents in CI

When agents run unattended (headless, in CI), observability is the only way to know what happened. Save the transcript or structured output of every run as a build artifact, set turn and budget limits, and alert on failures and unusual cost.

## Links

- [Demystifying evals for AI agents (Anthropic)](https://www.anthropic.com/engineering/demystifying-evals-for-ai-agents)
- [Claude Code monitoring with OpenTelemetry](https://code.claude.com/docs/en/monitoring-usage)
- [SWE-bench](https://www.swebench.com/)
