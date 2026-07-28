# Claude adapter

Follow the adapter-neutral rules in [AGENTS.md](../AGENTS.md). The command contracts live in [commands/](../commands/); read the one matching the role you are performing and follow it as written.

**This repository** ships no slash commands. The files in `commands/` are prompt contracts, not executable commands.

**An installed project** does get them: `reference/scripts/aidf-install.sh` vendors the framework into `.aidf/` and generates one `.claude/commands/<name>.md` per contract, so each contract becomes a slash command there. See [adapters/README.md](../adapters/README.md).

Do not add Claude-specific lifecycle rules here.
