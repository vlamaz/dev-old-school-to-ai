# Glossary

- **ADR**: Architecture Decision Record, a short document that records an important technical or design decision and the reasons behind it.

- **Agent**: An AI system that uses a model, tools, instructions, and often memory to work toward a goal. Unlike a basic chatbot, an agent can take actions such as searching files or calling APIs. See [Agents](../03-agentic-engineering/02-agents.md).

- **Context**: The information available to a model when it generates a response, such as the prompt, conversation history, documentation, source code, and tool outputs. See [Context Engineering](03-context-engineering.md).

- **Context engineering**: The practice of selecting and providing relevant information to a model so it can produce a useful response. See [Context Engineering](03-context-engineering.md).

- **Context window**: The amount of information a model can process at one time, including prompts, conversation history, and other provided context. See [LLMs](01-LLMs.md).

- **Embedding**: A numerical vector representation of data that captures meaning, allowing systems to compare and retrieve information by semantic similarity. See [Embeddings](05-embeddings.md).

- **Fine-tuning**: Further training a pre-trained model on data for a particular task, domain, or behavior. Unlike RAG, fine-tuning changes the model rather than retrieving information at answer time. See [LLMs](01-LLMs.md) and [RAG](04-rag.md).

- **Harness**: The software infrastructure around a model that gives an agent its tools, workflow, and validation mechanisms. See [Harness](../03-agentic-engineering/01-harness.md).

- **Inference**: The process of using a trained model to generate a prediction or response. See [LLMs](01-LLMs.md).

- **LLM**: Large Language Model, an AI model trained on large amounts of text to understand and generate language. See [LLMs](01-LLMs.md).

- **MCP**: Model Context Protocol, an open standard for connecting AI applications to external tools and systems.

- **OpenSpec**: An open-source framework for applying Spec-Driven Development to AI-assisted coding workflows. See [OpenSpec](../04-spec-driven-development/01-openspec.md).

- **PRD**: Product Requirements Document, a document describing a product's goals, users, requirements, and constraints. It may be created or refined with AI tools.

- **Prompt engineering**: The practice of writing clear, effective instructions for a model. See [Prompting](02-prompt-engineering.md).

- **RAG**: Retrieval-Augmented Generation, a technique that retrieves relevant information from external sources and gives it to a model as context before it generates a response. See [RAG](04-rag.md).

- **SDD**: Spec-Driven Development, a software development approach in which specifications guide implementation and provide testable criteria for completion. See [OpenSpec](../04-spec-driven-development/01-openspec.md).

- **Semantic search**: Search that finds information by meaning or similarity rather than requiring exact keyword matches. Embeddings are commonly used to support semantic search. See [Embeddings](05-embeddings.md).

- **Token**: A piece of text, such as a word or part of a word, into which text is divided for a language model to process. See [LLMs](01-LLMs.md).

- **Vector database**: A database optimized for storing and searching vector embeddings, often to find information semantically similar to a query. See [Embeddings](05-embeddings.md).

## Links

- AI Coding Dictionary: https://www.aicodingdictionary.com/
