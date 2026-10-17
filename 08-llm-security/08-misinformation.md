# Misinformation

Misinformation (LLM09) is when an LLM produces false or misleading content that people then trust and act on. The model is not trying to deceive anyone. It generates likely text, and likely is not the same as true. See [Hallucinations](../01-ai-foundations/01-LLMs.md#hallucinations) for why this happens.

The security angle is that harm happens when someone relies on the output without checking it.

## Forms It Takes

- **Invented facts**: wrong dates, numbers, quotes or legal rules, stated with confidence.
- **Fabricated sources**: citations, URLs and case law that do not exist. In 2023, a US court sanctioned lawyers who filed a brief citing cases that ChatGPT had invented.
- **Plausible wrong code**: functions or settings that don't exist, insecure patterns, and tests that check the wrong thing.
- **Invented packages**: dependencies that the model made up. See [Supply Chain](03-supply-chain.md).
- **Outdated answers**: information from after the model's knowledge cutoff, or deprecated APIs it learned from older code.
- **Overreliance**: people accept fluent answers without checking them. The failure is partly human.

## Example

A developer asks an assistant how to configure the security options of a library. The answer confidently lists a setting that does not exist. The developer adds it, the build passes, and the protection they believed they had is not there.

## How to Avoid It

- **Ground answers in sources.** Provide the documents, use [RAG](../01-ai-foundations/04-rag.md), and require citations. Check that the citations resolve and say what the model claims.
- **Allow "I don't know".** Tell the model it may say when the answer is not in the context.
- **Verify with tools.** Compilers, type checkers, tests, linters and the official documentation catch much of the invented code and configuration.
- **Match the review to the risk.** Low-stakes text can be checked lightly. Legal, medical, financial, security and production decisions need a qualified person to verify them.
- **Keep knowledge current.** Give the model access to up-to-date documentation through search or tools instead of relying on training data alone.
- **Measure accuracy.** Keep questions with known answers, and track results over time. See [Evaluation and Observability](../02-agentic-engineering/06-evaluation-and-observability.md).
- **Design the interface for doubt.** Show sources, mark uncertain answers, and don't present generated text as authoritative.

## Related Notes

- [Hallucinations](../01-ai-foundations/01-LLMs.md#hallucinations), the root cause
- [Human in the Loop](../02-agentic-engineering/05-security.md#human-in-the-loop), for where a person must approve
