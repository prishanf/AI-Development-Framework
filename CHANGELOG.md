# Changelog

## [Unreleased]

### Changed

- **Lifecycle docs make feature-branch timing explicit.** Spec and plan are committed on the integration branch (`develop` by default) before Isolate; the `feat/*` / `fix/*` branch is cut only after plan approval. Clarified in [guide/03-workflow.md](guide/03-workflow.md) and [standards/branching.md](standards/branching.md); [diagrams/lifecycle.md](diagrams/lifecycle.md), the README summary diagram, and [diagrams/worktree-flow.md](diagrams/worktree-flow.md) now show Isolate as its own step.
- **How a human starts is explicit.** [guide/03-workflow.md](guide/03-workflow.md) gains a kickoff section with Track A / B / C prompt examples and expected agent responses. Discover is a human action; lifecycle and AI/human diagrams begin with “human states problem”; [`commands/spec.md`](commands/spec.md) states the human invokes the role.

### Added

- **[diagrams/ai-human-flow.md](diagrams/ai-human-flow.md)** — swimlane of which lifecycle activities AI, human, and CI lead, with a cheat-sheet table (including the Discover kickoff). Complements [diagrams/responsibility-matrix.md](diagrams/responsibility-matrix.md).

## [5.1.1] — 2026-07-29

### Fixed

- **Design mockups are one package per product surface, not one copy per feature.** The `design` command told agents to `copy reference/mockup/` for every `ui` change, which produced duplicated `tokens` / `shell` / `seed` trees when successive features extended the same screen (seen on AIDF Quick Notes Features 1–3). Agents must now **extend** an existing mockup package for the same surface; copy the scaffold only for a first package or a genuinely new screen. Prefer a symlink for `css/tokens.css` to `ui.tokens`. Updated: `commands/design.md`, `standards/ui-and-preview.md`, `reference/mockup/README.md`, `templates/design.md`.

## [5.1.0] — 2026-07-29

### Added

- **`/ship` requires an annotated version tag matching release notes.** Shipping a real project (AIDF Quick Notes v0.1.0) produced release notes and a `main` cut with no git tag — the framework never asked for one. Release notes front-matter `version` is now the intended annotated tag name. Default `ship` remains docs-only; when a human authorizes the production cut, the agent creates and pushes that tag on the production tip (no move/force-update if the name already points elsewhere). Release-time gates, branching rules, workflow `released` exit evidence, release-notes and deployment-record templates, and the release-agent role all name the same rule.

## [5.0.2] — 2026-07-28

### Fixed

- **The version files now report 5.0.1.** The 5.0.1 entry below landed without the bump that goes with it, leaving `VERSION`, `README.md`, `AGENTS.md`, `project.yaml`, and `templates/project.yaml` all claiming 5.0.0. `templates/project.yaml` matters most of the five: it seeds `framework.version` for every new install, so a fresh project would have pinned 5.0.0 while vendoring a 5.0.1 tree and reported a mismatch on its first gate run. `check-consistency.sh` compares `VERSION` against the other four and passes again.

## [5.0.1] — 2026-07-27

### Fixed

- **`validate-evidence.sh` no longer rejects human `not_run` gates on PR CI.** `run-gates.sh` records `pr-approval` (and other human-only gates) as `not_run` because CI cannot satisfy them; treating that as a failed evidence contract made every PR fail `Enforce evidence contract`. Automated `not_run` still fails closed. `self-test.sh` covers both cases.
- **Installed projects no longer run framework-only `check-consistency.sh` in CI.** `reference/github/workflows/aidf-selfcheck.yml` (copied by `aidf-install.sh`) now validates `project.yaml` only. The full consistency + self-test + Mermaid suite stays in the framework repository's `.github/workflows/aidf-selfcheck.yml`. `check-consistency.sh` exits early with a clear message when run from a vendored `.aidf/` tree (no `diagrams/`), instead of `FileNotFoundError` on `diagrams/lifecycle.md`.

## [5.0.0] — 2026-07-27

Five gaps found by shipping a real feature with v4.0.0 — a personal income/expense tracker built end to end — and then reading what the framework had actually produced. Four of the five are visible as concrete artifacts in that repository, which is the point: each was a rule the framework stated loosely enough to be satisfied without being met.

### Changed — breaking

