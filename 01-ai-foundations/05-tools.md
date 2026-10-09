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

## Tool Calling: Who Does What

The most important thing to understand: **the model never executes anything itself.** It can only produce text. A tool call is a structured request the model writes; the application around the model runs it.

```text
User Request
       ↓
Application sends the request + the list of available tools to the LLM
       ↓
LLM replies with a tool call (tool name + JSON arguments)
       ↓
Application checks permissions and executes the tool
       ↓
Application sends the tool result back to the LLM
       ↓
LLM either requests another tool or writes the final answer
```

Example:

```text
What is the status of ticket ABC-123?
```

1. The model replies with a request: call `get_jira_issue` with `{"key": "ABC-123"}`.
2. The application calls the Jira API and gets the ticket data.
3. The application sends the data back to the model.
4. The model summarizes the result for the user.

In coding tools, the application that runs this loop is called the **harness** (Claude Code, OpenCode, GitHub Copilot CLI). Because the harness executes every tool, it is also where permissions, approvals and sandboxing are enforced. See [Harness](../02-agentic-engineering/02-harness.md).

## Tool Definitions

The application tells the model which tools exist by sending a **definition** for each one, with every request:

- **Name**: a short identifier.
- **Description**: what the tool does and when to use it.
- **Input schema**: the parameters, as a JSON Schema.

Example (Anthropic API format):

```json
{
  "name": "get_jira_issue",
  "description": "Get a Jira issue by its key. Returns the summary, status, assignee and last comments. Use it when the user mentions a ticket key such as ABC-123.",
  "input_schema": {
    "type": "object",
    "properties": {
      "key": {
        "type": "string",
        "description": "Issue key, for example ABC-123"
      }
    },
    "required": ["key"]
  }
}
```

The model decides *which* tool to call, and with what arguments, based only on these names and descriptions. Write them like documentation for a new colleague:

- Say what the tool returns and when it should (and shouldn't) be used.
- Describe each parameter and its format.
- Keep tools focused; avoid several tools that overlap.

Tool definitions are part of the context window. Dozens of tools cost tokens on every request and make the right choice harder. Some harnesses load tool definitions only when needed to reduce this cost.

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

Tools also differ by **risk**:

- **Read-only** (read file, search): low risk.
- **Write** (edit files, create tickets): changes state, may need review.
- **Execute** (run shell commands, deploy, send messages): highest risk, usually requires approval or a sandbox.

## Tool Calling - Claude Code Example

User

```text
Explain how authentication works in this project.
```

Claude Code's built-in tools include `Read`, `Grep`, `Glob`, `Edit`, `Write` and `Bash`. The model may first ask to search the repository:

```json
{
  "type": "tool_use",
  "id": "toolu_01",
  "name": "Grep",
  "input": {
    "pattern": "authentication"
  }
}
```

Claude Code runs the search and returns the result to the model:

```json
{
  "type": "tool_result",
  "tool_use_id": "toolu_01",
  "content": "docs/authentication.md\nsrc/auth/AuthService.ts"
}
```

Then the model asks to read a file:

```json
{
  "type": "tool_use",
  "id": "toolu_02",
  "name": "Read",
  "input": {
    "file_path": "docs/authentication.md"
  }
}
```

After reading the files, it writes the final response:

```text
The application uses OAuth2 authentication.

Users authenticate through the Identity Provider and
receive a JWT token that is included in subsequent requests.
```

The exact parameter names of built-in tools are internal to each harness and may change. What matters is the shape: a name, JSON input, and a matching result.

A bigger task such as "Create a new API endpoint" follows the same pattern, just with more calls: search and read existing code, read the project instructions, edit files, run the tests with `Bash`, and fix what fails.

## Parallel Calls and Errors

- **Parallel calls**: a model can request several independent tool calls in one reply (for example, reading three files at once). The harness runs them and returns all the results together.
- **Errors**: when a tool fails (file not found, API timeout, test failure), the harness returns the error as the tool result. The model reads it and can retry, try another approach, or report the problem. Clear error messages help the model recover.

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

A model that calls tools in a loop, deciding its own next step until the task is done, is an **agent**. Without tools, agents are very limited. See [Agents](../02-agentic-engineering/01-agents.md).

## MCP and Tools

With MCP (Model Context Protocol), tools can be packaged once in an **MCP server** and used by many AI clients (Claude Code, OpenCode, GitHub Copilot CLI, and others).

The client connects to the server, discovers the tools it offers, and passes their definitions to the model. The model then calls them like any other tool. MCP servers can also expose **resources** (data the client can read) and **prompts** (reusable prompt templates), not just tools.

Examples:

**GitHub Server**

```text
List Pull Requests
Get Issue
Create Branch
```

**Azure DevOps Server**

```text
Read Work Items
Query Boards
Create Tasks
```

**Database Server**

```text
Get User
Get Bookings
Create Report
```

An MCP server runs with your credentials and its tool results go straight into the model's context. Only install servers you trust. See [MCP](../03-ai-assisted-development/07-mcp.md) for setup in each tool, and [Security](../02-agentic-engineering/05-security.md) for the risks.

## Links

- [Anthropic - Tool use overview](https://platform.claude.com/docs/en/agents-and-tools/tool-use/overview)
- [Anthropic - Writing effective tools for AI agents](https://www.anthropic.com/engineering/writing-tools-for-agents)
- [Model Context Protocol](https://modelcontextprotocol.io)
