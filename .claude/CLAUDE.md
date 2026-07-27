# Claude adapter

Follow the adapter-neutral rules in [AGENTS.md](../AGENTS.md). The command contracts live in [commands/](../commands/); read the one matching the role you are performing and follow it as written.

This repository ships **no slash commands**. The files in `commands/` are prompt contracts, not executable commands. To expose them as slash commands in your own project, follow [adapters/README.md](../adapters/README.md) — it takes about ten minutes and the framework deliberately leaves that choice to you.

Do not add Claude-specific lifecycle rules here.
