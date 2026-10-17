# LLM Security

Securing an application built on LLMs is different from securing ordinary software. The model receives instructions and data as one stream of text, it can be steered by content it reads, its output is often trusted by other systems, and every request costs money. Traditional controls still apply, but they have to cover new places where things can go wrong.

This chapter is based on the [OWASP Top 10 for LLM Applications (2025)](https://owasp.org/www-project-top-10-for-large-language-model-applications/), the most widely used list of LLM application risks. It covers nine of the ten. The tenth, **Excessive Agency** (LLM06), is about agents that do more than they should. It is covered in substance by [Security and Safety](../02-agentic-engineering/05-security.md) in Chapter 02, under least privilege and guardrails.

## Risks at a Glance

| Risk | Core idea | Main control |
| :--- | :-------- | :----------- |
| LLM01 Prompt injection | Instructions hidden in content hijack the model | Limit what the model can do; treat content as untrusted |
| LLM02 Sensitive information disclosure | Private data leaks through outputs, logs or retrieval | Send less data; enforce access control outside the model |
| LLM03 Supply chain | Models, data, packages and extensions can be malicious or wrong | Vet, pin and inventory every dependency |
| LLM04 Data and model poisoning | Corrupted training or retrieval data changes behavior | Control and validate data sources; test for backdoors |
| LLM05 Improper output handling | Model output used unchecked as HTML, SQL or shell commands | Treat output as untrusted input; encode and validate it |
| LLM07 System prompt leakage | Users extract the system prompt | Keep secrets and security logic out of the prompt |
| LLM08 Vector and embedding weaknesses | Retrieval ignores permissions or returns poisoned content | Filter by permissions on the server; treat vectors as sensitive |
| LLM09 Misinformation | Confident but false output is trusted and acted on | Ground answers in sources; verify in proportion to the risk |
| LLM10 Unbounded consumption | Unlimited tokens, requests or loops | Budgets, rate limits, turn limits and spending alerts |

## Principles That Cover Most Risks

- **Untrusted in, untrusted out.** Treat everything the model reads and everything it writes as untrusted, unless you control the source.
- **Enforce outside the model.** The model can be talked into almost anything. Permissions, limits and validation belong in code, not in the prompt.
- **Limit the blast radius.** Assume the model will eventually be fooled or wrong, and make sure the damage it can do is small.
- **Test, measure and monitor.** No single control holds. Keep tests for known attacks, track quality and cost, and log enough to investigate.

## Topics in this Chapter

1. [Prompt Injection](01-prompt-injection.md)
2. [Sensitive Information Disclosure](02-sensitive-information-disclosure.md)
3. [Supply Chain](03-supply-chain.md)
4. [Data and Model Poisoning](04-data-and-model-poisoning.md)
5. [Improper Output Handling](05-improper-output-handling.md)
6. [System Prompt Leakage](06-system-prompt-leakage.md)
7. [Vector and Embedding Weaknesses](07-vectors-and-embeddings.md)
8. [Misinformation](08-misinformation.md)
9. [Unbounded Consumption](09-unbounded-consumption.md)

Others:

- [Glossary](../01-ai-foundations/glossary.md)
