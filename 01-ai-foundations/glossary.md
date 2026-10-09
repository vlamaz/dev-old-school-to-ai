# Glossary

- **ADR**: Architecture Decision Record, a short document that records one significant technical decision, its context, and its consequences. ADRs give agents durable "why" context. See [Context: ADRs](../03-ai-assisted-development/01-context.md#adrs).

- **Agent**: A model running in a loop with tools, deciding its own next step toward a goal. In practice an agent is a model plus a harness, plus configuration such as instructions, tools, and permissions. See [Agents](../02-agentic-engineering/01-agents.md).

- **Agent loop**: The cycle in which the harness calls the model, executes any tool calls it returns, appends the results, and calls the model again, stopping when the model returns no tool calls or a limit is hit. See [The Agent Loop](../02-agentic-engineering/01-agents.md#the-agent-loop).

- **Agentic engineering**: A development discipline in which humans set goals, design the process, and validate the work, while AI agents plan, implement, test, and iterate inside that process. See [Agentic Engineering](../02-agentic-engineering/README.md#from-vibe-coding-to-agentic-engineering).

- **Agentic search**: Retrieval in which the model itself decides what to look for, using search tools such as grep, glob, and file reads in a loop instead of a vector index. Claude Code works this way. See [RAG vs Agentic Search](04-rag.md#rag-vs-agentic-search).

- **AGENTS.md**: A cross-tool Markdown file of project instructions for coding agents. OpenCode and GitHub Copilot CLI read it natively; Claude Code reads `CLAUDE.md`, which can import it with `@AGENTS.md`. See [Context: AGENTS.md](../03-ai-assisted-development/01-context.md#agentsmd).

- **AI-assisted coding**: Using AI to suggest or write code while the developer reviews every change and stays responsible for design and validation. See [Agentic Engineering](../02-agentic-engineering/README.md#from-vibe-coding-to-agentic-engineering).

- **Chain of thought**: Prompting a model to reason step by step before giving its final answer. Reasoning models do this internally, so explicit CoT prompting matters less with them. See [Prompting Patterns](02-prompt-engineering.md#prompting-patterns).

- **Chunking**: Splitting documents into smaller passages before indexing them, so retrieval returns focused, relevant text. See [RAG: Chunking](04-rag.md#chunking).

- **CLAUDE.md**: Claude Code's project instruction file, loaded automatically at the start of every session. See [Context: Claude Code](../03-ai-assisted-development/01-context.md#claude-code).

- **Compaction**: Summarizing a conversation that is nearing the context window limit and continuing in a fresh context with that summary. See [Compaction](06-context-engineering.md#4-compaction).

- **Configured agent**: A named preset with its own instructions, model, and tool access (for example a read-only `code-reviewer`), usually run as a subagent. See [Configured Agents](../02-agentic-engineering/01-agents.md#configured-agents) and [Agents in each tool](../03-ai-assisted-development/08-agents.md).

- **Context**: Everything the model sees when it generates a response: system prompt, instructions, conversation history, files, tool definitions, and tool results. See [What Is Context?](06-context-engineering.md#what-is-context).

- **Context engineering**: The practice of curating the smallest set of high-signal information in a model's context window across a whole task, not just a single prompt. See [Context Engineering](06-context-engineering.md).

- **Context rot**: The drop in output quality as the context window fills up, especially with irrelevant content; details in the middle are the most likely to be missed. See [Context Window](01-LLMs.md#context-window).

- **Context window**: The maximum number of tokens a model can take into account in a single request, including the system prompt, history, tool definitions and results, thinking, and the response. It is an input limit, not memory. See [Context Window](01-LLMs.md#context-window).

- **Cosine similarity**: A measure of how similar two embeddings are, based on the angle between the vectors. It is the most common choice for text. See [Measuring Similarity](03-embeddings.md#measuring-similarity).

- **Delta spec**: In OpenSpec, a spec inside a change that describes only the requirements the change adds, modifies, or removes. It is merged into the main specs when the change is archived. See [OpenSpec](../04-spec-driven-development/03-openspec.md).

- **EARS**: Easy Approach to Requirements Syntax, a set of keyword templates (While, When, Where, If/then) for writing unambiguous, testable requirements. See [EARS](../04-spec-driven-development/02-ears.md).

- **Effort**: A setting that controls how much reasoning a model applies before answering. More effort means more tokens, latency, and cost, but better results on hard problems. See [Effort](../03-ai-assisted-development/03-models-and-effort.md#effort).

- **Embedding**: A numerical vector representation of data that captures meaning, so systems can compare and retrieve information by semantic similarity. See [Embeddings](03-embeddings.md).

- **Few-shot prompting**: Including a few input/output examples in a prompt to show the model the expected pattern or format. See [Prompting Patterns](02-prompt-engineering.md#prompting-patterns).

- **Fine-tuning**: Further training a pre-trained model on a specific dataset for a task, domain, or behavior. Unlike RAG, it changes the model instead of supplying information at answer time. See [Fine-tuning](01-LLMs.md#fine-tuning) and [RAG vs Fine-Tuning](04-rag.md#rag-vs-fine-tuning).

- **Hallucination**: Output that sounds plausible but is false, fabricated, or unsupported by the context. See [Hallucinations](01-LLMs.md#hallucinations).

- **Harness**: The software around a model that turns it into an agent: it builds the context, exposes and executes tools, enforces permissions, manages memory, and runs the agent loop. Claude Code, OpenCode, and GitHub Copilot CLI are harnesses. See [Harness](../02-agentic-engineering/02-harness.md).

- **Hook**: User-defined code that the harness runs automatically at a lifecycle event, such as before a tool call. Unlike instructions, hooks always run, so they can enforce rules. See [Harness: Hooks](../02-agentic-engineering/02-harness.md#hooks) and [Hooks in each tool](../03-ai-assisted-development/06-hooks.md).

- **Human-in-the-loop**: A workflow in which a human approves, reviews, or corrects an agent's actions at defined checkpoints. See [Human in the Loop](../02-agentic-engineering/05-security.md#human-in-the-loop).

- **Hybrid search**: Running keyword search (such as BM25) and embedding search together and merging the results. It usually beats either one alone. See [Hybrid Search](04-rag.md#hybrid-search).

- **Inference**: Using a trained model to generate a prediction or response. See [Inference](01-LLMs.md#inference).

- **Knowledge cutoff**: The date at which a model's training data ends. The model knows nothing after it unless that information is provided in the context. See [Pre-training](01-LLMs.md#pre-training).

- **Lethal trifecta**: Simon Willison's term for an agent that has access to private data, exposure to untrusted content, and a way to communicate externally. Together these let prompt injection leak data. See [The Lethal Trifecta](../02-agentic-engineering/05-security.md#the-lethal-trifecta).

- **LLM**: Large Language Model, an AI model trained on large amounts of text to understand and generate language. See [LLMs](01-LLMs.md).

- **MCP**: Model Context Protocol, an open standard for connecting AI applications to external systems through servers that expose tools, resources, and prompts. See [Harness: MCP](../02-agentic-engineering/02-harness.md#mcp-model-context-protocol) and [MCP in each tool](../03-ai-assisted-development/07-mcp.md).

- **Memory**: Information that persists across sessions, such as instruction files or memory files the agent writes, and is re-injected into the context. The context window itself is not memory. See [Memory](../02-agentic-engineering/04-memory.md).

- **OpenSpec**: An open-source, lightweight framework for Spec-Driven Development, built for changes to existing codebases. See [OpenSpec](../04-spec-driven-development/03-openspec.md).

- **Permission mode**: A harness setting that decides which actions the agent may take without asking, from asking for everything to auto-accepting edits. See [Claude Code permission modes](../03-ai-assisted-development/04-tools-and-permissions.md#permission-modes).

- **Plan mode**: A mode in which the agent researches and proposes a plan without editing files; you approve the plan before any changes. See [Plan Mode](../03-ai-assisted-development/09-workflows.md#plan-mode).

- **Plugin**: A tool-specific extension package. In Claude Code, a plugin bundles skills, agents, hooks, and MCP servers for sharing; in OpenCode, a plugin is a JavaScript or TypeScript module that handles events. See [Skills: Claude Code](../03-ai-assisted-development/05-skills.md#claude-code) and [Hooks: OpenCode](../03-ai-assisted-development/06-hooks.md#opencode).

- **Post-training**: The training phase that turns a base model into a helpful assistant, using instruction tuning and preference feedback (RLHF and similar). See [Post-training](01-LLMs.md#post-training).

- **Pre-training**: The first, large-scale training phase, in which a model learns language and general knowledge by predicting the next token over massive datasets. See [Pre-training](01-LLMs.md#pre-training).

- **Prompt caching**: An API feature that caches a stable prompt prefix (system prompt, tool definitions, instruction files) so repeated requests are cheaper and faster. See [Prompt Caching](06-context-engineering.md#7-prompt-caching).

- **Prompt engineering**: The practice of writing clear, effective instructions so a model consistently produces the output you need. See [Prompt Engineering](02-prompt-engineering.md).

- **Prompt injection**: An attack in which content the model reads as data, such as a web page, README, or tool result, contains instructions that the model then follows. See [Prompt Injection](../02-agentic-engineering/05-security.md#prompt-injection).

- **RAG**: Retrieval-Augmented Generation, a technique that retrieves relevant information from external sources and adds it to the model's context before it generates a response. See [RAG](04-rag.md).

- **ReAct**: Reasoning + Acting (Yao et al., 2022), an agent pattern that alternates reasoning steps with tool actions and observations. See [ReAct](../02-agentic-engineering/01-agents.md#react).

- **Reasoning model**: An LLM trained to produce internal reasoning before its final answer, which improves multi-step tasks such as math, logic, and coding. See [Reasoning models](01-LLMs.md#reasoning-models).

- **Reranking**: A second retrieval step in which a more accurate model re-scores the top candidates from a first search and keeps only the best few. See [Reranking](04-rag.md#reranking).

- **Retriever**: The RAG component that finds the chunks relevant to a query, using embeddings with a vector index, keyword search, or both. See [Components of a RAG System](04-rag.md#components-of-a-rag-system).

- **SDD**: Spec-Driven Development, an approach in which a reviewable specification is written before the code and used as the contract that the AI implements and tests verify. See [SDD Fundamentals](../04-spec-driven-development/01-sdd-fundamentals.md).

- **Semantic search**: Search that finds information by meaning rather than exact keyword matches, usually with embeddings. See [Keyword Search vs Embeddings](03-embeddings.md#keyword-search-vs-embeddings).

- **Skill**: A folder with a `SKILL.md` (frontmatter plus instructions) and optional scripts and references. Only its name and description stay in context; the full content loads when the task matches. See [Harness: Skills](../02-agentic-engineering/02-harness.md#skills) and [Skills in each tool](../03-ai-assisted-development/05-skills.md).

- **Structured outputs**: An API feature that constrains the model's response to a JSON Schema you provide, so automation gets valid, parseable output. See [Prompting Patterns](02-prompt-engineering.md#prompting-patterns).

- **Subagent**: An agent invoked by another agent for a specific task. It runs in its own context window and returns only a summary to its parent. See [Primary Agents and Subagents](../02-agentic-engineering/01-agents.md#primary-agents-and-subagents).

- **System prompt**: The instructions the application or harness sends ahead of the conversation to set the model's role, rules, and behavior. See [System Prompt and Message Roles](02-prompt-engineering.md#system-prompt-and-message-roles).

- **Temperature**: A sampling parameter that controls randomness: lower values give more predictable output, higher values more varied output. Some reasoning models fix or ignore it. See [Temperature](01-LLMs.md#temperature).

- **Token**: The unit of text a model reads and generates, often a word fragment, punctuation mark, or symbol. Context limits and pricing are measured in tokens. See [Tokenization](01-LLMs.md#tokenization).

- **Tokenization**: Breaking text into tokens that a model can process. See [Tokenization](01-LLMs.md#tokenization).

- **Tool calling**: The mechanism by which a model requests a tool with a structured block (name plus JSON arguments); the application or harness executes it and returns the result. Also called function calling. See [Tool Calling: Who Does What](05-tools.md#tool-calling-who-does-what).

- **Tool definition**: The name, description, and JSON Schema of parameters that the application sends with each request to tell the model a tool exists and how to call it. See [Tool Definitions](05-tools.md#tool-definitions).

- **Vector database**: A database optimized for storing and searching embeddings, typically to find content semantically similar to a query. See [What Is a Vector Database?](03-embeddings.md#what-is-a-vector-database) and [RAG](04-rag.md).

- **Vibe coding**: Building software by prompting an AI and accepting its output without really reading or reviewing the code (a term coined by Andrej Karpathy in February 2025). See [Agentic Engineering](../02-agentic-engineering/README.md#from-vibe-coding-to-agentic-engineering).

## Links

- [AI Coding Dictionary](https://www.aicodingdictionary.com/)
