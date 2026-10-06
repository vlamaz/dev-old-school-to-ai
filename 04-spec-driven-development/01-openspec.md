# OpenSpec (SDD lightweight framework)

OpenSpec is an open-source, lightweight, and highly configurable framework designed to implement Spec-Driven Development (SDD) in AI-assisted coding workflows (such as Claude Code, Cursor, GitHub Copilot, and others).

<https://www.mentorestech.com/resource-blog-content/openspec-como-implementar-spec-driven-development-con-ia-sin-perder-control-ni-calidad>

**Installation & Set up**

```shell
npm install -g @fission-ai/openspec@latest

cd <your-project>
openspec init
```

**Workflow Skills**

```text
.agents/skills/
├── openspec-explore/              think through an idea first
├── openspec-propose/              propose a change
├── openspec-apply-change/         implement a change's tasks
├── openspec-update-change/        revise a change's plan
├── openspec-sync-specs/           sync a change's spec updates into specs/
├── openspec-archive-change/       move a finished change to the archive
├── openspec-verify-change/        check the implementation matches the plan (not included by default)
└── openspec-bulk-archive-change/  archive several changes at once (not included by default)
```

**Locations**

```text
openspec/
├── config.yaml     project settings and context for the AI
├── specs/          your specs
└── changes/        in-motion changes
    └── archive/    completed changes move here
```

**Workflow**

**Step 1: Explore (IA)**

Think the idea through with your agent before you ask for a plan.

Run:

```text
/opsx:explore Add date filter
```

Explore is a thinking mode. The agent investigates your codebase, asks the questions that matter, sketches options, and challenges assumptions. It never writes code. It writes nothing else unless you ask it to capture what you decided, or say yes when it offers. The output is a sharper idea.

**Step 2: Create proposal (IA)**

Propose turns the idea into a reviewable plan.

Run:

```text
/opsx:proposal Add date filter
```

It creates a folder inside `openspec/changes/<spec-name>` with:

```text
├── proposal.md    why, and what changes
├── specs/         what "done" means, as testable requirements
├── design.md      technical decisions (only when the change needs one)
└── tasks.md       the implementation checklist
```

No code yet. Propose stops at the plan.

**Step 3: Review and correct the plan (CLI)**

Fix the plan while it's still words and nothing is built yet. Read in this order:

1. `proposal.md`: is this the right problem, at the right size?
2. `specs/`: the highest-value read. Would you accept these requirements as done?
3. `tasks.md`: do the tasks cover the specs, and nothing more?

To view the details of what has been generated and confirm that the change makes sense before implementing it, run:

```shell
openspec show add-date-filter
```

Before implementing, run:

```shell
openspec validate add-date-filter
```

If there are formatting or structural issues, it is better to correct them now rather than later.

**Step 4: Refine proposal and tasks (IA)**

In `proposal.md`, reinforce:

- scenarios,
- edge cases,
- acceptance criteria,
- technical constraints.

  In `tasks.md`, ensure that each task is:

- verifiable,
- small,
- measurable,
- unambiguous.

  This refinement makes the difference between "AI improvising" and "AI executing."

**Step 5: Apply change (IA)**

Apply turns the plan into code. Run:

```text
/opsx:apply add-date-filter
```

⚠️ Start a fresh chat session, since implementation goes better on a clean context window.

At this point, Claude reads `tasks.md`, implements tasks one by one, and marks progress. The AI ​​works according to a plan.

**Step 6: Archive change (IA)**

Once the change has been completed and validated, archive it:

```text
/opsx:archive add-date-filter
```

Do it When every box in `tasks.md` is checked.

Here’s what happens:

- it updates your main specs with the change's requirements, and it moves the change folder into the archive folder `openspec/changes/archive/`
- `openspec/specs/` is updated to reflect the system's new state
- full traceability is maintained: what changed, why, how, and when

  That “closing” step is what prevents your repo from turning into a collection of lost decisions.
