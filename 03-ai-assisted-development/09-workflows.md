# Workflows

AI-assisted coding means using an agent to generate, review, test, and document code while the developer stays responsible for design, validation, and decisions. Unlike vibe coding, you read and verify what the agent produces (see [Agentic Engineering](../02-agentic-engineering/README.md)).

The agent runs a loop: it reads, edits, runs commands, looks at the results, and repeats until it thinks it's done (see [The Agent Loop](../02-agentic-engineering/01-agents.md)). Good workflows shape that loop: give it the right context, a plan, and above all **a way to check its own work**.

## The Core Loop

```text
Explore   → read the relevant code, no edits
   ↓
Plan      → agree on the approach and the files to change
   ↓
Implement → small steps, each one verified (tests, build, lint)
   ↓
Review    → read the diff yourself; optionally a fresh-context AI review
   ↓
Commit    → small, focused commits and PRs
```

The most important habit: **give the agent a check it can run.** An agent stops when the work *looks* done. With a test suite, a build, a linter, or a screenshot to compare against, it can see its own mistakes and fix them. Without one, you are the only check.

Weak and strong prompts:

| Weak                             | Strong                                                                                                                  |
| -------------------------------- | ----------------------------------------------------------------------------------------------------------------------- |
| "Implement email validation."    | "Write `validateEmail`. Cases: `user@example.com` → true, `invalid` → false, `user@.com` → false. Run the tests after implementing." |
| "The build is failing."          | "The build fails with this error: (pasted error). Fix the root cause, don't suppress the error, and confirm the build passes." |
| "Make the dashboard look better." | "(Attached screenshot.) Implement this design. Take a screenshot of the result, compare, list differences, and fix them."       |

Ask for **evidence**, not claims: the test output, the command that was run and what it returned.

Other habits that pay off:

- **Context:** point to the spec and the relevant files instead of letting the agent search everything (see [Context](01-context.md)).
- **Small diffs:** one task per session, one concern per commit. Small diffs are easier to review, easier to revert, and keep the context focused.
- **Clean sessions:** `/clear` between unrelated tasks. After two failed corrections, start over with a better prompt instead of piling corrections into the context.
- **Course-correct early:** interrupt with `Esc` as soon as the agent heads the wrong way; rewind (`/rewind`, `/undo`) instead of arguing with a bad attempt.

## Plan Mode

Planning separates exploring from editing, so the agent doesn't solve the wrong problem. Use it when the change touches several files, the approach is unclear, or you don't know the code. Skip it when you could describe the diff in one sentence.

### Claude Code

`Shift+Tab` until the status bar shows plan mode, `/plan <task>`, or `claude --permission-mode plan`. Claude reads and runs read-only commands but doesn't edit. `Ctrl+G` opens the plan in your editor. Approving the plan switches to an editing mode.

### OpenCode

Press `Tab` to switch to the **Plan** agent, which asks before edits and shell commands. Switch back to **Build** to implement.

### GitHub Copilot CLI

`Shift+Tab` to plan mode, `/plan <task>`, or `copilot --plan`. `copilot --plan --mode autopilot` plans first and then continues into autopilot without waiting for approval.

## Test-Driven Development with AI

Tests are the strongest check you can give an agent, and writing them first stops it from writing tests that just confirm whatever the code does.

```text
1. Describe the behavior; ask for tests only, no implementation.
2. Run them and confirm they fail for the right reason.
3. Review the tests: are these the cases you want? Commit them.
4. Ask for the implementation. Tell the agent not to change the tests.
5. Iterate until the tests pass; then refactor with the tests green.
```

Example prompt:

```text
Write tests for booking cancellation in src/booking/. Rules:
- A booking can be cancelled until the driver picks up the passenger.
- After pickup, cancelling returns an error.
Follow the existing test style. Don't write the implementation yet.
Run the tests and show me that they fail.
```

Watch for agents that "fix" a failing test by weakening it. Review test changes as carefully as code changes.

## Debugging

Reproduce first, then fix. A failing test turns "it's broken" into a check the agent can run.

```text
Bug report / error
   ↓
Collect context (error, stack trace, logs, recent changes)
   ↓
Write a failing test that reproduces it
   ↓
Find the root cause
   ↓
Fix, run the test and the full suite
   ↓
Review the diff
```

Example:

```text
POST /bookings returns 500 Internal Server Error.
Expected: the booking is created.

Logs:
[paste logs]

1. Find the code path for this endpoint and explain the root cause.
2. Write a failing test that reproduces it.
3. Fix the root cause, not the symptom, and run the full test suite.
```

Useful asks:

- "What is the root cause?" works better than "how do I fix this?"
- "Compare expected and actual behavior."
- "Suggest two or three fixes with pros and cons" before choosing one.
- For performance: give the slow query, timings, or metrics, not just "it's slow".

Agents can read long stack traces and logs quickly; let them run the commands to collect them instead of pasting everything.

## Reviews

AI review is a first pass that makes human review faster, not a replacement for it.

```text
Implement → Self review → AI review (fresh context) → Fix → Human review → Merge
```

Review in a **fresh context**: the agent that wrote the code is biased toward its own reasoning. Use a subagent, a new session, or a built-in review command. Tell the reviewer to report only issues that affect correctness, security, or the requirements; a reviewer asked to find problems will always find some, and chasing every one leads to over-engineering.

