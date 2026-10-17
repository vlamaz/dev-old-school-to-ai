# Supply Chain

Supply chain risk (LLM03) is the chance that a component an LLM system depends on is malicious, compromised, or simply wrong. An LLM system has more dependencies than ordinary software: model weights, datasets, adapters, prompts and extensions, on top of the usual packages.

## What Counts as a Dependency

```text
Model weights          downloaded from a hub, or served by a third-party API
Datasets               scraped, bought, or pulled from public sources
Fine-tuned adapters    LoRA files shared by other people
Packages               pip, npm and other libraries, including the ones a model suggests
Extensions             MCP servers, agent skills, plugins and hooks
Prompts and templates  copied from the internet or from other projects
```

## Example

- **Unsafe model file.** A model on a public hub is saved in Python `pickle` format. Loading a pickle can run arbitrary code, and the file looks like any other model.
- **Slopsquatting.** An assistant suggests `pip install fastjson-utils` for a package that does not exist. Attackers watch for such names and register them with malicious code. The install works, and the project is compromised. The model did not invent the malware, but it created the opening.

## How to Avoid It

- **Pin versions and use lockfiles.** Verify hashes where the tool supports them, so an update cannot change what you run without you noticing.
- **Check every suggested package before installing it.** Confirm that it exists, that it is maintained, and that the publisher is the one you expect. Never install a name only because a model proposed it.
- **Prefer safe model formats.** Use `safetensors` over pickle-based formats, and don't enable options that run code shipped with a model unless you have reviewed that code.
- **Use approved registries.** A private registry or mirror limits what CI and agents can install.
- **Keep an inventory.** Record where each model, dataset and extension came from and under which license. Software bills of materials (SBOMs) are the usual format; some teams add a similar record for models and datasets.
- **Vet extensions.** Read MCP servers, skills and plugins before installing them, pin their versions, and grant only the permissions they need. See [Untrusted MCP Servers, Skills and Plugins](../02-agentic-engineering/05-security.md#untrusted-mcp-servers-skills-and-plugins).
- **Scan in CI.** Run dependency and secret scanners on the same schedule as for regular code.
- **Re-review after updates.** A dependency or extension can change behavior after you approved it.

## Related Notes

- [Data and Model Poisoning](04-data-and-model-poisoning.md), the same question applied to data
- [Misinformation](08-misinformation.md), which covers the fabricated package names in more depth
