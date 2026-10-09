# OpenSpec (SDD lightweight framework)

OpenSpec is an open-source, lightweight framework for Spec-Driven Development (SDD) in AI-assisted coding workflows (Claude Code, Cursor, GitHub Copilot, Codex, and others). It is built for changes to existing codebases: each change carries delta specs that are merged into the main specs when the change is archived.

Sources:

- Official repository and docs: <https://github.com/Fission-AI/OpenSpec> (see the `docs/` folder: getting started, commands, CLI, supported tools)
- Secondary (Spanish, may describe an older version): <https://www.mentorestech.com/resource-blog-content/openspec-como-implementar-spec-driven-development-con-ia-sin-perder-control-ni-calidad>

**Installation & Set up**

Requires Node.js 20.19.0 or higher.

```shell
npm install -g @fission-ai/openspec@latest
# or: brew install openspec

cd <your-project>
openspec init
```

`openspec init` asks which AI tools to configure (or pass `--tools`) and generates their skills and slash commands. After upgrading OpenSpec, run `openspec update` to regenerate them.

**Profiles and Workflow Skills**

OpenSpec installs a set of skills (and slash commands) per tool. Which ones depends on the profile:

```text
Core profile (default)
├── openspec-explore/              /opsx:explore   think through an idea first
├── openspec-propose/              /opsx:propose   create a change and its planning artifacts
├── openspec-apply-change/         /opsx:apply     implement a change's tasks
├── openspec-update-change/        /opsx:update    revise a change's planning artifacts
├── openspec-sync-specs/           /opsx:sync      merge delta specs into main specs (optional)
└── openspec-archive-change/       /opsx:archive   move a finished change to the archive

Expanded profile (adds)
├── openspec-new-change/           /opsx:new           start an empty change scaffold
├── openspec-continue-change/      /opsx:continue      create the next artifact
├── openspec-ff-change/            /opsx:ff            create all planning artifacts at once
├── openspec-verify-change/        /opsx:verify        check the implementation matches the artifacts
├── openspec-bulk-archive-change/  /opsx:bulk-archive  archive several changes at once
└── openspec-onboard/              /opsx:onboard       guided tutorial through the workflow
```

To switch profile, run `openspec config profile`, then `openspec update`.

Where the skills are written depends on the tool:

- Claude Code: `.claude/skills/openspec-*/SKILL.md`, with slash commands in `.claude/commands/opsx/`.
- Codex, Zed, and other AGENTS.md-compatible tools: `.agents/skills/openspec-*/SKILL.md`.
- Other tools (Cursor, GitHub Copilot, ...) use their own folders; see `docs/supported-tools.md`.

The slash-command spelling also differs per tool. Don't assume the Claude Code form works elsewhere:

| Tool | Example |
| --- | --- |
| Claude Code | `/opsx:propose` |
| Cursor, GitHub Copilot | `/opsx-propose` |
| Codex | `$openspec-propose` |

The rest of this note uses the Claude Code spelling.

**Locations**

```text
openspec/
├── config.yaml     optional project settings; `context` holds project guidance for the AI
├── specs/          current system behavior, one folder per domain (<domain>/spec.md)
└── changes/        in-motion changes, one folder per change
    └── archive/    completed changes move here, as YYYY-MM-DD-<change-name>/
```

**Workflow**

**Step 1: Explore (AI, optional)**

Think the idea through with your agent before you ask for a plan.

Run:

```text
/opsx:explore Add a date filter to the bookings list
```

Explore is a thinking mode. The agent investigates your codebase, asks the questions that matter, sketches options, and challenges assumptions. It never writes code. It writes nothing else unless you ask it to capture what you decided, or say yes when it offers. The output is a sharper idea, ready for `/opsx:propose`.

**Step 2: Create proposal (AI)**

Propose turns the idea into a reviewable plan.

Run:

```text
/opsx:propose add-date-filter
```

It creates a folder `openspec/changes/<change-name>/` (here `add-date-filter`) with:

```text
├── proposal.md            why, and what changes
├── specs/<domain>/spec.md delta specs: what "done" means, as requirements with scenarios
├── design.md              technical decisions (only when the change needs one)
└── tasks.md               the implementation checklist
```

