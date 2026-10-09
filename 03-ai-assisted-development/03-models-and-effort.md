# Models & Effort

A model is the underlying AI engine (the specific set of trained weights) that reads your project, decides which tools to call, and writes or debugs code. The harness is the same whichever model you pick; the model sets the intelligence ceiling, speed, and cost. See [LLMs](../01-ai-foundations/01-LLMs.md).

Comparison of models (intelligence, speed, price): <https://artificialanalysis.ai/models>

## Effort

Effort controls how much reasoning, time, and thoroughness a model applies before answering. If the model determines what the AI knows (its intelligence ceiling), effort determines how hard it tries (its thinking budget). More effort means more tokens: slower and more expensive, but better on hard problems.

**Common effort levels**

| Level        | Best for                                                                                  |
| ------------ | ----------------------------------------------------------------------------------------- |
| Low          | Simple questions, quick lookups, high-volume tasks where speed and cost matter most       |
| Medium       | Routine coding, standard bug fixes, general workflows                                     |
| High / xhigh | Complex reasoning, difficult debugging, multi-file changes                                |
| Max          | Intricate architecture, deep security analysis, the hardest problems                      |

Not every model supports every level. Each tool maps these names to what the model and provider offer.

Practical rule: start with the default, raise effort when the agent goes in circles or misses something subtle, and lower it for mechanical work (renames, formatting, boilerplate). Switching to a bigger model and raising effort are separate levers; try effort first, because it's cheaper.

## Claude Code

**Models.** Use aliases rather than pinned IDs, so you get the latest version automatically:

| Alias                    | Use                                                              |
| ------------------------ | ---------------------------------------------------------------- |
| `opus`                   | Complex reasoning. Default on paid plans and the API             |
| `sonnet`                 | Daily coding                                                     |
| `haiku`                  | Fast, simple tasks                                               |
| `fable`                  | Hardest, longest-running tasks (requires Fable access)           |
| `opusplan`               | Opus in plan mode, then Sonnet for execution                     |
| `opus[1m]`, `sonnet[1m]` | 1 million token context window for long sessions                 |
| `default`                | Clear your override and go back to the account default           |

On the Anthropic API today, `opus`, `sonnet`, and `haiku` resolve to Opus 5.5, Sonnet 5.5, and Haiku 5.5, and `fable` to Fable 5.1. Other providers (Bedrock, Google Cloud, Foundry) can resolve the aliases to older versions.

Set the model with `/model`, `claude --model <alias>`, the `model` setting, or `ANTHROPIC_MODEL`. Use `--fallback-model sonnet,haiku` for automatic fallback when the main model is overloaded.

**Effort.** Levels are `low`, `medium`, `high`, `xhigh`, `max`. The 5.5 models default to `medium`.

| Where                     | How                                                                         |
| ------------------------- | --------------------------------------------------------------------------- |
| In a session              | `/effort <level>`, or `/effort` for a slider. `/effort auto` clears your saved level |
| Model picker              | Left/right arrows in `/model`                                               |
| One session               | `claude --effort <level>`                                                   |
| Saved default             | `effortLevel` setting (`low` to `xhigh`; `max` is session-only)             |
| Environment               | `CLAUDE_CODE_EFFORT_LEVEL`                                                  |
| One skill or subagent     | `effort:` in its frontmatter                                                |
| One turn                  | Include `ultrathink` in the prompt                                          |

If you pick a level the model doesn't support, Claude Code uses the highest supported level below it.

**Advisor (experimental).** `/advisor <model>` (or `claude --advisor opus`) lets the main model consult a second, usually stronger model at key moments: before committing to an approach, when stuck on a recurring error, or before declaring the task done. It fits long tasks where most turns are routine but the plan decides the outcome. Not available on Bedrock, Google Cloud, or Foundry.

## OpenCode

**Models.** OpenCode works with many providers. Models are named `provider/model-id`, for example `anthropic/claude-sonnet-5-5`. Add providers with `/connect`, list models with `opencode models`, and switch with `/models` or `opencode -m <provider/model>`. Set the default in `opencode.json`:

```json
{
  "$schema": "https://opencode.ai/config.json",
  "model": "anthropic/claude-sonnet-5-5"
}
```

Check the exact ID with `opencode models`; it depends on the provider.

**Effort.** OpenCode has no `/effort` command. Reasoning effort is a provider-specific **variant** of the model:

- In the TUI: `Ctrl+T` cycles the variants of the current model.
- In scripts: `opencode run --variant <variant> "<prompt>"`.

## GitHub Copilot CLI

**Models.** The model list comes from your Copilot plan and includes models from several vendors. Pick with `/model` (or `/models`), or `copilot --model=<model>`. `auto` lets Copilot choose. `/model --global` saves the default; `/model --repo` pins it for the repository.

**Effort.** Pick the reasoning effort for the selected model in the `/model` picker, or start with `copilot --effort=<level>` (alias `--reasoning-effort`). Levels: `low`, `medium`, `high`, `xhigh`, `max`. Custom agents can set `reasoningEffort` in their frontmatter.
