# SDD Fundamentals

Spec-Driven Development (SDD) means writing a reviewable specification before the code, and using it as the contract that the AI (or a developer) implements and that tests verify.

A prompt is thrown away after the session. A spec lives in the repository, is reviewed like code, and is read again by the next agent session. That is the main difference from "just writing a long prompt".

## Levels of SDD

Birgitta Böckeler ([Understanding Spec-Driven-Development: Kiro, spec-kit, and Tessl](https://martinfowler.com/articles/exploring-gen-ai/sdd-3-tools.html), martinfowler.com, October 2025) describes three levels:

- **Spec-first:** a well thought-out spec is written first and used for the task at hand. After the task, the spec may be discarded.
- **Spec-anchored:** the spec is kept after the task is complete and is updated as the feature evolves. It stays the reference for future changes.
- **Spec-as-source:** the spec is the main source file. Humans edit only the spec, never the generated code.

```text
spec-first      →  spec-anchored          →  spec-as-source
(spec per task)    (living spec in repo)     (code is generated output)
```

Most teams today work between spec-first and spec-anchored. When you evaluate a framework, ask what happens to the spec after the change is merged.

## Generic Workflow

Frameworks use different names, but the steps are the same:

```text
  Specify
  ↓
  Plan / Design
  ↓
  Tasks
  ↓
  Implement
  ↓
  Verify
  ↓
  Update spec
```

The examples below follow a taxi booking feature.

1. _Specify_

   Understand the problem and write down what "done" means. Start with questions:
   - Who can book?
   - How is pricing calculated?
   - Can they cancel?
   - What happens if no drivers are available?

   Then write the spec. Acceptance criteria use [EARS](02-ears.md) and get IDs, so tasks and tests can point at them.

   ```markdown
   # Feature: Taxi Booking

   Actor: Registered user
   Goal: Book an immediate or scheduled ride.

   ## Requirements

   - REQ-1: The booking service shall require a pickup and a destination for every booking.
   - REQ-2: When the user enters a pickup and a destination, the app shall display the route on the map and a price estimate.
   - REQ-3: When the user confirms a booking, the booking service shall create the booking and return a booking reference.
   - REQ-4: While the user account is suspended, the app shall disable the booking button.
   - REQ-5: If no driver accepts the booking within 3 minutes, then the booking service shall cancel the booking and notify the user.
   - REQ-6: Where scheduled rides are enabled, the app shall allow the user to choose a pickup time up to 7 days ahead.
   ```

2. _Plan / Design_

   Define the technical approach: architecture, components, data, and integrations.

   ```text
   Frontend
   ├── Maps
   └── Booking UI

   Application Layer
   ├── BookRide
   ├── CancelRide
   └── EstimatePrice

   Infrastructure
   └── Taxi Provider API
   ```

3. _Tasks_

   Break the spec into small, verifiable tasks. Each task references the requirements it satisfies.

   ```text
   Task 1: Validate pickup and destination in BookRide        (REQ-1)
   Task 2: Show route and price estimate on the booking map   (REQ-2)
   Task 3: Create booking and return reference                (REQ-3)
   Task 4: Disable booking for suspended accounts             (REQ-4)
   Task 5: Driver timeout, cancellation and notification      (REQ-5)
   Task 6: Scheduled pickup time behind a feature flag        (REQ-6)
   ```

4. _Implement_

   The AI implements one task at a time from the spec.

   ```text
   Implement Task 3 according to the booking spec.
   Write a test for REQ-3 first.
   ```

   Where the spec lives depends on the framework: `openspec/specs/<domain>/spec.md` in OpenSpec, a folder per feature in Spec Kit, `.kiro/specs/` in Kiro.

5. _Verify_

   Check the implementation against the spec, not against the prompt. Each requirement ID should map to at least one test, and a reviewer (human or agent) checks that nothing outside the spec was built.

6. _Update spec_

   Merge what changed back into the living spec, so the next change starts from the current behavior. Without this step you are doing spec-first only, and specs slowly drift away from the code.

## SDD Frameworks

| | OpenSpec | GitHub Spec Kit | Kiro | BMad Method |
| --- | --- | --- | --- | --- |
| What it is | Open-source CLI + slash commands/skills for many AI tools | Open-source CLI (`specify`) + slash commands for many AI tools | AI IDE/agent product by AWS with built-in specs | Open-source method delivered as skills for AI coding tools |
| Main artifacts | `proposal.md`, delta `specs/`, optional `design.md`, `tasks.md` per change | Constitution, then per-feature spec, plan and tasks | `requirements.md` (or `bugfix.md`), `design.md`, `tasks.md` | Planning documents and stories, broader product/project planning |
| Workflow | explore → propose → apply → archive | constitution → specify → plan → tasks → implement (plus clarify / checklist / analyze quality gates) | requirements-first or design-first → tasks | clarify → plan → build and verify → learn and adjust |
| Requirement style | Requirements with SHALL/MUST and WHEN/THEN scenarios | Free-form user stories and acceptance criteria | EARS (`WHEN … THE SYSTEM SHALL …`) | Depends on the planning step |
| Spec over time | Delta specs merged into `openspec/specs/` on archive (spec-anchored) | Mostly per feature/branch (spec-first) | Mostly per feature or task (spec-first) | Planning documents per initiative |
| Weight | Light | Medium | Medium, tied to the IDE | Heavy |

When to pick which:

- **OpenSpec:** incremental changes to an existing codebase (brownfield), when you want specs to stay current after every change.
- **Spec Kit:** new features or projects where you want project-wide principles (the constitution) and explicit quality gates before coding.
- **Kiro:** you want specs built into the IDE and are fine with that tool.
- **BMad:** larger initiatives that need product and architecture planning, not only a feature spec.

Links:

- OpenSpec: <https://github.com/Fission-AI/OpenSpec>
- Spec Kit: <https://github.com/github/spec-kit>
- Kiro: <https://kiro.dev/docs/specs/>
- BMad Method: <https://docs.bmad-method.org/>

## Spec Drift

Spec drift happens when code changes but the spec does not. After a few months, the spec describes a system that no longer exists, and agents that read it produce wrong code.

To prevent it:

- Keep specs in the repository, next to the code, and review spec changes in the same pull request.
- Make "update the spec" part of the definition of done (OpenSpec's archive step does this).
- Fix bugs by first correcting the spec, then the code.
- Validate spec structure in CI where the framework allows it (e.g. `openspec validate`).

## When SDD Is Overkill

SDD has a cost: someone has to write and review the spec. It does not pay off for:

- Small bug fixes, typos, and one-line changes.
- Spikes and prototypes whose purpose is to learn, not to ship.
- Changes where the code is easier to review than the spec.

Böckeler's experiments found tools turning a small bug into several user stories and many acceptance criteria, and producing a lot of repetitive Markdown to review. A good rule: match the size of the spec to the size of the change, and skip it when a short prompt plus tests is enough.
