# Tools

In the context of AI agents, a tool is an external capability that an AI can use to interact with the world beyond generating text.

Without tools, an LLM can only answer based on its training data and current context.

```text
User
  ↓
LLM
  ↓
Answer
```

With tools, it can:

- Read files
- Search code
- Query databases
- Call APIs
- Execute commands
- Create documents
- Access external systems

Tools allow AI to perform actions, not just provide answers.

```text
User
  ↓
LLM
  ↓
Tool
  ↓
External System
  ↓
Result
  ↓
LLM
  ↓
Answer
```

Example:

```text
What is the status of ticket ABC-123?
```

The AI:

1. Queries Jira
2. Receives ticket data
3. Summarizes the result

## Tool Calling Flow

```text
User Request
       ↓
LLM decides a tool is needed
       ↓
Tool execution
       ↓
Tool result
       ↓
LLM generates response
```

## Common Types of Tools

- **File Tools**: Read and write files.
- **Search Tools**: Search local or remote information.
- **API Tools**: Call external services.
  Examples:
  - GitHub API
  - Azure DevOps API
  - Jira API
  - Stripe API
- **Database Tools**: Access stored data.
- **Command Line Tools**: Execute terminal commands.
- **Browser Tools**: Access web content.

### Example: Claude Code

User:

```text
Create a new API endpoint.
```

Claude Code may:

```text
Read existing code
      ↓
Read AGENTS.md
      ↓
Analyze architecture
      ↓
Modify files
      ↓
Run tests
```

Tools involved:

```text
File System
Search
Terminal
Testing
```

## Tools vs Knowledge

### Knowledge

```text
Stored in the model
```

Example:

```text
What is OAuth2?
```

### Tools

```text
Accessed at runtime
```

Example:

```text
Show the OAuth2 implementation in this repository.
```

The model must read files to answer.

## Tools and Agents

Agents are usually built from:

```text
Model
+
Tools
+
Memory
+
Instructions
```

```text
Agent
 ├── LLM
 ├── Tools
 ├── Memory
 └── Context
```

Without tools, agents are very limited.

## MCP and Tools

With MCP (Model Context Protocol), tools can be exposed to multiple AI clients.

The AI discovers available tools and invokes them when needed.

Examples:

**GitHub Tool**

```text
List Pull Requests
Get Issue
Create Branch
```

**Azure DevOps Tool**

```text
Read Work Items
Query Boards
Create Tasks
```

**Database Tool**

```text
Get User
Get Bookings
Create Report
```

**Filesystem Tool**

```text
Read File
Write File
Search Project
```

## Tool Calling - Claude Code Example

User

```text
Explain how authentication works in this project.
```

Tool Calls

```text
1. Search repository
2. Find authentication files
3. Read files
```

Example:

```json
JSON
{
    "tool": "search",
    "query": "authentication"
}
```

Result:

```text
docs/authentication.md
src/auth/AuthService.ts
```

Then:

```json
JSON
{
    "tool": "read_file",
    "path": "docs/authentication.md"
}
```

Final Response

```text
The application uses OAuth2 authentication.
 
Users authenticate through the Identity Provider and
receive a JWT token that is included in subsequent requests.
```
