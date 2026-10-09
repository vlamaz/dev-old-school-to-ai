# Skills & Commands

A **skill** is a folder of instructions (plus optional scripts and reference files) that teaches the agent a specific task or workflow. Only its name and description sit in the context; the full content loads when the skill is used. A **custom command** is a saved prompt you trigger by name. For the concept, see [Harness: Skills](../02-agentic-engineering/02-harness.md).

| | Custom command | Skill |
| --- | --- | --- |
| Who triggers it | You, by name | You by name, or the agent when the task matches the description |
| Content | One prompt template | `SKILL.md` plus optional `scripts/`, `references/`, `assets/` |
| Best for | Quick, repeatable prompts | Reusable know-how and multi-step workflows |

Skills follow the open [Agent Skills](https://agentskills.io) format, so one `SKILL.md` can work in all three tools. Commands don't carry over: each tool has its own format.

## Writing a Skill

Create one folder per skill:

```text
my-skill/
├── SKILL.md        (required: YAML frontmatter + instructions)
├── scripts/        (optional: executable code, Python, Bash, etc.)
├── references/     (optional: docs loaded only when needed)
└── assets/         (optional: templates, fonts, icons used in output)
```

`SKILL.md`:

```markdown
---
name: release-notes
description: Writes release notes from merged pull requests. Use when the user asks for release notes, a changelog, or a summary of what shipped.
---

# Release Notes

## Steps

1. List the pull requests merged since the last tag.
2. Group them into Features, Fixes, and Internal.
3. Write one line per change, in the past tense, linking the PR.

## Rules

- Skip dependency bumps unless they are security fixes.
- Follow the format in references/template.md.
```

Writing tips:

- The `description` decides when the agent uses the skill. Say **what it does** and **when to use it**, with the words a user would type.
- Use kebab-case names that match the folder name (`release-notes`). OpenCode enforces this: lowercase letters, digits, and single hyphens, 1–64 characters.
- Keep `SKILL.md` focused. Move long reference material to `references/` and tell the skill when to read it.
- Treat third-party skills like code: read them before installing. A skill can run scripts and instruct the agent to do anything.

## Claude Code

**Locations:**

```text
Personal:  ~/.claude/skills/<name>/SKILL.md
Project:   .claude/skills/<name>/SKILL.md
Nested:    <subdir>/.claude/skills/<name>/SKILL.md
Plugin:    <plugin>/skills/<name>/SKILL.md
```

Claude Code does **not** read `.agents/skills/`.

**Invocation:** type `/<name> [arguments]`, or Claude loads it automatically when the request matches the description. `/skills` lists them.

**Custom commands are now skills.** A file at `.claude/commands/deploy.md` and a skill at `.claude/skills/deploy/SKILL.md` both create `/deploy`. Existing `.claude/commands/` files keep working; new work should use skills.

**Useful frontmatter** (Claude Code extends the standard):

| Field                      | Effect                                                                       |
| -------------------------- | ---------------------------------------------------------------------------- |
| `description`              | When to use it (recommended)                                                 |
| `argument-hint`            | Shown in autocomplete, e.g. `[issue-number]`                                 |
| `disable-model-invocation` | `true`: only you can trigger it with `/name` (good for deploys, releases)    |
| `user-invocable`           | `false`: hidden from the `/` menu; only Claude uses it (background knowledge) |
| `allowed-tools`            | Tools that run without asking while the skill is active                      |
| `model`, `effort`          | Override the model or effort for that turn                                   |
| `context: fork`            | Run in a subagent with its own context (`agent:` picks which one)            |
| `paths`                    | Only auto-load when working with matching files                              |

**Arguments:** `$ARGUMENTS` is everything after the name; `$0`, `$1`… are positional.

```markdown
---
description: Fix a GitHub issue
argument-hint: [issue-number]
disable-model-invocation: true
---

Fix GitHub issue $ARGUMENTS following our coding standards.
Write a failing test first, then the fix.
```

Saved as `.claude/skills/fix-issue/SKILL.md`, run it with `/fix-issue 123`.

**Creating skills:** ask Claude to write one, or use Anthropic's `skill-creator` skill ([anthropics/skills](https://github.com/anthropics/skills)), which helps design, test, and refine them. Skills, agents, hooks, and MCP servers can be bundled and shared as a **plugin** (`/plugin`).

## OpenCode

### Skills

**Locations:**

```text
Project:                   .opencode/skills/<name>/SKILL.md
Global:                    ~/.config/opencode/skills/<name>/SKILL.md
Project, Claude-compatible: .claude/skills/<name>/SKILL.md
Global, Claude-compatible:  ~/.claude/skills/<name>/SKILL.md
Project, agent-compatible:  .agents/skills/<name>/SKILL.md
Global, agent-compatible:   ~/.agents/skills/<name>/SKILL.md
```

**Invocation:** the agent loads skills on demand through its built-in `skill` tool, based on name and description. Control access per skill with `permission.skill` in `opencode.json`.

**Frontmatter:** only `name` (must match the folder), `description` (1–1024 characters), `license`, `compatibility`, and `metadata`. Other fields are ignored.

### Custom commands

**Locations:**

```text
Global:      ~/.config/opencode/commands/<name>.md
Per-project: .opencode/commands/<name>.md
```

Or under the `command` key in `opencode.json`. The file name is the command name.

**Example** (`.opencode/commands/component.md`):

```markdown
---
description: Create a new component
agent: build
model: anthropic/claude-sonnet-5-5
---

Create a new React component named $ARGUMENTS with TypeScript support.
Include proper typing and basic structure.
```

Frontmatter: `description`, `agent` (which agent runs it), `model`, and `subtask: true` to run it as a subagent. Placeholders: `$ARGUMENTS`, `$1`, `$2`…

**Usage:**

```text
/component BookingCard
```

## GitHub Copilot CLI

**Locations** (first found wins for duplicate names):

```text
Project:   .github/skills/<name>/SKILL.md
           .agents/skills/<name>/SKILL.md
           .claude/skills/<name>/SKILL.md
Personal:  ~/.copilot/skills/<name>/SKILL.md
           ~/.agents/skills/<name>/SKILL.md
```

**Invocation:** `/<name>`, or the agent uses it automatically. Manage them with `/skills` (`list`, `info`, `add`, `remove`, `reload`) or `copilot skill add ./my-skill/SKILL.md`.

**Frontmatter:** `name` and `description` are required. Optional: `argument-hint`, `allowed-tools`, `user-invocable`, `disable-model-invocation`.

Copilot CLI has no separate custom-command format; use a skill with `disable-model-invocation: true` for a command you trigger by hand.

## Links

- [Claude Code: Skills](https://code.claude.com/docs/en/skills)
- [OpenCode: Skills](https://opencode.ai/docs/skills/) · [Commands](https://opencode.ai/docs/commands/)
- [Copilot CLI: Skills reference](https://docs.github.com/en/copilot/reference/copilot-cli-reference/cli-command-reference)
- [Agent Skills specification](https://agentskills.io)
- [The Open Agent Skills Ecosystem](https://www.skills.sh/)
- [Agent Harness by Gentleman Programming](https://www.youtube.com/watch?v=5Q7jV8TpMXA)
