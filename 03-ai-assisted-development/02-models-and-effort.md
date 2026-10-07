# Models

A model is the underlying AI engine (the specific set of trained weights) that processes your project, reads files, and decides how to write or debug code.

Comparison of Models: Intelligence, Performance & Price Analysis: https://artificialanalysis.ai/models

**AI Tools settings**

| Tool               | Command   |
| ------------------ | --------- |
| Claude Code        | `/model`  |
| OpenCode           | `/models` |
| GitHub Copilot CLI | `/model`  |

## Effort

Model effort is a setting that controls how much internal reasoning, time, and thoroughness an AI model applies before answering a request.
If the model determines what the AI knows (its intelligence ceiling), the effort level determines how hard it tries (its thinking budget).

**Common Effort Levels**

| Level                     | Best for                                                                                                |
| ------------------------- | ------------------------------------------------------------------------------------------------------- |
| Low                       | Simple questions, quick lookups, or high-volume tasks where speed and low cost matter most.             |
| Medium                    | A balanced default for routine coding, standard bug fixes, and general workflows.                       |
| High / Extra High (xhigh) | Complex reasoning, difficult debugging, multi-file changes, and nuanced problems.                       |
| Max                       | Intricate architecture, deep security analysis, or the hardest logical constraints (maximum reasoning). |

**AI Tools settings**

| Tool               | How to set effort                                                                                          |
| ------------------ | ---------------------------------------------------------------------------------------------------------- |
| Claude Code        | `/effort`                                                                                                  |
| OpenCode           | `Ctrl+T` cycles model variants (provider-specific reasoning effort), or `opencode run --variant <variant>` |
| GitHub Copilot CLI | `/model` (pick the reasoning effort for the selected model), or `copilot --effort=<level>`                 |
