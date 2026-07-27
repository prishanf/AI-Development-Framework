# Changelog

## [2.0.0] — 2026-07-26

A structural release. v1 described quality gates without implementing any, made evidence unverifiable, and was too heavy to adopt for small changes. This release addresses all three.

### Added

- **Tracks A/B/C** ([guide/02-tracks.md](guide/02-tracks.md)) — process proportional to risk. A Track A change has one artifact: its pull request.
- **The evidence contract** ([standards/evidence.md](standards/evidence.md)) — claimed vs corroborated. Agent-authored results can no longer satisfy a gate.
- **Executable gates** — `reference/scripts/`: manifest validation, evidence validation, a gate runner that emits `evidence.json`, a framework consistency checker, and a self-test that proves the gates reject what they should.
- **GitHub Actions reference** — `reference/github/`: PR-time gate workflow, self-check workflow, PR template that links evidence rather than restating it, and a CODEOWNERS sample that turns specialist review into a real control.
- **Machine-readable schemas** — `schemas/project.schema.json` and `schemas/evidence.schema.json`, with a dependency-free validator.
- **[standards/ai-safety.md](standards/ai-safety.md)** — prompt injection, source and data egress to model providers, agent credential scope, MCP supply chain, and the failure modes specific to reviewing generated code.
- **[standards/testing.md](standards/testing.md)** — test quality, AI test anti-patterns, and the rule that a new test must fail against the pre-change code.
- **Stop conditions** — three failures on the same check, an invalidated assumption, or a needed track escalation all stop the agent. Disabling a check to reach green is explicitly forbidden.
- **PR size budget** — a ~400-line soft cap, advisory by design.
- **New risk tags** — `infra`, `dependency`, `docs`.
- **[templates/conventions.md](templates/conventions.md)** — the brownfield entry point; what "follow existing patterns" actually points at.
- **Process observability** — rework rate, gate pass rate, escaped defects, waiver age, cycle time.
- **Context and cost guidance**, and `project.yaml` for the framework itself (it now runs its own gates).

### Changed — breaking

- **Preview is conditional**, required for `ui`/`api`/`database` and Track C, not for every pull request. This removes ephemeral-environment infrastructure as a precondition for adopting AIDF.
- **Files moved.** `01-`…`09-` → `guide/` (renumbered); `10-`…`17-` → `standards/` (named, not numbered). Numeric prefixes remain only where reading order is real.
- **`guide/03-workflow.md` is the sole canonical lifecycle.** The README diagram and everything in `diagrams/` derive from it; CI fails if they drift.
- **The `staged` state and staging branch are gone** from the default model. Trunk-based is the default; a `qa` branch requires setting `repository.qa_branch` deliberately.
- **Risk tags are defined once**, in `standards/quality-gates.md`. The manifest and schema reference the names; `check-consistency.sh` fails on drift.
- **The gate matrix is split** into PR-time and release-time tables. Production approval was previously listed under "All PRs", which read as every PR needing production sign-off.
- **Manifest `gates:` collapsed** from ten booleans to four, and `quality_profiles:` was removed. New required sections: `evidence:`, `tags:`. New optional section: `ai_safety:`.
- **An empty required command now fails** rather than silently skipping — a manifest configuring nothing can no longer satisfy every gate.
- **`qa.enabled` defaults to `false`**, consistent with the trunk-based default.
- **The Coordinator role was removed.** It had no command contract; parallel-work rules live in `standards/worktrees.md`.
- **Adapters no longer advertise slash commands.** v1's `.claude/CLAUDE.md` mapped `/spec`, `/plan`, `/build`, `/review`, `/ship` to a `commands/` directory that did not exist, so none of those commands worked. Adapters are now instruction pointers, and CI fails if one promises a surface the repository does not ship.

### Removed

- `templates/change-classification.md` — classification is now front matter on the feature spec.
- `templates/seed-data-plan.md` — merged into `templates/migration-plan.md` as a "Seed profile" section.
- `examples/sample-feature/04-implementation.md` — the pull request is the implementation record.

### Migration from 1.1.0

1. Move your vendored framework files to `guide/` and `standards/`, or re-copy the directory.
2. In `project.yaml`: replace `quality_profiles:` with `tags:`, collapse `gates:` to the four booleans, add `evidence:`, set `qa.enabled: false` unless you use a QA branch, and fill every required command — empty now fails.
3. Fold each open change-classification document into its spec's `classification:` front matter.
4. Fold seed data plans into their migration plans.
5. Add `track:` front matter to any customized templates.
6. Copy `reference/github/` into `.github/` and enable branch protection with Code Owner review.
7. Run `sh reference/scripts/validate-manifest.sh project.yaml` and fix what it reports.

## [1.1.0] — 2026-07-26

### Added

- Provider-agnostic environment, CI/CD, database migration, UI QA, API/NFR, MCP, security, observability, and rollback guidance.
- Risk-based change classification and quality-gate templates.
- Templates for environment matrices, migrations, seed data, UI QA, API contracts, MCP capabilities, threat models, and deployment records.
- `validate` and `preview` operational command contracts.

### Changed

- Default branching strategy is now trunk-based with approval and Preview validation for every pull request.

## [1.0.0] — 2026-07-26

### Added

- Agent-agnostic lifecycle, roles, branch, worktree, document, and decision guidance.
- Five command contracts: `spec`, `plan`, `build`, `review`, and `ship`.
- Twelve reusable templates, including the project manifest.
- Six Mermaid diagrams for lifecycle, ownership, documents, worktrees, deployment, and orchestration.
- End-to-end saved-searches example with security decision and release evidence.
- Thin Claude, Codex, Cursor, and generic adapters.
