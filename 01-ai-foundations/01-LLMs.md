# LLM (Large Language Model)

An LLM is an AI model trained on massive amounts of text that can understand and generate human language. In other words, **LLM** is the **AI brain**.

Think of an LLM as a very advanced autocomplete system that has learned patterns from books, articles, websites, code, and other text.

Under the hood, almost all modern LLMs use the **Transformer** architecture. Its key mechanism, *attention*, lets every token look at every other token in the input to decide what matters for predicting the next one.

Examples of model families:

- GPT (OpenAI)
- Claude (Anthropic)
- Gemini (Google)
- Llama (Meta)
- DeepSeek

Products such as ChatGPT, Claude.ai or GitHub Copilot are applications built on top of these models. They are not models themselves.

**Open-weight vs closed models**

- **Closed models** (GPT, Claude, Gemini) are only available through the vendor's API or apps.
- **Open-weight models** (Llama, DeepSeek, Mistral, Qwen) publish their weights, so you can run them on your own hardware.

Most vendors also ship each generation in several sizes. Larger models are more capable; smaller ones are faster and cheaper. A common pattern is to use a large model for planning and hard problems, and a small one for simple, high-volume tasks.

Many current models are also **multimodal**: they accept images (and sometimes audio or PDFs) as input, not just text.

## Reasoning models

Reasoning models (also called large reasoning models, or "thinking" models) are LLMs trained, mostly with reinforcement learning, to work through a problem step by step before giving their final answer.

They tend to do better on logic, math, and programming tasks than standard LLMs. They can try an approach, check intermediate results, and revise earlier steps.

What sets them apart is **test-time compute**: their accuracy improves when they are allowed to think longer at inference time, not only when the model gets bigger or is trained on more data.

Most frontier model families now offer a thinking mode, for example:

- **OpenAI**: the o-series and GPT-5 reasoning models.
- **DeepSeek-R1**: an open-weight reasoning model that showed strong reasoning could be trained at a fraction of the usual cost.
- **Anthropic Claude**: Claude 3.7 Sonnet was the first Claude model with extended thinking. Current Claude models use *adaptive thinking*: the model decides whether and how much to think, and you steer the depth with an `effort` setting instead of a fixed token budget.
- **Google Gemini**: recent Gemini models include a thinking mode.

Thinking tokens are billed as output tokens and count toward the context window, so more thinking means more cost and latency. Model versions change every few months; use the comparison link at the end of this page for the current landscape.

## Agentic systems (teaser)

An LLM on its own only turns text into text. When you run it in a loop with tools (read files, run commands, call APIs), letting it decide its own next step toward a goal, you get an **agent**. Coding tools such as Claude Code are built this way.

Agents are the subject of the next chapter. See [Agents](../02-agentic-engineering/01-agents.md).

## Key Concepts

### Training

The process of teaching an AI model using large amounts of data so it can identify patterns and make predictions.

Training usually happens in stages:

```text
Pre-training
↓
Post-training (instruction tuning, RLHF)
↓
(Optional) Fine-tuning
```

### Pre-training

The initial training phase where the model learns language, knowledge, reasoning patterns, and relationships between words from massive datasets, by repeatedly predicting the next token.

The result is a *base model*: good at continuing text, but not yet good at following instructions.

Pre-training data stops at a certain date, the **knowledge cutoff**. The model knows nothing about events, libraries or APIs released after it unless you provide that information in the context.

### Post-training

The phase that turns a base model into a helpful assistant. The model is trained on examples of instructions and good answers (instruction tuning) and on human or AI preference feedback (RLHF and similar techniques).

This is why chat models follow instructions, refuse harmful requests, and answer in a conversational style.

### Fine-tuning

Fine-tuning is the process of taking a pre-trained LLM and training it further on a specific dataset to make it better at a particular task, domain, or behavior.

Example:

```text
Base Model
↓
Fine-tuned on medical documents
↓
Medical Assistant
```

Other examples:

- Legal document assistant
- Customer support chatbot
- Financial advisor
- Code generation model

