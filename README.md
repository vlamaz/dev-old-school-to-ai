# dev-old-school-to-ai

> My journey from traditional software development to AI-powered engineering.

## 🚀 Why this repository exists

I started my career as a classic software developer: writing code line by line, learning frameworks, debugging applications, and applying software engineering best practices.

The software industry is now entering a new era. Artificial Intelligence is changing how we design, build, test, document, and maintain software. Modern developers are no longer just programmers. They are architects, problem solvers, and collaborators working alongside AI tools.

This repository documents my transformation from an old-school developer to an AI-powered developer.

It contains notes, experiments, resources, prompts, architectural ideas, and lessons learned while exploring modern AI-driven development practices such as Spec-Driven Development (SDD), AI coding assistants, agentic workflows, and AI-native software engineering.

The goal is not to replace engineering fundamentals, but to amplify them with AI.

## 🎯 Learning Goals

- Master AI-assisted development workflows
- Learn Prompt Engineering and Context Engineering
- Explore Agentic Development
- Practice Spec Driven Development (SDD)
- Improve software architecture and system design skills
- Evaluate modern AI tools and coding assistants
- Build real-world projects faster and better
- Continuously document learnings and insights

## 🧭 How to read this repo

The chapters build on each other, so reading them in order works best:

```text
01 AI Foundations
  ↓  how LLMs work, prompts, embeddings, RAG, tools, context
02 Agentic Engineering
  ↓  agents and harnesses: AI that plans and acts, not just answers
03 AI-Assisted Development
  ↓  hands-on with Claude Code, OpenCode, and GitHub Copilot CLI
04 Spec-Driven Development
  ↓  specifications as the source of truth for AI-generated code
05 LLM Security
     main security risks in applications built on LLMs
```

New to the vocabulary? Keep the [Glossary](01-ai-foundations/glossary.md) open while reading. Every term links back to the note that explains it.

## 📚 Contents

### [01 · AI Foundations](01-ai-foundations/README.md)

What AI is, how modern models work, and the core building blocks behind every AI tool.

1. [LLMs](01-ai-foundations/01-LLMs.md)
2. [Prompt Engineering](01-ai-foundations/02-prompt-engineering.md)
3. [Embeddings](01-ai-foundations/03-embeddings.md)
4. [RAG](01-ai-foundations/04-rag.md)
5. [Tools](01-ai-foundations/05-tools.md)
6. [Context Engineering](01-ai-foundations/06-context-engineering.md)

Also: [Glossary](01-ai-foundations/glossary.md)

### [02 · Agentic Engineering](02-agentic-engineering/README.md)

Humans set goals and validate work; AI agents plan, write, test, and iterate.

1. [Agents](02-agentic-engineering/01-agents.md)
2. [Harness](02-agentic-engineering/02-harness.md)
3. [Multi-Agent Systems](02-agentic-engineering/03-multi-agent-systems.md)
4. [Memory](02-agentic-engineering/04-memory.md)
5. [Security and Safety](02-agentic-engineering/05-security.md)
6. [Evaluation and Observability](02-agentic-engineering/06-evaluation-and-observability.md)

### [03 · AI-Assisted Development](03-ai-assisted-development/README.md)

Practical notes on AI coding tools, scoped to **Claude Code** (main focus), **OpenCode**, and **GitHub Copilot CLI**. Guidance for each tool is kept separate, since commands and configuration don't carry over between them.

1. [Context](03-ai-assisted-development/01-context.md)
2. [Commands](03-ai-assisted-development/02-commands.md)
3. [Models & Effort](03-ai-assisted-development/03-models-and-effort.md)
4. [Tools & Permissions](03-ai-assisted-development/04-tools-and-permissions.md)
5. [Skills & Commands](03-ai-assisted-development/05-skills.md)
6. [Hooks](03-ai-assisted-development/06-hooks.md)
7. [MCP](03-ai-assisted-development/07-mcp.md)
8. [Agents](03-ai-assisted-development/08-agents.md)
9. [Workflows](03-ai-assisted-development/09-workflows.md)

### [04 · Spec-Driven Development](04-spec-driven-development/README.md)

Write and refine specifications first, then let them drive design, implementation, and tests. Covers the EARS requirements syntax, a typical SDD workflow, and SDD frameworks.

1. [SDD Fundamentals](04-spec-driven-development/01-sdd-fundamentals.md)
2. [EARS (Easy Approach to Requirements Syntax)](04-spec-driven-development/02-ears.md)
3. [OpenSpec](04-spec-driven-development/03-openspec.md)

### [05 · LLM Security](05-llm-security/README.md)

The main security risks in applications built on LLMs, from the OWASP Top 10 for LLM Applications, and how to avoid or reduce each one.

1. [Prompt Injection](05-llm-security/01-prompt-injection.md)
2. [Sensitive Information Disclosure](05-llm-security/02-sensitive-information-disclosure.md)
3. [Supply Chain](05-llm-security/03-supply-chain.md)
4. [Data and Model Poisoning](05-llm-security/04-data-and-model-poisoning.md)
5. [Improper Output Handling](05-llm-security/05-improper-output-handling.md)
6. [System Prompt Leakage](05-llm-security/06-system-prompt-leakage.md)
7. [Vector and Embedding Weaknesses](05-llm-security/07-vectors-and-embeddings.md)
8. [Misinformation](05-llm-security/08-misinformation.md)
9. [Unbounded Consumption](05-llm-security/09-unbounded-consumption.md)

## 🛠 Topics Covered

- AI Fundamentals
- Prompt Engineering
- Context Engineering
- GitHub Copilot CLI
- Claude Code
- OpenCode
- Agentic Workflows
- Spec-Driven Development
- AI-Assisted Coding
- Agent Security, Evaluation & Observability
- LLM Security (OWASP Top 10 for LLM Applications)
- Productivity & Developer Experience

## 📂 Repository Structure

```text
.
├── 01-ai-foundations/            ✅ LLMs, prompts, embeddings, RAG, tools, context, glossary
├── 02-agentic-engineering/       ✅ Agents, harnesses, multi-agent, memory, security, evals
├── 03-ai-assisted-development/   ✅ Claude Code, OpenCode, GitHub Copilot CLI
├── 04-spec-driven-development/   ✅ SDD, EARS, OpenSpec
├── 06-projects/                  🔜 Real projects built with AI
├── 08-experiments/               🔜 Small experiments and comparisons
├── 07-resources/                 🚧 Reusable prompts; links, courses, and references to come
└── 05-llm-security/              ✅ Prompt injection, data leaks, supply chain, poisoning, misinformation
```

✅ = available · 🚧 = in progress · 🔜 = planned

## ✍️ Conventions

These notes follow a few simple rules so they stay easy to navigate:

- Each chapter is a numbered folder (`NN-kebab-name/`) with a `README.md` that introduces it and ends with a **Topics in this Chapter** list.
- Topic files are numbered (`NN-topic.md`) in reading order and match that list.
- Supporting pages outside the sequence (like the glossary) are unnumbered and listed under "Others".
- Diagrams are plain-text flows in `text` code blocks; example specs and prompts use `markdown` code blocks.

## 🔍 Linting (optional)

The notes can be checked locally with ESLint and [`@eslint/markdown`](https://github.com/eslint/markdown). The config is not committed, so set it up yourself if you want it:

```sh
npx eslint "**/*.md"                      # lint all Markdown
npx eslint 01-ai-foundations/04-rag.md    # lint a single file
```
