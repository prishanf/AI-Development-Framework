# Changelog

## [4.0.0] — 2026-07-27

Caught by running the framework on a real feature PR: after the build agent opened the pull request, nothing invoked `review`, nothing published findings on the host, and the handoff read as "human may begin" while the contracts still treated review as an optional, read-only side quest. The lifecycle diagram said "AI + human review"; the command contracts did not make AI review a required post-PR state.

### Changed — breaking

- **`ai_reviewing` is a first-class lifecycle state.** After the PR is open, the change moves to AI review — not straight to human approval. Canonical definition: [guide/03-workflow.md](guide/03-workflow.md). State table gains `ai_reviewing`; `reviewing` now means authorized **human** review after the ready-for-human comment.
- **`commands/review.md` owns the post-PR loop:** publish findings on the open PR, hand P0/P1 remediation to `build`, re-review after fixes, then post a ready-for-human comment. AI review never satisfies `pull_request_approval`.
- **`commands/build.md`:** when the PR exists, next action is `review`; remediation from review fixes only cited P0/P1 findings and returns to `review`.
- **PR-time gates** gain "AI review complete" for every track ([standards/quality-gates.md](standards/quality-gates.md)) — a process gate evidenced on the host, not by `runner: ci`.
- **`standards/ai-safety.md`:** posting review findings and the ready-for-human comment on **this change's own PR** is in scope for `review` / remediation `build` without a separate outbound-message confirmation.

### Added

- Host publication and ready-for-human fields on [templates/code-review.md](templates/code-review.md); decision vocabulary includes `ready-for-human`.
- Explicit build → review → build remediation → ready-for-human edges in [diagrams/agent-orchestration.md](diagrams/agent-orchestration.md), [diagrams/lifecycle.md](diagrams/lifecycle.md), and the README summary diagram.

### Why this happened

Same class as the v3.x gate gaps: a diagram phrase ("AI + human review") without an enforceable handoff. Agents correctly stopped at `ready_for_review` because that is what the build contract asked for.

## [3.1.0] — 2026-07-26

Another gap caught in real use, in the gate v3.0.0 had just wired up: the Design gate required "approved screens or wireframes," which meant markdown was sufficient to approve a UI change. On a real feature — a yearly-view redesign into pivot tables with subtotal and type-total rows — that was not enough for anyone to actually judge layout, density, or usability, and the framework had nothing better to offer at that stage. The only clickable artifact it defined, Preview, is explicitly scoped to *after* build. An agent filled the gap itself, built an ad hoc static mockup, and correctly diagnosed why the framework hadn't asked for one — but nothing should require that diagnosis in the moment.

### Added

- **The design mockup, as a first-class part of the Design gate** — `templates/design.md` gains a `Mockup` section: a static HTML/CSS/JS artifact, built with mock data, required by default for any `ui`-tagged Track B/C change. Skipping it needs a stated, checkable reason, the same "none needed, because" pattern the PR template already uses — never a silent omission.
- **`commands/design.md`** — the design gate previously had no agent contract of its own; it was a step named by `spec` with nobody responsible for actually producing the artifact a human approves. This closes that.
- **An explicit distinction between the design mockup and Preview**, spelled out as a comparison table in `standards/ui-and-preview.md`: the mockup is throwaway, static, and gates the *plan*, before any code exists; Preview is the real, built implementation and gates the *merge*, after build. Conflating the two was the actual incident this release responds to.
- **Design agent role** added to `guide/04-roles.md`; `design` added as a third operational extension (with `validate` and `preview`) in `guide/07-commands.md`.

### Changed

- `commands/spec.md` now tells the human, at spec-approval time, that a mockup is coming by default — so it isn't a surprise when the design gate is reached.
- `commands/plan.md` treats an approved mockup as authoritative for layout; the plan references it rather than re-deciding UI structure.
- `commands/build.md` verifies the mockup (or its stated exemption) as part of design approval, and warns explicitly against copying throwaway mockup markup into the real implementation — a mockup skips error handling, auth, and real data access on purpose, and that is fine for a decision aid and not fine for shipped code.
- README's lifecycle diagram gained the Design step it was missing — `diagrams/lifecycle.md` already had it; the top-level summary diagram had drifted from canonical without a script catching a *missing* node, only a *contradicting* one.
- Command count is eight everywhere it's stated (`README.md`, `.codex/AGENTS.md`, `adapters/README.md`'s conformance checklist).

