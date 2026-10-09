# MCP

MCP (Model Context Protocol) is an open standard for connecting AI applications to external systems. An MCP server exposes **tools** (actions such as "create issue"), **resources** (data such as files or records), and **prompts** (reusable templates). The harness connects to the server and offers its tools to the model next to the built-in ones. For the concept, see [Harness: MCP](../02-agentic-engineering/02-harness.md) and [Tools](../01-ai-foundations/05-tools.md).

**Docs:** <https://modelcontextprotocol.io/>

Two kinds of server:

- **Local (stdio):** a process started on your machine, e.g. `npx -y some-mcp-server`. It runs with your user's permissions.
- **Remote (HTTP):** a URL, usually with OAuth sign-in, e.g. `https://mcp.atlassian.com/v2/mcp`.

## Before Adding a Server

- **Context cost.** Every tool definition takes tokens. Claude Code defers MCP tool definitions by default (tool search); harnesses that load them up front pay for every tool of every server on every turn. Enable only what you need.
- **Trust.** A local server is code running on your machine. Install servers from sources you trust, and pin versions (`@scope/server@1.2.3`) instead of pulling `latest`.
- **Prompt injection.** Tool results enter the context. A server that returns external content (issues, web pages, emails) can carry instructions written by someone else. Be most careful when the same session has access to private data, untrusted content, and a way to send data out. See [Security](../02-agentic-engineering/05-security.md).
- **Secrets.** Keep tokens out of committed config files. Use environment variables or the tool's OAuth flow.
- **Permissions.** MCP tools go through the same permission system as built-in tools (see [Tools & Permissions](04-tools-and-permissions.md)). Deny the destructive ones.

## Claude Code

**Add servers with the CLI:**

```shell
# Remote HTTP server
claude mcp add --transport http atlassian https://mcp.atlassian.com/v2/mcp

# Local stdio server: everything after -- is the command that starts it
claude mcp add --transport stdio --env API_KEY=YOUR_KEY airtable -- npx -y airtable-mcp-server

# Shared with the team (writes .mcp.json)
claude mcp add --transport http --scope project shared-server https://example.com/mcp
```

Then run `/mcp` in a session to check status and sign in to OAuth servers. `claude mcp list` shows everything configured.

**Scopes:**

| Scope           | Loads in             | Shared with team        | Stored in                         |
| --------------- | -------------------- | ----------------------- | --------------------------------- |
| `local` (default) | Current project    | No                      | `~/.claude.json`, under the project |
| `project`       | Current project      | Yes, via version control | `.mcp.json` in the project root  |
| `user`          | All your projects    | No                      | `~/.claude.json`                  |

Claude Code asks for approval before using servers from a project's `.mcp.json`.

**`.mcp.json` format:**

```json
{
  "mcpServers": {
    "ado": {
      "command": "cmd",
      "args": [
        "/c",
        "npx",
        "-y",
        "@azure-devops/mcp@2.10.0",
        "my-org",
        "--authentication",
        "azcli",
        "-d",
        "core",
        "repositories"
      ],
      "env": {
        "ado_mcp_project": "my-project"
      }
    },
    "atlassian": {
      "type": "http",
      "url": "https://mcp.atlassian.com/v2/mcp"
    }
  }
}
```

- An entry with a `url` needs `"type": "http"`; without `type`, Claude Code treats it as a stdio server and skips it.
- The `ado` example starts `npx` through `cmd /c` on Windows. On macOS or Linux use `"command": "npx"` directly.
- `.mcp.json` supports `${VAR}` expansion, so tokens can stay in environment variables.

**In use:**

- Tools appear as `mcp__<server>__<tool>`. Use that name in permission rules: `"deny": ["mcp__github__delete_repository"]`, or `mcp__github` for the whole server.
- Tool search: only tool names load at startup; full definitions load when Claude needs them, so many servers don't fill the context.
- Large outputs: a warning above 10,000 tokens, a default limit of 25,000 (`MAX_MCP_OUTPUT_TOKENS`). Bigger results are saved to a file Claude can read.
- `@server:protocol://path` mentions add an MCP resource to your prompt, for example `@github:issue://123`.

## OpenCode

Servers go under the `mcp` key in `opencode.json` (project) or `~/.config/opencode/opencode.json` (global). The format differs from `.mcp.json`: local servers use `"type": "local"` and a `command` **array**, and environment variables go in `environment`.

```json
{
  "$schema": "https://opencode.ai/config.json",
  "mcp": {
    "ado": {
      "type": "local",
      "command": ["npx", "-y", "@azure-devops/mcp@2.10.0", "my-org", "--authentication", "azcli", "-d", "core", "repositories"],
      "environment": {
        "ado_mcp_project": "my-project"
      }
    },
    "atlassian": {
      "type": "remote",
      "url": "https://mcp.atlassian.com/v2/mcp"
    }
  }
}
```

- Optional fields: `enabled` (turn a server off without removing it), `timeout`, `headers` and `oauth` for remote servers.
- CLI: `opencode mcp add`, `opencode mcp list`, `opencode mcp auth <server>` for OAuth, `opencode mcp debug`.
- OpenCode doesn't document reading `.mcp.json`.
- Tool names are prefixed with the server name, so a permission rule like `"ado_*": "ask"` covers one server's tools.

## GitHub Copilot CLI

**Where servers come from** (highest priority first; same name → higher wins):

1. `--additional-mcp-config` (one session)
2. Plugins
3. Workspace: `.mcp.json` and `.github/mcp.json`, from the working directory up to the Git root (folder must be trusted)
4. User: `~/.copilot/mcp-config.json`

The GitHub MCP server is built in (`--disable-builtin-mcps` turns it off).

**Add servers:**

```shell
copilot mcp add atlassian https://mcp.atlassian.com/v2/mcp
copilot mcp add my-server -- npx -y some-mcp-server
```

Or `/mcp add` in a session. `/mcp` also lists, edits, enables, disables, and authenticates servers.

**Format:** `mcpServers`, like Claude Code's `.mcp.json`, plus a `tools` list to choose which tools to expose:

```json
{
  "mcpServers": {
    "atlassian": {
      "type": "http",
      "url": "https://mcp.atlassian.com/v2/mcp",
      "tools": ["*"]
    }
  }
}
```

- Every MCP tool call asks for permission until you allow it. Allow per tool with `--allow-tool='atlassian(TOOL_NAME)'`, or a whole server with `--allow-tool=atlassian`.
- Local servers run inside the Copilot sandbox when it's on; remote servers don't.

## Useful Servers

- **Atlassian (Jira, Confluence):** `https://mcp.atlassian.com/v2/mcp`
- **Azure DevOps:** `@azure-devops/mcp`
- **GitHub:** built into Copilot CLI; available as a server for the others
- **Context7:** up-to-date library docs for agents ([context7.com](https://context7.com))

More servers: <https://mcpservers.org/>

## Links

- [Claude Code: MCP](https://code.claude.com/docs/en/mcp)
- [OpenCode: MCP servers](https://opencode.ai/docs/mcp-servers/)
- [Copilot CLI: command reference (MCP section)](https://docs.github.com/en/copilot/reference/copilot-cli-reference/cli-command-reference)