- **The framework installs as one vendored directory.** `reference/scripts/aidf-install.sh` copies the runtime subset into a project's `.aidf/` and wires up `AGENTS.md`, `project.yaml`, `.github/`, the adapter files, and the `docs/` tree. Previously, adopting AIDF meant cloning it, which left `commands/`, `guide/`, `reference/`, `schemas/`, `standards/`, `templates/`, and `adapters/` in the project root next to `app/`, `server/`, and `docs/` — seven framework directories interleaved with the project's own, with nothing marking which was which. The mental model is now explicit: **`.aidf/` is framework input, `docs/` is project output.**
  - `framework.root` added to the manifest and schema (`.aidf` by default; empty in this repository).
  - `--upgrade` refreshes the vendored tree and touches nothing project-owned. Project-owned files are never silently overwritten without `--force`.
  - `guide/`, `standards/`, `commands/`, `templates/`, `schemas/`, `reference/`, and `adapters/` are vendored. `diagrams/`, `examples/`, and the changelog are not — a project does not need them. `check-consistency.sh` now enforces that the vendored set is **closed under linking**, so a link from a vendored file to an excluded one fails the build here rather than breaking silently in every installed project.
  - `run-gates.sh` and `validate-evidence.sh` now prefer the manifest in the working directory. Under `.aidf/`, the script's own root is not the project root.
- **`api`: an endpoint with no HTTP-level test is a failing gate.** The tag required "contract and authorization tests", and that phrasing turned out to be satisfiable without touching an endpoint. In the real project it was: fourteen routes added, three unit tests written against the pure helper functions those routes call, every gate green, and not one HTTP request in the suite. [standards/testing.md](standards/testing.md) now states the rule mechanically — *a unit test of a handler's helpers is not endpoint coverage* — with a required-case matrix per endpoint (2xx with asserted body, validation per field, 401, 403 per object, 404, cross-tenant, conflict, unknown fields, pagination bounds, write replay, error shape).
  - `reference/scripts/check-api-coverage.sh` enforces it: enumerates routes from `api.route_globs`, fails when one has no test referencing it, and fails again when the only matching test makes no HTTP request. Wired into `run-gates.sh` for the `api` tag. It fails closed when unconfigured.
  - [templates/api-contract.md](templates/api-contract.md)'s four unchecked boxes are replaced by an endpoint inventory and a per-endpoint test matrix, with explicit places to record `n/a` reasons and honest automation gaps.
- **`database`: a data model document is required.** `templates/architecture.md` declared itself required when "a stable boundary, data model, or deployment topology changes" and then contained no data model section at all — only prose "Data flow". The real project's agent improvised an ERD anyway, which is luck, not a contract.
- **Track B/C requires a project changelog entry.** The framework keeps its own [CHANGELOG.md](CHANGELOG.md) so a reader can see what changed without diffing every file; an installed project had no equivalent, and nothing recorded what a release did beyond git log — which is commit-message discipline, not a reviewable record. `reference/scripts/check-changelog.sh` fails Track B/C when source changed but the project's `CHANGELOG.md` didn't; Track A is exempt, so trivial changes aren't forced into meaningless entries. It fails closed on paths that matter and exempts the vendored framework, `.github/`, lockfiles, and `.gitkeep` files. Wired into `run-gates.sh`.
  - `reference/scripts/aidf-install.sh` now scaffolds a project `CHANGELOG.md` (Keep a Changelog style, `[Unreleased]` seeded) on fresh install.
  - `documents.changelog` added to the manifest (`CHANGELOG.md` by default).

### Added

