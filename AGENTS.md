# AGENTS.md

This file provides guidance to AI coding agents (Claude Code, OpenCode, GitHub Copilot CLI) when working with code in this repository.

## What this repo is

A personal learning/notes repository documenting a move from traditional software development to AI-assisted engineering. It is Markdown only: no application code, build, tests, or CI.

## Linting

A local ESLint setup (`@eslint/markdown`, `markdown/commonmark` language) exists, but `package.json`, `package-lock.json`, and `eslint.config.mjs` are gitignored, so it is not part of the repo and may be missing on other machines.

```sh
npx eslint "**/*.md"                      # lint all Markdown (plain `.` also lints package-lock.json, which fails)
npx eslint 01-ai-foundations/04-rag.md    # lint a single file
```

## Structure and conventions

- Content chapters are numbered folders (`NN-kebab-name/`), meant to be read in order: `01` foundations → `02` agentic engineering → `03` AI-assisted development tools → `04` spec-driven development.
- `05-llm-security/` is a content chapter that can be read after `02`. It took the next free number, after the placeholder folders `05`–`07`, so their numbers and existing links stay unchanged.
- `06-projects/` and `08-experiments/` are planned (🔜) and empty. `07-resources/` is in progress (🚧) and holds reusable material in numbered subfolders (e.g. `01-prompts/`) instead of topic notes. None of them has a chapter README yet.
- Each chapter has a `README.md` with an intro and a closing `## Topics in this Chapter` section: a numbered list linking to the chapter's topic files. Topic files are named `NN-topic.md`, numbered without gaps, and their order matches that list.
- The topic lists are duplicated in the root `README.md` under `## 📚 Contents`, and the folder status (✅/🚧/🔜) appears again under `## 📂 Repository Structure`. When adding, renaming, or renumbering a topic file, update the chapter README **and** the root README. They have drifted before.
- Don't renumber files unless asked, because that breaks inbound links (from other chapters and the glossary).
- Each concept has one home note; other notes link to it instead of re-explaining. Concepts live in `01`/`02` (e.g. the agent loop in `02-agentic-engineering/01-agents.md`, the context window in `01-ai-foundations/01-LLMs.md`), and tool-specific setup lives in `03`.
- Terminology: an agent is model + harness; Claude Code, OpenCode, and Copilot CLI are harnesses. "Memory" means information persisted across sessions, never the context window.
- Supporting pages outside the numbered sequence (e.g. `01-ai-foundations/glossary.md`) are unnumbered and linked under an "Others:" list in the chapter README.
- The glossary is alphabetical, one bold term per bullet. Entries end with `See [Topic](relative-link.md).` cross-references, including into other chapters (`../02-agentic-engineering/...`). Keep these links valid when moving or renaming files.
- Notes use plain English prose, `text` code blocks for ASCII flow diagrams (`↓` arrows, `├──` trees), and fenced `markdown` blocks for example specs/prompts.
- `03-ai-assisted-development/` is scoped to Claude Code, OpenCode, and GitHub Copilot CLI only, with Claude Code as the priority. Each note has separate per-tool sections, Claude Code first. Don't assume commands or config carry over between tools.
- Tool commands, flags, config formats, and model names change fast. Verify them against official docs before writing, and avoid pinning version numbers that will go stale.

## Editing

- `README.md` uses emoji and box-drawing characters. Preserve UTF-8 encoding when editing (PowerShell defaults can mangle it), so prefer the Edit/Write tools over shell redirection.
