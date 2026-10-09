# Embeddings

Embeddings are numerical vector representations of data that capture meaning and allow AI systems to compare, search, and retrieve information based on semantic similarity rather than exact keywords.

In simple terms: Embeddings convert text into vectors (lists of numbers) so that machines can understand semantic similarity.

## Why Do We Need Embeddings?

Plain string comparison can't detect meaning.

For example:

```text
Book a taxi
Reserve a cab
```

To a human, these mean nearly the same thing.

To a string comparison, they are completely different: they don't share a single word.

Embeddings transform them into vectors whose positions in a mathematical space are very close because they share similar meaning.

```text
"Book a taxi" → [0.24, -0.12, 0.81, ...]
"Reserve a cab" → [0.21, -0.15, 0.79, ...]
```

The vectors are different, but close together.

### Simple Analogy

Imagine a map:

```text
Barcelona
    ●

Madrid
        ●

Paris
                 ●
```

Locations close together are related geographically.

Embeddings work similarly:

```text
"Book a taxi"
        ●

"Order a cab"
          ●

"Reset password"
                              ●
```

Texts with similar meanings are located near each other in embedding space.

The real space has hundreds or thousands of dimensions instead of two, but the idea is the same.

## How Embeddings Are Created

An **embedding model** is a neural network trained specifically to turn text (or images, or code) into vectors. It is a different model from the LLM that writes the answer.

```text
Text chunk
    ↓
Embedding model
    ↓
Vector (e.g. 1024 numbers)
```

Things to know when choosing and using one:

- **Providers**: vendors such as Voyage AI (the provider Anthropic's docs use, since Anthropic has no embedding model of its own), OpenAI, Google and Cohere offer embedding APIs; open models can run locally.
- **Dimensions**: each model outputs vectors of a fixed size. More dimensions can capture more nuance but use more storage.
- **Domain**: some models are tuned for code, legal text or specific languages. Pick one that matches your content.
- **Same model for both sides**: documents and queries must be embedded with the *same* model. Vectors from different models are not comparable, so changing the model means re-embedding everything.
- **Input limit**: embedding models have their own maximum input size, which is one reason long documents are split into chunks first (see [Chunking](04-rag.md#chunking)).

## Measuring Similarity

"Close together" is measured with a distance or similarity function:

- **Cosine similarity**: compares the *angle* between two vectors, ignoring their length. Ranges from -1 to 1; higher means more similar. The most common choice for text.
- **Dot product**: similar to cosine, and identical to it when vectors are normalized to length 1, which many embedding models do.
- **Euclidean distance**: the straight-line distance between two points; lower means more similar.

Use the metric your embedding model's documentation recommends.

A similarity score is relative, not absolute: "0.82" has no fixed meaning across models. Compare scores within the same model and tune any cut-off threshold on your own data.

## What Is a Vector Database?

A database optimized for storing embeddings and finding the nearest ones to a query vector quickly.

Comparing a query against millions of vectors one by one is too slow, so vector databases use **approximate nearest neighbor (ANN)** indexes such as HNSW. They trade a tiny bit of accuracy for a huge gain in speed.

Most also store metadata next to each vector (source file, date, author, permissions) so results can be filtered.

Popular examples:

- Pinecone
- Weaviate
- Chroma
- Qdrant
- Milvus
- pgvector (PostgreSQL extension)
- Azure AI Search

Instead of searching for exact words, they search by meaning.

## Keyword Search vs Embeddings

### Keyword Search

```text
Search:
taxi
```

Finds:

```text
Book a taxi
Taxi booking
Taxi driver
```

May miss:

```text
Order a cab
```

### Embedding Search

```text
Search:
Book a taxi
```

Finds:

```text
Order a cab
Request a ride
Schedule transportation
```

because the meaning is similar.

### Each Has Strengths

Embeddings are not always better:

- **Keyword search wins** for exact identifiers: error codes, function names, ticket IDs, product SKUs. An embedding of `ERR_4012` says little about its meaning.
- **Embedding search wins** for paraphrases, synonyms and natural-language questions.

That is why production systems often combine both (hybrid search). See [Hybrid Search](04-rag.md#hybrid-search).

## Why Embeddings Are Important for AI Engineers

Embeddings are the foundation of:

- Semantic search
- Most RAG systems
- Recommendation systems
- Clustering and topic discovery
- Deduplication (finding near-identical documents)
- Classification (assigning labels by similarity to examples)

Embeddings power most semantic retrieval. But many production systems combine them with keyword search, and coding agents such as Claude Code often retrieve information with plain search tools instead of an embedding index. See [RAG](04-rag.md) for how embeddings fit into a retrieval pipeline.