- **[templates/data-model.md](templates/data-model.md)** — conceptual model, crow's-foot ERD, per-table data dictionary (type, nullability, default, constraint, **data class**, meaning), indexes with the query each serves, referential actions, enumerations, derived values, identity and multi-tenancy, authorization mapping, integrity invariants, volume and growth, classification/retention/erasure, and migration mapping. An unclassified column defaults to `sensitive` — deliberately the inconvenient default.
- **[templates/ui-foundation.md](templates/ui-foundation.md)** — the first `ui`-tagged change decides the product's palette, typeface, spacing rhythm, component vocabulary, and responsive behaviour for every feature after it, whether or not anyone intends it to. This makes that a decision instead of an accident: brand basics, semantic colour roles with **measured** contrast ratios, type scale with a font-loading strategy, spacing/radius/elevation/motion/z-index scales, named breakpoints, the component inventory (including the empty, loading, and error states agents skip), the accessibility baseline, and date/currency/number conventions. Durable and shared — extended by later `ui` changes, never re-derived.
- **Tailwind as the declared default CSS framework**, via `ui.css_framework`. The mechanism that matters more than the choice is the **token layer** (`ui.tokens`): design values live once as CSS custom properties, Tailwind is wired to them, and *the application and the design mockup read the same file*. In the real project the app ended up with hand-rolled CSS variables **and** a `tailwind.config.ts` while the mockup used neither — three visual languages for one feature.
- **[reference/mockup/](reference/mockup/)** — a working, copy-ready mockup scaffold, and a required structure in [standards/ui-and-preview.md](standards/ui-and-preview.md): one file per screen, shared `css/` and `data/`, fixtures in JSON at realistic volume, a visible fixture reset, and `serve.sh`. A mockup must **run over HTTP**: fetching local fixtures fails under `file://`, and the reviewer reports the prototype as broken. `commands.mockup_serve` added to the manifest so the handoff names a command instead of a paragraph.
  - The scaffold ships two screens, all five states, 32 fixture rows, a dark theme, and the Tailwind wiring notes — including three `@tailwindcss/browser` behaviours that each fail silently and cost real debugging time to find.
- `ui` and expanded `api` blocks in the manifest and schema; `documents.data_model`; `database.data_model_required`.
- New rows in the PR-time gate table for endpoint coverage, data model currency, and UI foundation approval; new document rows in [guide/05-documents.md](guide/05-documents.md).

### Changed

- `commands/design.md` detects whether this is the project's first `ui` change and produces the UI foundation alongside the design; it also follows the mockup structure contract rather than inventing one.
- `commands/plan.md` and [templates/implementation-plan.md](templates/implementation-plan.md) gain **UI foundation** and **API surface** sections, and a "Data and migration" section that must be answered field by field rather than in a sentence. The plan must now name, per endpoint, the test file that will exercise it — if it cannot, the plan is not ready.
- `commands/build.md` requires the token layer to land before the first component, forbids raw colour/size/spacing values outside it, requires denied-path endpoint tests, and requires a changelog entry under `[Unreleased]` for Track B/C.
- [standards/quality-gates.md](standards/quality-gates.md)'s PR-time table gains a "Changelog entry under `[Unreleased]`" row: optional for Track A, required for B/C.
- `adapters/README.md`: the installer now generates the Claude Code, Codex, and Cursor wiring. The framework repository still ships no vendor command surface; an installed project gets a working one.

### Why this happened

Same failure class as v3.1.0 and v4.0.0, and worth naming a third time: each of these was a requirement that existed in prose and was too weak to force the outcome. "Contract and authorization tests" did not say *through the router*. "Required when the data model changes" did not say *what a data model document contains*. "Use the project's design tokens where the project has them" did not say *who creates them, or when*. "A static HTML/CSS/JS artifact" did not say *runnable, or shared, or with what data*.

The pattern in the fix is also the same: name the artifact precisely, give it a template, and make it mechanically checkable where a script can do it. `check-api-coverage.sh` cannot judge whether a test asserts anything — but the failure that actually happened was an *absent* test, and that a script can catch.

### Migrating from 4.x

```bash
# from a clone of the framework, in your project's directory
sh /path/to/ai-development-framework/reference/scripts/aidf-install.sh --target . --upgrade
```

Then, in your project:

1. Move the old top-level framework directories out of your project root — `commands/`, `guide/`, `reference/`, `schemas/`, `standards/`, `templates/`, `adapters/` are now under `.aidf/`. Update any path that referenced them, including `.github/workflows/` and `.claude/commands/`.
2. Add `framework.root: .aidf` to `project.yaml`, and set `framework.version: 5.0.0`.
3. Add the `ui` block and point `ui.tokens` at your token layer. If you do not have one, that is the finding: create it, and write `docs/design/ui-foundation.md` before the next `ui` change.
4. Add `api.route_globs` and `api.test_globs`. Then run `check-api-coverage.sh` and expect it to fail — that result is the honest state of your endpoint coverage, not a script problem.
5. For any persistent state you already have, write `templates/data-model.md` once, from the schema you have, and classify every column.

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