### Why this happened

Found by using the framework on a real change and noticing the agent had to improvise where the gate should have had an answer. This is the same failure class as the two gaps closed in v3.0.0: a documented requirement ("approved screens or wireframes") that was real but too weak to force the outcome the framework actually wants, discovered only by running it for real. The fix follows the same shape as v3.0.0's: name the missing artifact precisely, give it a command contract, and make the thing it must not be confused with explicit rather than assumed.

## [3.0.0] — 2026-07-26

A structural change to the branching model, plus two gate gaps closed after they were caught in real use: a change carrying the `ui` tag went from spec approval straight to implementation with no design sign-off, and an implementation plan had no approval gate at all — unlike a spec, nothing stopped a build agent from treating a drafted plan as an approved one.

### Changed — breaking

- **GitFlow is now the default branching model**, reversing the v2.0.0 decision to make trunk-based the default. `main` (production) and `develop` (continuously-deployed QA integration branch) are both long-lived and protected; `feat/*`/`fix/*` branch from and merge to `develop`; `release/<version>` branches from `develop`, hardens in the QA environment, and merges to `main` under production approval; `hotfix/*` branches from `main`. Rationale: a per-PR Preview environment answers "does this one change work?" but does not answer "is the accumulated, approved state of `develop` ready to release?" — teams that need to run QA against a stable, continuously-updated target before cutting a release need a real branch for that, not just an ephemeral one per PR. See [standards/branching.md](standards/branching.md).
  - Trunk-based is still fully supported as an explicit opt-out (`repository.qa_branch: ""`, `integration_branch: main`) for projects with no persistent QA target — see [standards/branching.md#opting-out-of-develop-trunk-based-mode](standards/branching.md#opting-out-of-develop-trunk-based-mode). The framework's own manifest (`project.yaml`) uses this opt-out, since this repository has no deployable application for `develop` to serve.
  - `schemas/project.schema.json` gains `repository.release_branch_pattern` and `repository.hotfix_branch_pattern`, and `gates.plan_approval_required`.
  - `standards/worktrees.md` now describes a bare-repo layout with persistent worktrees for `main`/`develop` and documents that Track C work **requires** a worktree, not just "recommends" one.
  - `guide/03-workflow.md`'s state table gains `designed`, `plan_approved`, `merged_to_develop`, and `staged` states; the old "there is no staging branch" line is gone along with the anti-staging-branch guard in `reference/scripts/check-consistency.sh`.
  - `diagrams/deployment.md`, `diagrams/lifecycle.md`, `diagrams/environment-promotion.md`, `diagrams/quality-gates.md`, `diagrams/worktree-flow.md`, and `diagrams/document-flow.md` all updated to match.

### Added

- **Plan approval gate** — `templates/implementation-plan.md` gains an `Approval` block identical in spirit to the spec's: for Track B/C, `commands/build.md` now explicitly verifies `Approval.decision == approved` before writing any code, and stops to ask if it is not. `project.yaml`'s `gates` block gains `plan_approval_required`.
- **Design gate wired from spec, not just documented** — `commands/spec.md` now tells the spec agent to name the design gate as the explicit next step whenever the `ui` tag applies, instead of leaving `standards/ui-and-preview.md`'s existing requirement undiscoverable from the spec workflow. `templates/design.md` gains the same `Approval` block pattern as the plan and spec templates.

### Why this happened

All three gaps were found the same way: by running the framework on a real project and comparing what actually happened against what the documents said should happen. The design and plan gates were previously real requirements with no enforcement path — a human had to already know to ask for them. The branching change is a genuine reversal of a considered v2.0.0 decision, made because a real project's requirement (a persistent, testable QA environment ahead of production, not just per-PR previews) outweighed the stated cost of a second integration branch for that project's shape of work.

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