What to review, by stage:

| Stage         | Ask the reviewer to look for                                                         |
| ------------- | ------------------------------------------------------------------------------------ |
| Requirements  | Ambiguities, missing acceptance criteria, edge cases, contradictions                 |
| Specification | Coverage, consistency, testability, feasibility                                      |
| Architecture  | Coupling, error handling, scalability, security, operational risks                   |
| Code / PR     | Bugs, security, maintainability, missing tests, unnecessary complexity, duplication  |
| Tests         | Missing scenarios, edge cases, untested paths                                         |
| Security      | Injection, authentication, authorization, data exposure, secrets                      |
| Docs          | Accuracy, missing information, unclear sections                                       |

One reusable prompt, adapted per stage:

```markdown
Review [the current diff | specs/booking/requirements.md | this design].

Focus on: [items from the table for this stage].

Report each finding with location, severity (Critical, High, Medium, Low),
and a suggested fix. Only report issues that affect correctness, security,
or the requirements. No style preferences.
```

For example, a requirements review of "Users can cancel bookings" should come back with: cancellation deadline? refund rules? who is allowed to cancel?

Built-in review commands:

- **Claude Code:** `/code-review` (alias `/review`) on the current diff, `/security-review` for vulnerabilities in your branch.
- **OpenCode:** no built-in review command; define a review subagent (see [Agents](08-agents.md)).
- **GitHub Copilot CLI:** `/review` (code review agent), `/security-review`, `/diff` to inspect changes.

Security reviews by AI are useful extra coverage but must be validated by an experienced engineer.

## Documentation

Agents are good at first drafts and at keeping docs in sync with code. Review for accuracy: generated docs often describe what the code *should* do.

```text
Analyze the repository and update README.md:
overview, installation, usage, development setup.
Only document commands you have verified exist in package.json.
```

Other useful asks: document an endpoint (request, response, errors), explain a module for a new developer, generate an architecture overview with a Mermaid diagram.

## Parallel Work with Worktrees

A git worktree is a second checkout of the same repo on another branch. Run one agent per worktree to work on several tasks at once without them editing the same files.

### Claude Code

`claude -w feature-auth` starts a session in `.claude/worktrees/feature-auth`. Subagents can get their own worktree with `isolation: worktree`. `claude --bg "<task>"` starts a background session; `claude agents` monitors them.

### OpenCode

No documented worktree command. Create one with `git worktree add ../repo-feature feature` and run `opencode` there.

### GitHub Copilot CLI

`copilot --worktree[=name]` starts in a worktree (under `<repo>.worktrees/` by default). In a session, `/new worktree` starts a new session in a new worktree.

## Headless and CI

All three tools can run a single prompt without the interactive UI, for scripts, git hooks, and CI. In unattended runs nobody answers permission prompts, so allow exactly the tools the task needs, and run in a container or CI runner, not on a machine with your credentials.

### Claude Code

```shell
claude -p "Run the tests and fix any failures" --allowedTools "Read,Edit,Bash(npm test *)"
git diff main | claude -p "Review this diff for bugs. Report findings by severity."
claude -p "Summarize this project" --output-format json | jq -r '.result'
```

- `--permission-mode acceptEdits` or `dontAsk` for unattended runs; `--max-turns` and `--max-budget-usd` cap a run.
- `--bare` skips loading hooks, skills, MCP servers, and `CLAUDE.md` for faster, reproducible runs.
- GitHub Actions: [anthropics/claude-code-action](https://github.com/anthropics/claude-code-action).

### OpenCode

```shell
opencode run "Run the tests and fix any failures"
opencode run --format json "Summarize this project"
```

- `--auto` approves every permission that isn't explicitly denied. Pair it with deny rules in `opencode.json`.
- `-m provider/model` and `--agent` pick the model and agent.

### GitHub Copilot CLI

```shell
copilot -p "Run the tests and fix any failures" --allow-all-tools --deny-tool='shell(git push)' --deny-tool=url
copilot -p "Summarize this project" --output-format=json
```

- Nobody can answer prompts, so tools must be approved up front. The docs list `--allow-all-tools` as required for programmatic use; narrow it with `--deny-tool` (deny always wins) or `--available-tools`.
- `--share` writes the session to a Markdown file after the run.

## Risks

- **Hallucinations:** looks correct ≠ is correct. Plausible code that skips edge cases is the most common failure. Verify with tests.
- **Hallucinated packages:** agents sometimes import packages that don't exist. Attackers register those names with malicious code (slopsquatting). Check every new dependency before installing: does it exist, is it maintained, is it the package you meant?
- **Secrets:** don't paste secrets into prompts; keep `.env` and credential files out of reach with deny rules (see [Tools & Permissions](04-tools-and-permissions.md)); check diffs for hardcoded keys before committing.
- **Prompt injection:** files, web pages, issues, and MCP results can contain instructions aimed at the agent. Be careful with auto-approve modes when the agent reads untrusted content (see [Security](../02-agentic-engineering/05-security.md)).
- **Unsafe code:** generated code can contain vulnerabilities (injection, missing authorization). Review security-sensitive paths yourself.
- **Technical debt:** accepting large diffs you haven't read creates code nobody on the team understands. If you can't explain it, don't merge it.
