# Models

A model is the underlying AI engine (the specific set of trained weights) that processes your project, reads files, and decides how to write or debug code.

**AI Tools settings**

_Claude Code_

Run command:

```text
/model
```

_OpenCode_

Run command:

```text
/models
```

_GitHub Copilot_

Run command:

```text
/model
```

## Effort

Model effort is a setting that controls how much internal reasoning, time, and thoroughness an AI model applies before answering a request.
If the model determines what the AI knows (its intelligence ceiling), the effort level determines how hard it tries (its thinking budget).

**Common Effort Levels**

- Low: Best for simple questions, quick lookups, or high-volume tasks where speed and low cost matter most.
- Medium: A balanced default for routine coding, standard bug fixes, and general workflows.
- High / Extra High (xhigh): Designed for complex reasoning, difficult debugging, multi-file changes, and nuanced problems.
- Max: Absolute maximum reasoning capacity reserved for intricate architecture, deep security analysis, or the hardest logical constraints.

**AI Tools settings**

_Claude Code_

Run command:

```text
/effort
```

_OpenCode_

Run command:

```text
/effort
```

_GitHub Copilot_

To adjust the reasoning level in GitHub Copilot Chat, follow these steps:

1. Open the Copilot Chat window in your editor (e.g., VS Code or Visual Studio).
2. Click the model dropdown menu (typically located at the top or bottom of the chat interface).
3. Select a model that supports advanced reasoning (such as o1 or o3-mini).
4. Locate the "Thinking Effort" slider or dropdown that appears next to the model selection.
5. Choose your desired level (e.g., Low, Medium, or High) based on the complexity of your task.
