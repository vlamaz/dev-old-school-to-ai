# RAG (Retrieval-Augmented Generation)

RAG (Retrieval-Augmented Generation) is a technique that retrieves relevant information from external sources and provides it to an AI model before it generates a response, enabling more accurate, up-to-date, and context-aware answers.

Instead of relying only on what it learned during training, the AI can access additional knowledge at runtime.

`RAG = Search for relevant information + Generate an answer using that information`

The AI isn't "remembering" the information; it's looking it up before answering.

## Why RAG Exists

LLMs have limitations:

- Training data stops at a knowledge cutoff and becomes outdated
- They don't know your private documents
- They can't memorize every piece of information
- They may hallucinate when information is missing

RAG solves this by giving the model access to external knowledge sources at request time.

## How RAG Works

```text
User Question
       ↓
Retrieve Relevant Information
       ↓
Add Retrieved Information to the Prompt
       ↓
LLM Generates Response
```

For example:

```text
Question:
What is our company's vacation policy?
        ↓
Search company documentation
        ↓
Find relevant policy document
        ↓
Provide answer based on the document
```

A well-designed RAG prompt tells the model to answer **only** from the retrieved content, to cite it, and to say so when the answer isn't there. Letting the model mix in its own training knowledge is a common source of hallucinations.

```text
Answer the question using only the documents below.
Quote the passage you rely on.
If the documents don't contain the answer, say "I don't know".

<documents>
...
</documents>
```

## Common Sources of Retrieved Data

1. **Documentation**

   ```text
   README.md
   Wiki pages
   Technical documentation
   ```

2. **Source Code**

   ```text
   Repository files
   Architecture documents
   Specifications
   ```

3. **Company Knowledge**

   ```text
   Policies
   Procedures
   Internal documentation
   ```

4. **Databases**

   ```text
   Customer data
   Orders
   Products
   ```

5. **Websites**

   ```text
   Knowledge bases
   Product documentation
   Public websites
   ```

## Components of a RAG System

- **The knowledge base**: the external data the system can search, usually split into chunks and stored in an index.
- **The retriever**: the component that finds the chunks relevant to a query. Typically an embedding model plus a vector index, keyword search (BM25), or both. It doesn't need to be a generative AI model.
- **The reranker** (optional): a second model that re-scores the retrieved candidates for relevance.
- **The orchestration layer**: the code that runs the pipeline: receives the question, calls the retriever, builds the prompt, calls the model.
- **The generator**: the LLM that writes the answer from the question and the retrieved content.

## The Production Pipeline

RAG has two phases: **indexing** (done in advance) and **querying** (done on every question).

```text
INDEXING (offline)

Documents
     ↓
Chunking
     ↓
Embedding model
     ↓
Vector Database (+ keyword index, + metadata)

QUERYING (per question)

User Question
     ↓
Embedding model (same one as indexing)
     ↓
Similarity Search (+ keyword search)
     ↓
Top-k Relevant Chunks
     ↓
Reranking (optional)
     ↓
LLM
     ↓
Answer with sources
```

`k` (how many chunks to retrieve) is a tunable value. Too few and the answer may be missing; too many and the context fills with noise.

For how embeddings and similarity search work, see [Embeddings](03-embeddings.md).

### Real-World Example

Imagine asking:

```text
Can users cancel a booking?
```

A RAG system would:

1. Embed the question.
2. Find the closest chunks: the cancellation section of `docs/booking.md`.
3. Add them to the AI's context.
4. Generate an answer using that documentation.

```text
Question
      ↓
Search index
      ↓
Retrieve chunk from booking.md:
"Bookings can be cancelled before driver pickup"
      ↓
Send to LLM
      ↓
Generate answer (citing booking.md)
```

The answer is based on actual project knowledge instead of a guess.

## Chunking

Documents are split into smaller pieces (chunks) before they are embedded, because:

- Embedding models have a maximum input size.
- One vector for a whole document blurs many topics together, so searches match poorly.
- Retrieving only the relevant parts keeps the prompt small.

Common strategies:

- **Fixed size**: split every N tokens, with some overlap between chunks so sentences aren't cut in half.
- **Structure-aware**: split on headings, paragraphs, or, for code, on functions and classes.
- **Semantic**: split where the topic changes.

Chunk size is a trade-off. Small chunks are precise but lose surrounding context; large chunks keep context but add noise. A common improvement is to store each chunk with its document title, section heading or a short summary, so the chunk still makes sense on its own.

## Hybrid Search

Embedding search is good at meaning but weak at exact terms such as error codes, IDs and function names. Keyword search (BM25) is the opposite.

**Hybrid search** runs both and merges the results. It usually beats either one alone and is the default in many production systems.

## Reranking

A first-stage search is fast but rough. A **reranker** takes the top candidates (for example 50) and scores each one against the question with a more accurate (and slower) model, keeping only the best few (for example 5).

```text
Hybrid search → 50 candidates → Reranker → Top 5 → LLM
```

## Metadata Filtering and Access Control

Store metadata with each chunk (source, date, product, permissions) and filter on it at query time:

- Restrict results to the right product, version or language.
- Prefer recent documents.
- **Only return documents the user is allowed to see.** A RAG system without permission filtering can leak confidential data through the model's answer.

## Keeping the Index Fresh

An index is a copy of your data. When documents change, the affected chunks must be re-embedded, or the system answers from stale information. Plan how updates and deletions reach the index from the start.

## Evaluating RAG

Measure the two halves separately:

- **Retrieval**: for a set of test questions, do the right chunks appear in the top-k results?
- **Generation**: is the answer faithful to the retrieved chunks (no invented content), and does it actually answer the question?

Build a small set of real questions with known answers and re-run it whenever you change chunking, embedding model, `k` or prompts.

## RAG Security

Retrieved content is untrusted input. A document containing hidden instructions ("ignore previous instructions and...") can steer the model. This is **indirect prompt injection**. See [Prompt Injection](02-prompt-engineering.md#prompt-injection).

## RAG vs Fine-Tuning

**Fine-Tuning**

Knowledge and behavior trained into the model's weights.

Best for:

- Specialized behavior, style or format
- Domain adaptation

**RAG**

Knowledge retrieved when needed.

Best for:

- Documentation
- Company knowledge
- Frequently changing information
- Answers that must cite sources

RAG is usually the first choice: it's cheaper, updates instantly, and shows where answers came from.

## RAG vs Long Context

With very large context windows, small knowledge bases can sometimes be sent in full, with no retrieval at all. This is simpler, but every request pays for all those tokens, and quality drops as the context fills up (see [Context Window](01-LLMs.md#context-window)). RAG scales to knowledge bases far larger than any context window.

## RAG vs Agentic Search

Classic RAG retrieves once, before the model starts. In **agentic search**, the model itself decides what to look for, using search tools in a loop: search, read the results, refine the query, read more.

AI coding tools take different approaches:

- **Claude Code** uses agentic search: the model runs tools such as Grep, Glob and Read directly on the files, with no vector index. Its team has said they tried an embedding-based RAG index early on and found agentic search worked better for code, without the problems of stale indexes.
- **Some other tools**, such as Cursor, build an embedding index of the codebase for semantic search.

Agentic search is still retrieval, just without a vector database. It works well for code, where exact names matter and files change constantly. Embedding-based RAG still wins for large document collections and fuzzy natural-language questions.

For how tools work, see [Tools](05-tools.md).