No code yet. Propose stops at the plan.

A delta spec only describes what the change adds, modifies, or removes. Requirements use `SHALL`/`MUST`, and each has one or more scenarios:

```markdown
# Delta for Bookings

## ADDED Requirements

### Requirement: Filter bookings by date
The bookings list SHALL allow the user to filter bookings by a date range.

#### Scenario: Filter by range
- GIVEN the user has bookings on 1, 5 and 10 March
- WHEN the user filters from 2 to 9 March
- THEN only the booking on 5 March is shown

#### Scenario: Empty result
- WHEN the user filters a range with no bookings
- THEN the list shows "No bookings in this period"

## MODIFIED Requirements

### Requirement: Bookings list sorting
The bookings list SHALL be sorted by pickup date, newest first.
(Previously: sorted by creation date)
```

The requirement sentences can follow [EARS](02-ears.md), and the scenarios follow Given/When/Then.

**Step 3: Review and correct the plan (you + CLI)**

Fix the plan while it's still words and nothing is built yet. Read in this order:

1. `proposal.md`: is this the right problem, at the right size?
2. `specs/`: the highest-value read. Would you accept these requirements and scenarios as done?
3. `design.md` (if present): are the technical decisions sound?
4. `tasks.md`: do the tasks cover the specs, and nothing more?

To view what has been generated, run:

```shell
openspec show add-date-filter
```

Before implementing, validate the structure:

```shell
openspec validate add-date-filter --strict
```

If there are formatting or structural issues, it is better to correct them now rather than later.

**Step 4: Refine the plan (AI)**

Ask the agent to revise the planning artifacts, so they stay coherent with each other. Run the command, then tell the agent what to change (for example, "add a scenario for an invalid range, end before start"):

```text
/opsx:update add-date-filter
```

`/opsx:update` only edits planning artifacts, never code.

Put each refinement in the right file:

- `specs/`: scenarios, edge cases, and acceptance criteria.
- `design.md`: technical constraints and decisions.
- `proposal.md`: only the why and the scope.

In `tasks.md`, ensure that each task is:

- verifiable,
- small,
- measurable,
- unambiguous.

This refinement makes the difference between "AI improvising" and "AI executing."

**Step 5: Apply change (AI)**

Apply turns the plan into code. Run:

```text
/opsx:apply add-date-filter
```

⚠️ Personal tip (not an OpenSpec rule): start a fresh session first, since implementation goes better on a clean context window. The plan is on disk, so nothing is lost.

At this point, the agent reads `tasks.md`, implements tasks one by one, and checks them off. The AI works according to a plan.

With the expanded profile, run `/opsx:verify add-date-filter` afterwards to check that the implementation matches the artifacts.

**Step 6: Sync and archive change (AI)**

Do it when every box in `tasks.md` is checked and the change is validated:

```text
/opsx:archive add-date-filter
```

Here's what happens:

- it checks that artifacts and tasks are complete, and warns if tasks are still open,
- if the delta specs haven't been merged yet, it offers to sync them into `openspec/specs/` (you can also do this earlier with `/opsx:sync`),
- it moves the change folder to `openspec/changes/archive/YYYY-MM-DD-add-date-filter/`,
- `openspec/specs/` now reflects the system's new state, and the archive keeps the history: what changed, why, how, and when.

The CLI equivalent, `openspec archive add-date-filter`, applies the spec deltas by default (`--skip-specs` to skip them).

That "closing" step is what prevents your repo from turning into a collection of lost decisions, and what keeps OpenSpec spec-anchored rather than spec-first (see [SDD Fundamentals](01-sdd-fundamentals.md#levels-of-sdd)).

**CLI Cheat-Sheet**

```shell
openspec init [--tools <list>] [--profile <profile>]  # set up OpenSpec in a project
openspec update                       # regenerate skills/commands after upgrading or changing profile
openspec list [--specs | --changes]   # list changes (default) or specs
openspec view                         # interactive dashboard
openspec show <name>                  # show a change or spec
openspec validate <name> [--strict]   # validate structure (--all for everything)
openspec archive <name> [-y]          # archive a change and apply its spec deltas
openspec config profile               # choose core or expanded workflow
```
