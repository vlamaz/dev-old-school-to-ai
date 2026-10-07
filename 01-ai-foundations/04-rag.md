# RAG (Retrieval-Augmented Generation)

RAG (Retrieval-Augmented Generation) is a technique that retrieves relevant information from external sources and provides it to an AI model before it generates a response, enabling more accurate, up-to-date, and context-aware answers.

Instead of relying only on what it learned during training, the AI can access additional knowledge at runtime.

`RAG = Search for relevant information + Generate an answer using that information`

## Why RAG Exists

LLMs have limitations:

- Training data can become outdated
- They don't know your private documents
- They can't memorize every piece of information
- They may hallucinate when information is missing

RAG solves this by giving the model access to external knowledge sources.

## How RAG Works

```text
User Question
       ↓
Retrieve Relevant Information
       ↓
Add Retrieved Information
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

The answer is based on both model knowledge and retrieved information.

## Common Sources of Retrieved Data

1.  **Documentation**

    ```text
    README.md
    Wiki pages
    Technical documentation
    ```

2.  **Source Code**

    ```text
    Repository files
    Architecture documents
    Specifications
    ```

3.  **Company Knowledge**

    ```text
    Policies
    Procedures
    Internal documentation
    ```

4.  **Databases**

    ```text
    Customer data
    Orders
    Products
    ```

5.  **Websites**

    ```text
    Knowledge bases
    Product documentation
    Public websites
    ```

## RAG in AI Coding Tools

Tools such as:

- Claude Code
- GitHub Copilot
- Cursor
- OpenCode

often use RAG-like techniques.

They can search:

- Source code
- Documentation
- Project files
- Specifications

and use that information when generating responses.

## RAG vs Fine-Tuning

**Fine-Tuning**

Knowledge stored inside the model.

Best for:

- Specialized behavior
- Domain adaptation

**RAG**

Knowledge retrieved when needed.

Best for:

- Documentation
- Company knowledge
- Frequently changing information

## Components of a RAG system

RAG systems contain four primary components:

- **The knowledge base**: The external data repository for the system.
- **The retriever**: An AI model that searches the knowledge base for relevant data.
- **The integration layer**: The portion of the RAG architecture that coordinates its overall functioning.
- **The generator**: A generative AI model that creates an output based on the user query and retrieved data.

Other components might include a ranker, which ranks retrieved data based on relevance, and an output handler, which formats the generated response for the user.

## RAG and Embeddings

Most modern RAG systems use embeddings.

**Documents**

```text
project/
├── README.md
├── docs/
│   ├── authentication.md
│   ├── booking.md
│   └── payments.md
└── src/
```

**Convert to Embeddings**

```text
Document → Vector
```

**Store in Vector Database**

```text
Vector DB
```

**User Question**

```text
How does login work?
```

The question is also converted into an embedding.

The vector database finds documents with similar meaning.

```text
How does login work?
    ↓
authentication.md
```

Then the LLM uses the retrieved document to answer.

See: [Embeddings](05-embeddings.md)

## Real-World Example

Production systems usually work like this:

```text
Documents
     ↓
Chunking
     ↓
Embeddings
     ↓
Vector Database
     ↓
User Question
     ↓
Embedding
     ↓
Similarity Search
     ↓
Top 5 Relevant Chunks
     ↓
LLM
     ↓
Answer
```

Imagine asking:

```text
Can users cancel a booking?
```

A RAG system would:

1. Search the API documentation.
2. Retrieve the booking section.
3. Add it to the AI's context.
4. Generate an answer using that documentation.

```text
Question
      ↓
Search repository
      ↓
Read booking.md
      ↓
Retrieve:
"Bookings can be cancelled before driver pickup"
      ↓
Send to LLM
      ↓
Generate answer
```

The answer is based on actual project knowledge instead of a guess.

The AI isn't "remembering" the information; it's looking it up before answering.