For most application work, fine-tuning is a last resort. Prompting, better context and RAG are cheaper and easier to update. See [RAG vs Fine-Tuning](04-rag.md#rag-vs-fine-tuning).

### Inference

Inference is the process of using a trained model to generate predictions or responses.

Training teaches the model.

Inference is when the model actually performs work.

Example:

```text
User: Create a React login page

Model:
Generates React code
```

The generation of that code is inference.

The model generates its answer one token at a time. At each step it computes a probability for every possible next token and picks (samples) one, then repeats with that token added to the input.

The lifecycle looks like this:

```text
Training
↓
Model Created
↓
Inference
↓
User Gets Response
```

### Temperature

Temperature is a sampling parameter that controls how random the choice of the next token is.

- **Lower temperatures** make the model pick the most likely tokens, producing more consistent and predictable outputs. Even at `0`, output is not guaranteed to be identical between runs.
- **Higher temperatures** produce more varied and creative outputs.

In practice, this knob is disappearing for reasoning-era models:

- Current Claude models (Opus 4.7 and later, and the 5.x family) return an error for any non-default `temperature`, `top_p` or `top_k`. On older Claude models, temperature cannot be changed while thinking is on.
- Some other vendors' reasoning models also ignore or reject sampling parameters. Check the API docs of the model you use.

Today the main controls are the choice of model and the thinking/effort setting. Consistency comes from clear prompts, examples and structured outputs rather than from a low temperature.

### Hallucinations

Hallucinations occur when an LLM generates information that sounds convincing but is incorrect, fabricated, or unsupported.

The model is designed to predict the most likely next tokens, not to verify facts.

As a result, it may:

- Invent facts
- Create fake references
- Generate incorrect code
- Invent APIs, functions or package names that don't exist
- Misstate dates or numbers
- Make unsupported assumptions

**How to Reduce Hallucinations?**

1. **Ground the answer**: provide trusted information (documents, code, RAG) and ask the model to answer only from it, quoting the relevant parts.
2. **Allow "I don't know"**: tell the model it is fine to say it doesn't know or that the information isn't in the context.
3. **Give more context**: missing context is the most common cause of invented details.
4. **Verify with tools**: for code, let compilers, type checkers, linters and tests catch invented APIs. Check that suggested packages actually exist before installing them.
5. **Verify critical information.** Always double-check:
   - Legal information
   - Medical information
   - Financial information
   - Security-related guidance
   - Production code

## Tokenization

Tokenization is the process of breaking text into smaller pieces called tokens that an LLM can understand.

Example:

```text
Hello world!
```

might become:

```text
["Hello", " world", "!"]
```

A token is not always a word. It can be:

- A word
- Part of a word
- A punctuation mark
- A symbol

LLMs read and generate tokens, not raw text. **Tokenization** is how the AI **reads text**.

Tokens matter because they are the unit for everything practical:

- **Limits**: context windows and maximum output length are measured in tokens.
- **Cost**: APIs charge per token, with output tokens usually costing several times more than input tokens.
- **Speed**: more output tokens means a longer response time.

As a rough rule, one English token is about three quarters of a word. Code, non-English text and unusual formatting usually take more tokens. Each model family has its own tokenizer, so counts differ between vendors.

To count tokens for your specific text in Claude, use Anthropic's token counting API: <https://platform.claude.com/docs/en/build-with-claude/token-counting>

```js
import Anthropic from "@anthropic-ai/sdk";

const client = new Anthropic();

const response = await client.messages.countTokens({
  model: "claude-opus-5-5",
  system: "You are a scientist",
  messages: [
    {
      role: "user",
      content: "Hello, Claude",
    },
  ],
});

console.log(response);
```

## Context Window

The context window is the maximum number of tokens a model can take into account in a single request: everything it "sees" when generating a response. It is the model's input limit, not a memory: nothing in it persists after the request unless the application sends it again.

It includes:

- The system prompt and instructions
- Previous messages in the conversation
- Tool definitions and tool results
- Attached documents and files
- Thinking tokens and the response being generated

LLM APIs are stateless. In a chat or an agent session, the application re-sends the whole conversation on every turn, so the context grows with each message and tool call.

A larger context window allows the model to handle bigger documents and longer sessions.

However, a bigger window brings challenges:

- **Cost**: billing is per token, and every turn re-sends the whole context, so long sessions get expensive quickly. On the compute side, standard self-attention grows roughly quadratically with the number of tokens.
- **Quality (context rot)**: a model does not use all of its window equally well. As the context fills up, especially with irrelevant content, accuracy drops and details in the middle are more likely to be missed ("lost in the middle").
- **Latency**: more input tokens take longer to process.

A bigger window is not a reason to fill it. Sending only what is relevant is the job of [Context Engineering](06-context-engineering.md).

For persisting information between sessions, see [Memory](../02-agentic-engineering/04-memory.md).

## RAG (Retrieval-Augmented Generation)

RAG lets a model look up external knowledge (documentation, databases, code) at request time and answer from it, instead of relying only on its training data. See [RAG](04-rag.md).

## Links

- [Comparison of Models: Intelligence, Performance & Price Analysis](https://artificialanalysis.ai/models)
- [Anthropic - Building with extended thinking](https://platform.claude.com/docs/en/build-with-claude/thinking)
