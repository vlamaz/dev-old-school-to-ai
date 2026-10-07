# Context engineering

**Prompt Engineering** focuses on instructions.

**Context Engineering** focuses on providing the right information.

## What Is Context?

Context is all the information available to the model when generating a response.

Examples:

```text
User Prompt
    +
Chat History
    +
Source Code
    +
README.md
    +
AGENTS.md
    +
Memory
    +
Specifications
    +
Tool Outputs
    =
Context
```

The best AI results rarely come from clever prompts. They come from providing the right context: requirements, architecture, business rules, examples, constraints, and relevant knowledge.

Context is the fuel that powers effective AI-assisted development.

## Sources of Context

1. **User Prompt**

   Direct instructions.

2. **Conversation History**

   Previous messages provide continuity.

3. **Documentation**

   Examples:

   ```text
   README.md
   CONTRIBUTING.md
   docs/*
   ```

4. **Agent Instructions**

   Guide AI behavior.

   Examples:

   ```text
   AGENTS.md
   CLAUDE.md
   .github/copilot-instructions.md
   ```

5. **Memory**

   Contains project-specific knowledge accumulated over time. Memory is tool-specific: a `MEMORY.md` in the project root is not loaded automatically.

   Examples:

   ```text
   Claude Code auto memory (~/.claude/projects/<project>/memory/MEMORY.md)
   Decisions recorded as ADRs
   ```

6. **Specifications**

   Examples:

   ```text
   Requirements
   User Stories
   EARS
   OpenSpec documents
   Design documents
   ```

7. **External Knowledge**

   Examples:

   ```text
   RAG
   Knowledge Bases
   Wikis
   MCP Servers
   Databases
   ```

## Common Context files

```text
project/
│
├── README.md
├── AGENTS.md
│
├── specs/
│   ├── requirements.md
│   ├── design.md
│   └── tasks.md
│
├── docs/
│   ├── architecture.md
│   ├── api.md
│   └── adr/
│
└── knowledge/
    ├── glossary.md
    └── business-rules.md
```

## Context Windows

A Context Window is the maximum amount of information an AI model can process at one time.

This information can include:

```text
Your prompt
Previous messages in the conversation
Uploaded files
Documentation
Tool outputs
System instructions
```

Think of it as the AI's working memory.

The context window determines how much information the model can "see" before generating a response.

## Context Compression

Context windows are limited.

Good context engineering means sending only relevant information.

## Links

- LangChain - Context Engineering: https://www.langchain.com/blog/context-engineering-for-agents
- Context Engineering Guide: https://www.promptingguide.ai/guides/context-engineering-guide
