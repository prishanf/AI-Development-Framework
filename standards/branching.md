# Branching

The default model is trunk-based: a protected `main` branch and short-lived feature branches. There is no staging branch and no `staged` lifecycle state by default.

A project may add a `qa` branch, but it must configure `repository.qa_branch` in the manifest and record why. Adding one is a real cost — a second integration point that drifts from `main` and must be reset — and a Preview environment on the pull request solves most of what teams reach for it to solve.

## Branches

| Branch | Meaning | Protection |
|---|---|---|
| `main` | Production-ready history | Protected; PR, checks, release approval |
| `feat/<issue>-<slug>` | Feature or bounded change | Short-lived; linked to issue |
| `fix/<issue>-<slug>` | Non-emergency defect fix | Same as feature |
| `hotfix/<issue>-<slug>` | Production emergency | Maintainer approval and follow-up ADR if needed |
| `qa` (optional) | Explicit multi-change QA only | Protected; resettable and time-bounded |

## Commit guidance

Commits should be coherent and reversible. Use imperative subjects and include the issue key when the host supports it. Do not use commits to disguise unrelated changes.

## Pull request rules

- Link the approved spec and issue (Track B and C).
- **Link** verification evidence — the CI run and its check identifiers. Do not restate results in prose; see [evidence.md](evidence.md).
- Keep scope within the issue or explain a necessary deviation.
- Require the configured human review for protected branches.
- Require an approval for every PR, plus UI QA sign-off when a `ui` tag applies.
- Respect the size budget in [quality-gates.md](quality-gates.md): past ~400 changed lines, split the PR or justify it.
- Squash or preserve commits according to project policy, but retain the PR as the primary change record. **The PR is the implementation record** — do not write a second narrative document describing the same change.

## Emergency changes

Hotfixes may shorten the normal path, not remove accountability. Record the incident, verification, rollback path, and follow-up documentation before closing the work.
