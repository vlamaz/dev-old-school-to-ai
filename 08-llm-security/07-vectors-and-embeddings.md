# Vector and Embedding Weaknesses

Vector and embedding weaknesses (LLM08) are risks in the retrieval layer of RAG systems and other embedding-based search. A vector store is a second copy of your data, in a form that is easy to search and easy to overlook when setting access control.

## The Risks

- **Missing access control.** Embeddings and their metadata are stored without the permissions of the source documents, so any query can retrieve any chunk. This is the most common and most serious problem. See [RAG: Metadata Filtering and Access Control](../01-ai-foundations/04-rag.md#metadata-filtering-and-access-control).
- **Cross-tenant leakage.** In a system with several customers, one customer's chunks appear in another's results because a filter was missing, or was applied only in the client.
- **Embedding inversion.** Embeddings are not a safe one-way transformation of the text. Research has shown that parts of the original text can be reconstructed from the vectors, so embeddings should be handled as sensitive data.
- **Poisoned content.** An attacker adds documents written to rank highly for target questions, so their content is retrieved and handed to the model. This is retrieval poisoning, a form of [data poisoning](04-data-and-model-poisoning.md).
- **Stale and deleted data.** A removed document still has vectors in the index, and it keeps being retrieved.
- **Mixed embedding models.** Changing the embedding model without re-indexing mixes incompatible vectors. Results degrade in ways that look like random errors.
- **Exposed scores and vectors.** APIs that return raw similarity scores or vectors give an attacker a way to probe the index.

```text
Query: "Q3 revenue forecast"
  ↓
Vector store with no permission filter
  ↓
Returns a chunk from another team's confidential document
  ↓
The model summarizes it for a user who should never see it
```

## How to Avoid It

- **Enforce permissions at query time, on the server.** Store the source's access list with each chunk, and filter by the caller's identity. Never trust the client to send the right filter.
- **Separate tenants.** Use separate indexes or namespaces when data must never mix.
- **Protect the index like the source.** Vector stores and their backups need the same encryption, access rules and retention as the original documents.
- **Propagate deletions.** Remove vectors when the source is removed, and test that deleted content stops appearing.
- **Know what goes in.** Record where each document came from and who can change it, and review changes to shared sources.
- **Return only what is needed.** Don't expose raw vectors or similarity scores to end users.
- **Re-index on model changes.** Store the embedding model version in metadata, and rebuild the index when it changes.
- **Test with different users.** Run queries as users from different permission groups, including adversarial ones, and check that results are filtered correctly.

## Related Notes

- [Embeddings](../01-ai-foundations/03-embeddings.md) and [What Is a Vector Database?](../01-ai-foundations/03-embeddings.md#what-is-a-vector-database), for how the index is built
- [RAG Security](../01-ai-foundations/04-rag.md#rag-security), for indirect prompt injection through retrieved content
