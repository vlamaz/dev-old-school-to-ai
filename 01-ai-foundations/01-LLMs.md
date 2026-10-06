# LLM (Large Language Model)

An LLM is an AI model trained on massive amounts of text that can understand and generate human language.

Examples:

- ChatGPT
- Claude
- Gemini
- Llama
- DeepSeek

Think of an LLM as a very advanced autocomplete system that has learned patterns from books, articles, websites, code, and other text.

One-Liner summary: **LLM is the AI brain**

## Reasoning models

Reasoning language models (RLMs) or large reasoning models (LRMs) are LLMs that are trained to solve tasks that require several steps of reasoning.

They tend to do better on logic, math, and programming tasks than standard LLMs, can revisit and revise earlier steps, make use of extra computations, and enhance performance when increasing the number of parameters, training examples, and training computations.

Popular Reasoning Models:

- OpenAI o-series & GPT-5 series: Includes models like o1, o3, o4-mini, and advanced GPT-5 variants, which use explicit internal thinking tokens and reinforcement learning to handle multi-step logic, math, and coding.
- DeepSeek-R1: A prominent open-weight reasoning model that popularized highly efficient intermediate reasoning traces and competitive performance at a fraction of training costs.
- Anthropic Claude (3.7 Sonnet / 3.5 variants): Features explicit "thinking" capabilities and toggles to extend test-time compute for deeper analysis.
- Google Gemini (2.5 Pro / Think Mode): Incorporates advanced reasoning modes built to break down complex queries and run verification steps

## Agentic systems

Agentic systems are artificial intelligence setups that can act on their own to reach a goal with very little human help.

Unlike regular chatbots that only reply when you type a prompt, agentic systems use large language models (LLMs) as a "brain" to plan, use tools, and finish complex tasks step by step.

Core Parts of Agentic Systems:

- Reasoning Core: Uses an AI model to understand the goal and decide what to do next.
- Planning: Breaks big jobs into smaller, manageable tasks.
- Memory: Remembers past steps and learns from previous results to fix mistakes.
- Tools: Connects to external software, web searches, or databases to take real action.

In software development, the shift from standard "copilots" (which just autocomplete code) to agentic software development involves autonomous systems that can read entire codebases, write multi-file features, run tests, and fix bugs natively.

The industry is moving toward Agentic Engineering—where specialized multi-agent systems act as active teammates while developers provide high-level design and guardrails.

---

## Key Concepts

### Training

The process of teaching an AI model using large amounts of data so it can identify patterns and make predictions.

Large Language Models (LLMs) are AI models trained on massive amounts of text to understand and generate human language.

### Pre-training

The initial training phase where the model learns language, knowledge, reasoning patterns, and relationships between words from massive datasets.

### Fine-tuning

A later training phase where a pre-trained model is specialized for specific tasks, domains, or behaviors.

Fine-tuning is the process of taking a pre-trained LLM and training it further on a specific dataset to make it better at a particular task or domain.

Specializes a model for a specific domain or task.

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

Temperature controls how creative or predictable an LLM's responses are.

_Lower_ temperatures produce more consistent and deterministic outputs.

Low Temperature (0.0 - 0.3)

Good for:

- Coding
- Data extraction
- Documentation
- Technical explanations

_Higher_ temperatures produce more creative and varied outputs.

### Hallucinations

Hallucinations occur when an LLM generates information that sounds convincing but is incorrect, fabricated, or unsupported.

The model is designed to predict the most likely next tokens, not to verify facts.

As a result, it may:

- Invent facts
- Create fake references
- Generate incorrect code
- Misstate dates or numbers
- Make unsupported assumptions

How to Reduce Hallucinations?

1. Use RAG: Provide external, trusted information.
2. Give More Context.
3. Ask for Sources.
4. Verify Critical Information. Always double-check:
   - Legal information
   - Medical information
   - Financial information
   - Security-related guidance
   - Production code

### Context Window

The context window is the amount of information an LLM can "remember" and consider during a conversation or task.

Examples:

- Your current prompt
- Previous messages
- Attached documents
- Instructions

Think of it as the AI's working memory.

A larger context window allows the model to handle bigger documents and maintain longer conversations.

One-Liner summary: **Context Window is the AI's working memory**

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

LLMs read and generate tokens, not raw text.

One-Liner summary: **Tokenization is How the AI reads text**

## RAG (Retrieval-Augmented Generation)

RAG is a technique that allows an AI model to retrieve external information before generating a response.

Instead of relying only on its training data:

```text
Question
↓
Search relevant documents
↓
Provide documents to the LLM
↓
Generate answer
```

Examples:

- Company knowledge bases
- Product documentation
- PDFs
- SharePoint
- Websites

RAG helps AI provide more accurate, up-to-date, and domain-specific answers.

One-Liner summary: **RAG is How the AI looks up external knowledge before answering**
