# Spec Driven Development (SDD)

Spec Driven Development (SDD) is a software development approach where you write and refine specifications first, and those specifications become the primary source of truth for design, implementation, testing, and AI-assisted coding.

With tools like Claude Code, OpenCode, Cursor, GitHub Copilot, and AI coding agents, developers discovered that AI produces much better results when given a detailed specification rather than vague prompts.

Instead of saying: `Build a taxi booking page`

you create a specification describing:

- User goals
- Business rules
- UI behavior
- Edge cases
- API interactions
- Acceptance criteria
- Non-functional requirements

Then the AI generates the implementation from that specification.

```text
  Requirement
  ↓
  Specification
  ↓
  Review & refine
  ↓
  Implementation
  ↓
  Tests generated from spec
```

**EARS (Easy Approach to Requirements Syntax)**

Structured template mechanism designed to write clear, concise, and unambiguous software and system requirements.

Depending on the behavior you want to document, EARS provides five basic structures:

1. _Ubiquitous_

- Keyword: None (Always active)
- When to use: Fundamental or continuous system properties.
- Example: `The mobile phone shall weigh less than 150 grams.`

1. _Event-driven_

- Keyword: `When`
- When to use: The system reacts to a specific, instantaneous trigger.
- Example: `When the user clicks 'Pay', the website shall generate an invoice.`

1. _State-driven_

- Keyword: `While`
- When to use: Active behaviors that only apply during a specific condition or state.
- Example: `While the battery is below 20%, the device shall reduce the screen brightness.`

1. _Optional Feature_

- Keyword: `Where`
- When to use: Applies only if the system includes a specific optional component.
- Example: `Where the hardware includes a fingerprint reader, the app shall offer biometric login.`

1. _Unwanted Behavior_

- Keywords: `If... then`
- When to use: Error handling, system failures, exceptions, or misuse cases.
- Example: `If the uploaded file exceeds 25 MB, then the system shall reject the upload.`

1. _Complex Requirements_

- Keyword: N/A
- When to use: When a system behavior requires multiple conditions simultaneously, patterns can be combined by respecting the chronological order of the keywords:
- Example: `While the account is locked, when a login attempt occurs, the system shall log the event.`

Why Use EARS?

- Reduces Misunderstandings: It replaces ambiguous adjectives (like "the system must be fast" or "user-friendly") with deterministic logic blocks.
- Test-Ready: Because it features a clear trigger and response, QA teams can directly transform these requirements into acceptance criteria and test cases.
- AI-Friendly: Modern AI coding assistants and requirements-driven development tools parse EARS syntax perfectly to generate exact code without "hallucinations".

Sample:

```markdown
# Requirements Specification: ATM Cash Dispenser

This document outlines the system requirements for the **ATM Cash Dispenser** using the **EARS (Easy Approach to Requirements Syntax)** framework.

## 1. Ubiquitous Requirements (Always Active)

- The **ATM** shall **display** the bank logo on the home screen.
- The **ATM** shall **encrypt** all user input data during transmission.

## 2. Event-driven Requirements (Triggered by Actions)

- **When** the user inserts a valid debit card, the **ATM** shall **prompt** for the PIN.
- **When** the user selects the "Print Receipt" option, the **ATM** shall **dispense** a paper receipt.

## 3. State-driven Requirements (Active During a Specific State)

- **While** the ATM is out of cash, the **ATM** shall **display** a "Deposit Only" message.
- **While** the network connection is offline, the **ATM** shall **disable** the cash withdrawal feature.

## 4. Optional Feature Requirements (Component Dependent)

- **Where** the ATM includes a contactless NFC reader, the **ATM** shall **allow** tap-to-login.
- **Where** the hardware includes a braille keyboard, the **ATM** shall **provide** audio navigation instructions.

## 5. Unwanted Behavior Requirements (Error & Exception Handling)

- **If** the user enters an incorrect PIN three consecutive times, **then** the **ATM** shall **retain** the card.
- **If** the requested withdrawal amount exceeds the user's current account balance, **then** the **ATM** shall **display** an "Insufficient Funds" error message.

## 6. Complex Requirements (Combination of Patterns)

- **While** the system is in maintenance mode, **when** a card is inserted, the **ATM** shall **eject** the card immediately.
- **While** the receipt printer is out of paper, **when** a transaction completes, the **ATM** shall **send** a digital receipt to the user's registered email address.
```

**Typical SDD Workflow**

1. _Explore_

   Understand the problem.

   Example: `Users can book a taxi for now or later.`

   Questions explored:
   - Who can book?
   - How is pricing calculated?
   - Can they cancel?
   - What happens if no drivers are available?

2. _Proposal_

   Create a formal feature specification.

   ```markdown
   Feature: Taxi Booking

   Actors:

   - Registered User

   Goal:

   - Book immediate or scheduled rides

   Business Rules:

   - User account must be active
   - Pickup and destination required
   - Price estimate shown before booking

   Acceptance Criteria:

   - User sees route on map
   - User confirms booking
   - Booking reference generated
   ```

3. _Design_

   Define technical architecture.

   ```text
   Frontend
   ├── React
   ├── Maps
   ├── Authentication
   └── Booking UI
    
   Application Layer
   ├── BookRide
   ├── CancelRide
   └── EstimatePrice
    
   Infrastructure
   └── Taxi Provider API
   ```

4. _Tasks_

   Break specification into implementation work.

   ```text
   Task 1: Login Page
   Task 2: Registration
   Task 3: Booking Map
   Task 4: Price Estimation
   Task 5: Notifications
   ```

   1. Implementation

   AI or developers implement directly from the specification.

   Example prompt:

   ```text
   Implement Task 3 according to
   specs/booking/spec.md
   ```

   Because the specification contains all rules, AI produces much more accurate code.

**SDD Frameworks**

- OpenSpec: <https://openspec.dev/>
- Kiro: <https://kiro.dev/>
- BMAD (Breakthrough Method for Agile AI-Driven Development): <https://docs.bmad-method.org/>
- Spec Kit (Github): <https://github.com/github/spec-kit>

## OpenSpec (SDD lightweight framework)

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

```claude
/opsx:explore Add date filter
```

Explore is a thinking mode. The agent investigates your codebase, asks the questions that matter, sketches options, and challenges assumptions. It never writes code. It writes nothing else unless you ask it to capture what you decided, or say yes when it offers. The output is a sharper idea.

**Step 2: Create proposal (IA)**

Propose turns the idea into a reviewable plan.

Run:

```claude
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

```claude
/opsx:apply add-date-filter
```

⚠️ Start a fresh chat session, since implementation goes better on a clean context window.

At this point, Claude reads `tasks.md`, implements tasks one by one, and marks progress. The AI ​​works according to a plan.

**Step 6: Archive change (IA)**

Once the change has been completed and validated, archive it:

```claude
/opsx:archive add-date-filter
```

Do it When every box in `tasks.md` is checked.

Here’s what happens:

- it updates your main specs with the change's requirements, and it moves the change folder into the archive folder `openspec/changes/archive/`
- `openspec/specs/` is updated to reflect the system's new state
- full traceability is maintained: what changed, why, how, and when

  That “closing” step is what prevents your repo from turning into a collection of lost decisions.
