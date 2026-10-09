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
  ↓  how LLMs work, prompts, context, RAG, embeddings, tools
02 Agentic Engineering
  ↓  harnesses and agents: AI that plans and acts, not just answers
03 AI-Assisted Development
  ↓  hands-on with Claude Code, OpenCode, and GitHub Copilot CLI
04 Spec-Driven Development
     specifications as the source of truth for AI-generated code
```

New to the vocabulary? Keep the [Glossary](01-ai-foundations/glossary.md) open while reading. Every term links back to the note that explains it.

## 📚 Contents

### [01 · AI Foundations](01-ai-foundations/README.md)

What AI is, how modern models work, and the core building blocks behind every AI tool.

1. [LLMs](01-ai-foundations/01-LLMs.md)
2. [Prompt Engineering](01-ai-foundations/02-prompt-engineering.md)
3. [Context Engineering](01-ai-foundations/03-context-engineering.md)
4. [RAG](01-ai-foundations/04-rag.md)
5. [Embeddings](01-ai-foundations/05-embeddings.md)
6. [AI Workflows](01-ai-foundations/06-ai-workflows.md)
7. [Tools](01-ai-foundations/07-tools.md)

Also: [Glossary](01-ai-foundations/glossary.md)

### [02 · Agentic Engineering](02-agentic-engineering/README.md)

Humans set goals and validate work; AI agents plan, write, test, and iterate.

1. [Harness](02-agentic-engineering/01-harness.md)
2. [Agents](02-agentic-engineering/02-agents.md)

### [03 · AI-Assisted Development](03-ai-assisted-development/README.md)

Practical notes on AI coding tools, scoped to **Claude Code** (main focus), **OpenCode**, and **GitHub Copilot CLI**. Guidance for each tool is kept separate, since commands and configuration don't carry over between them.

1. [Commands](03-ai-assisted-development/01-commands.md)
2. [Models & Effort](03-ai-assisted-development/02-models-and-effort.md)
3. [Harness: Context](03-ai-assisted-development/03-context.md)
4. [Harness: Skills, Hooks & MCPs](03-ai-assisted-development/04-skills-hooks-mcps.md)
5. [Harness: Tools](03-ai-assisted-development/06-tools.md)
6. [Agents](03-ai-assisted-development/07-agents.md)

### [04 · Spec-Driven Development](04-spec-driven-development/README.md)

Write and refine specifications first, then let them drive design, implementation, and tests. Covers the EARS requirements syntax, a typical SDD workflow, and SDD frameworks.

1. [OpenSpec](04-spec-driven-development/01-openspec.md)

## 🛠 Topics Covered

- AI Fundamentals
- Prompt Engineering
- Context Engineering
- GitHub Copilot
- Claude Code
- OpenCode
- Agentic Workflows
- Spec Driven Development
- AI-Assisted Coding
- Productivity & Developer Experience

## 📂 Repository Structure

```text
.
├── 01-ai-foundations/            ✅ AI basics, LLMs, prompts, context, RAG, glossary
├── 02-agentic-engineering/       ✅ Harnesses and agents
├── 03-ai-assisted-development/   ✅ Claude Code, OpenCode, GitHub Copilot CLI
├── 04-spec-driven-development/   ✅ SDD, EARS, OpenSpec
├── 05-projects/                  🔜 Real projects built with AI
├── 06-experiments/               🔜 Small experiments and comparisons
└── 07-resources/                 🔜 Curated links, courses, and references
```

✅ = available · 🔜 = planned

## ✍️ Conventions

These notes follow a few simple rules so they stay easy to navigate:

- Each chapter is a numbered folder (`NN-kebab-name/`) with a `README.md` that introduces it and ends with a **Topics in this Chapter** list.
- Topic files are numbered (`NN-topic.md`) in reading order and match that list.
- Supporting pages outside the sequence (like the glossary) are unnumbered and listed under "Others".
- Diagrams are plain-text flows in `text` code blocks; example specs and prompts use `markdown` code blocks.

## 🔍 Linting (optional)

The notes can be checked locally with ESLint and [`@eslint/markdown`](https://github.com/eslint/markdown). The config is not committed, so set it up yourself if you want it:

```sh
npx eslint .                              # lint all Markdown
npx eslint 01-ai-foundations/04-rag.md    # lint a single file
```
