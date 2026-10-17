# Sensitive Information Disclosure

Sensitive information disclosure (LLM02) happens when an LLM application reveals data it should not: personal data, credentials, proprietary code, or another customer's information. The leak can come from the model's output, from the context it was given, from the training data, or from the systems around it, such as logs.

## Where the Data Can Leak

```text
Where the data comes from           How it leaks
─────────────────────────           ────────────
Prompt or context (files, rows)     Repeated in an answer to the wrong user
RAG index                           Retrieved for someone not allowed to see it
Tool results                        Included in an answer or sent to an external API
Training or fine-tuning data        Memorized and reproduced (rare, but documented)
Logs, transcripts and memory files  Read later by people who should not have access
Model provider                      Retained or used for training, depending on settings
```

## Example

An internal support bot indexes every company document in one vector store. A customer asks about salary bands, and the retriever returns an HR document that the model then summarizes. The bot never checked whether this customer was allowed to read it.

A coding agent is another example. It reads `.env` to understand the project, then prints the database password in its summary, which ends up in a transcript.

## How to Avoid It

- **Send less.** Include only the fields and files the task needs. Don't put whole databases or entire config folders into the context.
- **Redact before sending.** Mask emails, phone numbers, identifiers and secrets with a deterministic filter before the text reaches the model.
- **Enforce access control outside the model.** Filter retrieval by the user's permissions at query time. Never rely on the model to refuse. See [RAG: Metadata Filtering and Access Control](../01-ai-foundations/04-rag.md#metadata-filtering-and-access-control).
- **Keep secrets out of prompts and readable files.** Use environment variables or a secrets manager, and deny the agent access to secret files. See [Secrets](../02-agentic-engineering/05-security.md#secrets).
- **Scan outputs.** Run secret and PII scanners on responses and logs, the same as on commits.
- **Know your provider's settings.** Check what is retained, for how long, and whether your data is used for training. Pick plans and settings that match how sensitive the data is.
- **Control transcripts and logs.** They often contain everything the model saw. Limit who can read them and how long they are kept.
- **Be careful with training.** Fine-tuning can memorize its examples. Keep sensitive records out of training sets unless you have a clear reason and controls in place.

## Related Notes

- [Secrets](../02-agentic-engineering/05-security.md#secrets) for keeping credentials away from the agent
- [Memory](../02-agentic-engineering/04-memory.md), since memory files persist what the agent has learned
