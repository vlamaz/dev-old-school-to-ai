# AI Foundations

## What is AI?

Artificial Intelligence (AI) is the field of computer science focused on creating systems that can perform tasks that normally require human intelligence.

These tasks include:

- Understanding language
- Learning from data
- Recognizing patterns
- Solving problems
- Making decisions
- Generating content such as text, images, code, audio, and video

In simple terms:

> AI is technology that enables computers to simulate aspects of human intelligence.

**Example**

Traditional software follows explicit instructions:

```text
IF temperature > 30
THEN turn on cooling
```

AI works differently. Instead of being programmed with every rule, it learns patterns from data:

```text
Input: Thousands of weather observations
Output: A model that can predict future temperatures
```

### Types of AI

**1. Narrow AI (Today's AI)**

Designed for a specific task.

Examples:

- ChatGPT
- GitHub Copilot
- Google Translate
- Netflix recommendations
- Spam filters

**2. General AI (Future Goal)**

An AI capable of performing any intellectual task that a human can do.

A true General AI does not yet exist.

### How Modern AI Works

Modern AI is largely based on:

- Machine Learning (ML)
- Deep Learning
- Neural Networks
- Large Language Models (LLMs)

Models such as GPT, Claude, Gemini, and Llama are trained on massive amounts of data to learn patterns in language and knowledge. Products such as ChatGPT and GitHub Copilot are built on top of these models.

When you ask:

```text
Create a React component
```

the model generates the answer one token (a small piece of text) at a time, each time choosing a likely next token based on your request and everything it learned during training.

### AI for Developers

For developers, AI acts as a:

- Coding assistant
- Documentation writer
- Code reviewer
- Research assistant
- Test generator
- Architecture brainstorming partner

Instead of writing every line manually, developers increasingly focus on:

- Defining requirements
- Creating specifications
- Reviewing AI-generated solutions
- Making architectural decisions
- Ensuring quality and security

Day-to-day practices (coding, review, debugging and documentation with AI) are covered in [AI-Assisted Workflows](../03-ai-assisted-development/09-workflows.md).

#### Evolution

```text
Developer 1.0
  ↓
Writes all code manually

Developer 2.0
  ↓
Uses frameworks and libraries

Developer 3.0
  ↓
Uses AI assistants to accelerate development

AI-Powered Developer
  ↓
Designs, specifies, orchestrates, and validates software with AI
```

## How to Read This Chapter

The topics build on each other:

1. **LLMs**: what a model is, tokens, the context window, and its limits (hallucinations).
2. **Prompt Engineering**: how to instruct a model well.
3. **Embeddings**: how meaning is turned into vectors for semantic search.
4. **RAG**: how to give a model external knowledge, using embeddings or search.
5. **Tools**: how a model takes actions, and how tool calling really works.
6. **Context Engineering**: how to manage everything that goes into the context window, pulling together all the previous topics.

After this chapter, [Agentic Engineering](../02-agentic-engineering/README.md) shows how models, tools and context combine into agents.

## Topics in this Chapter

1. [LLMs](01-LLMs.md)
2. [Prompt Engineering](02-prompt-engineering.md)
3. [Embeddings](03-embeddings.md)
4. [RAG](04-rag.md)
5. [Tools](05-tools.md)
6. [Context Engineering](06-context-engineering.md)

Others:

- [Glossary](glossary.md)
