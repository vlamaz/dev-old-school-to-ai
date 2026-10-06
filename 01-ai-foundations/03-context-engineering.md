# Context engineering

Prompt Engineering focuses on instructions.

Context Engineering focuses on providing the right information.

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
MEMORY.md
+
Specifications
+
Tool Outputs
=
Context
```

## Sources of Context

### 1. User Prompt:

Direct instructions.

### 2. Conversation History:

Previous messages provide continuity.

### 3. Documentation:

Examples:

```text
README.md
CONTRIBUTING.md
docs/*
```

### 4. Agent Instructions:

Guide AI behavior.

Examples:

```text
AGENTS.md
CLAUDE.md
.copilot-instructions.md
```

### 5. Memory:

Contains project-specific knowledge accumulated over time.

Examples:

```text
MEMORY.md
project-memory.md
```

### 6. Specifications

Examples:

```text
Requirements
User Stories
EARS
OpenSpec documents
Design documents
```

### 7. External Knowledge

Examples:

```text
RAG
Knowledge Bases
Wikis
MCP Servers
Databases
```

## Context files

```text
README.md
AGENTS.md
MEMORY.md
specs/
docs/
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
