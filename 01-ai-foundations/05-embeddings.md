# Embeddings

Embeddings are numerical vector representations of data that capture meaning and allow AI systems to compare, search, and retrieve information based on semantic similarity rather than exact keywords.

In simple terms: Embeddings convert text into vectors (lists of numbers) so that machines can understand semantic similarity.

## Why Do We Need Embeddings?

Computers do not understand language directly.

For example:

```text
Book a taxi
Reserve a cab
```

To a human, these mean nearly the same thing.

To a computer, they are completely different strings.

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

## How RAG Uses Embeddings

### Step 1: Store Documents

```text
authentication.md
booking.md
payments.md
```

### Step 2: Create Embeddings

```text
authentication.md
        ↓
Embedding Vector

booking.md
        ↓
Embedding Vector
```

### Step 3: Store in a Vector Database

```text
Vector DB

[Authentication Vector]
[Booking Vector]
[Payments Vector]
```

### Step 4: User Asks a Question

```text
How do users log in?
```

The question is also converted into an embedding.

### Step 5: Similarity Search

The vector database finds documents whose embeddings are closest to the question.

```text
Question Vector
        ↓
Closest Match:
authentication.md
```

### Step 6: Send to LLM

```text
authentication.md
        ↓
LLM
        ↓
Answer
```

## What Is a Vector Database?

A database optimized for storing and searching embeddings.

Popular examples:

- Pinecone
- Weaviate
- Chroma
- Qdrant
- Milvus
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

## Why Embeddings Are Important for AI Engineers

Embeddings are the foundation of:

- RAG systems
- Semantic search
- Knowledge bases
- AI assistants
- Document retrieval
- Recommendation systems

Without embeddings, most modern RAG architectures would not exist.

## Links
