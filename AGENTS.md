# AGENTS.md

This file provides guidance to AI coding agents (Claude Code, OpenCode, GitHub Copilot CLI) when working with code in this repository.

## What this repo is

A personal learning/notes repository documenting a move from traditional software development to AI-assisted engineering. It is Markdown only: no application code, build, tests, or CI.

## Linting

A local ESLint setup (`@eslint/markdown`, `markdown/commonmark` language) exists, but `package.json`, `package-lock.json`, and `eslint.config.mjs` are gitignored, so it is not part of the repo and may be missing on other machines.

```sh
npx eslint .                              # lint all Markdown
npx eslint 01-ai-foundations/04-rag.md    # lint a single file
```

## Structure and conventions

- Content chapters are numbered folders (`NN-kebab-name/`), meant to be read in order: `01` foundations → `02` agentic engineering → `03` AI-assisted development tools → `04` spec-driven development.
- `05-projects/`, `06-experiments/`, and `07-resources/` are still marked 🔜 planned in the root README. They have no chapter README yet. `07-resources/` holds reusable material in numbered subfolders (e.g. `01-prompts/`) instead of topic notes.
- Each chapter has a `README.md` with an intro and a closing `## Topics in this Chapter` section: a numbered list linking to the chapter's topic files. Topic files are named `NN-topic.md` and their order matches that list.
- The topic lists are duplicated in the root `README.md` under `## 📚 Contents`, and the folder status (✅/🔜) appears again under `## 📂 Repository Structure`. When adding, renaming, or renumbering a topic file, update the chapter README **and** the root README. They have drifted before.
- File numbers in a chapter can have gaps (e.g. `03-ai-assisted-development/` has no `05-*.md`). The list position, not the filename, sets reading order. Don't renumber files unless asked, because that breaks inbound links.
- Supporting pages outside the numbered sequence (e.g. `01-ai-foundations/glossary.md`) are unnumbered and linked under an "Others:" list in the chapter README.
- The glossary is alphabetical, one bold term per bullet. Entries end with `See [Topic](relative-link.md).` cross-references, including into other chapters (`../02-agentic-engineering/...`). Keep these links valid when moving or renaming files.
- Notes use plain English prose, `text` code blocks for ASCII flow diagrams (`↓` arrows, `├──` trees), and fenced `markdown` blocks for example specs/prompts.
- `03-ai-assisted-development/` is scoped to Claude Code, OpenCode, and GitHub Copilot CLI only, with Claude Code as the priority. Keep each tool's guidance clearly separated and don't assume commands or config carry over between tools.

## Editing

- `README.md` uses emoji and box-drawing characters. Preserve UTF-8 encoding when editing (PowerShell defaults can mangle it), so prefer the Edit/Write tools over shell redirection.
