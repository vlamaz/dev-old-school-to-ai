# Harness

An AI agent harness (also called AI scaffolding) is the software infrastructure that wraps around a Large Language Model (LLM) to turn it into an active, functional AI agent.

Building a highly reliable AI worker depends less on upgrading to a slightly larger model and more on building a robust harness. A well-engineered harness minimizes a model's tendency to hallucinate by forcing it to verify its own work through automated code execution, step-by-step validation loops, and heavily constrained operating environments.

## README.md

File that contains human documentation: what the project is.

**Location:**

```text
Project: README.md
```

## AGENTS.md

Workflow guidance: how AI agents should work. Same as CLAUDE.md but generic. (<https://agents.md/#examples>)

Should contain at least:

- Project overview
- Build and test commands
- Code style guidelines
- Testing instructions
- Security considerations

**Location:**

```text
Project: AGENTS.md
```

## MEMORY.md

Long-term project context.

**Location:**

```text
Project: MEMORY.md
```

## USER-DEFINED COMMANDS

Commands for quick, deterministic, and single-use tasks. The user activates them manually.

**Locations:**

```text
Global: ~/.config/opencode/commands/
Per-project:
.opencode/commands/<name>.md
.claude/commands/<name>.md
.agents/commands/<name>.md

```

**Example:**

```markdown
---
description: Create a new component
agent: build
model: anthropic/claude-3-5-sonnet-20241022
---

Create a new React component named $ARGUMENTS with TypeScript support.
Include proper typing and basic structure.
```

**Usage:**

Invoked using `/<name>`

```text
/component <name>
```

## HOOKS

User-defined commands or logic that execute automatically at specific lifecycle events.

Enforces guardrails, blocks code, or automates side-effects.

Fires inevitably on lifecycle events.

**Locations:**

```text
settings.json
```

**Example:**

This hook completely blocks Claude from using rm to delete anything in your project

```json
{
  "hooks": [
    {
      "event": "PreToolUse",
      "matcher": {
        "tool": "Bash"
      },
      "handler": {
        "type": "command",
        "command": "grep -q 'rm ' && echo 'ERROR: rm commands are blocked!' && exit 2 || exit 0"
      }
    }
  ]
}
```

**Events:**

Claude Code supports up to 33 lifecycle hook events spanning session management, prompt validation, tool usage, subagent delegation, and task progression.

More used ones:

1. `PreToolUse`

- When it fires: Right before any tool (like a Bash command or a file edit) executes.
- Primary Use Case: Security and safety gates. It passes the tool arguments to your script, allowing you to parse the incoming command and throw an exit 2 to hard-block risky actions (like rm -rf / or unintended production deployments) before they run.

1. `PostToolUse`

- When it fires: Immediately after a tool finishes executing successfully.
- Primary Use Case: Workspace automation. This is most commonly used to run localized code formatters (like Prettier, Black, or Ruff) or linters right after Claude updates or creates a file so your codebase stays clean.

1. `Stop`

- When it fires: When Claude completely finishes a response turn or task, right before returning control to the user.
- Primary Use Case: Quality gates and test enforcement. Developers use it to trigger an automated test suite or build check. If the tests fail, you can block the response and instruct Claude to stay in the loop until the code passes.

1. `SessionStart`

- When it fires: The absolute moment a new Claude Code session is initiated or an existing session is resumed.
- Primary Use Case: Environment setup and context injection. Ideal for dynamically injecting environment variables, checking software dependencies, or preparing local logs.

1. `Notification`

- When it fires: Whenever Claude triggers a notification alert (e.g., when it is waiting for your manual permission or finishes a long-running background task).
- Primary Use Case: Team alerting. Used to forward the internal event out to systems like Slack, Discord, or desktop push notifications so you can safely look away while the AI is working.

## SKILLS

A skill is a set of instructions - packaged as a simple folder - that teaches Claude
how to handle specific tasks or workflows.
Skills provide the recipes: step-by-step instructions on how to create something
valuable.

<https://www.skills.sh/>

Create one folder per skill name and put inside it:

- `SKILL.md` (required): Instructions in Markdown with YAML frontmatter
- `scripts/` (optional): Executable code (Python, Bash, etc.)
- `references/` (optional): Documentation loaded as needed
- `assets/` (optional): Templates, fonts, icons used in output

Skill folder naming:

- Use kebab-case: `notion-project-setup`
- No spaces: `Notion Project Setup`
- No underscores: `notion_project_setup`
- No capitals: `NotionProjectSetup`

**Locations:**

```text
Project config: .opencode/skills/<name>/SKILL.md
Global config: ~/.config/opencode/skills/<name>/SKILL.md
Project Claude-compatible: .claude/skills/<name>/SKILL.md
Global Claude-compatible: ~/.claude/skills/<name>/SKILL.md
Project agent-compatible: .agents/skills/<name>/SKILL.md
Global agent-compatible: ~/.agents/skills/<name>/SKILL.md
```

**Schema:**

`[What it does] + [When to use it] + [Key capabilities]`

```markdown
---
name: your-skill
description: [...]
---

# Your Skill Name

# Instructions

### Step 1: [First Major Step]

Clear explanation of what happens.
```

**Plugins:**

`skill-creator` **plugin** in Claude helps you design and refine skills.

**Usage:**

Can be invoked explicitly using `@`.

### MCPs

MCP (Model Context Protocol) is an open-source standard for connecting AI applications to external systems.

Using MCP, AI applications like Claude or ChatGPT can connect to data sources (e.g. local files, databases), tools (e.g. search engines, calculators) and workflows (e.g. specialized prompts)—enabling them to access key information and perform tasks.

**Docs:** <https://modelcontextprotocol.io/>

**Locations:**

`.mcp.json`

**Example:**

```json
{
  "mcpServers": {
    "ado": {
      "command": "cmd",
      "args": [
        "/c",
        "npx",
        "-y",
        "@azure-devops/mcp@2.10.0",
        "ReservationApps",
        "--authentication",
        "azcli",
        "-d",
        "core",
        "repositories"
      ],
      "env": {
        "ado_mcp_project": "Takasi"
      }
    },
    "atlassian": {
      "type": "http",
      "url": "https://mcp.atlassian.com/v2/mcp"
    }
  }
}
```

Useful MCPs:

- JIRA (mcp.atlassian.com)
- AzureDevops CLI
- Context7.com: Up-to-date docs for AI agents

More severs: <https://mcpservers.org/>
