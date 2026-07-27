# 03 — Development Workflow

**This file is the canonical definition of the AIDF lifecycle.** The README diagram and every file in `diagrams/` are derived from it. Where any other document appears to describe a different sequence, this one is correct and the other is a defect.

The lifecycle below is the full Track C path. Track B skips the tag-driven artifacts; Track A skips to step 8. See [02-tracks.md](02-tracks.md).

## Lifecycle

1. **Discover** — capture the problem and the relevant repository context.
2. **Specify** — draft a feature spec; ask questions where facts or intent are missing.
3. **Classify** — assign track, risk level, and tags in the spec front matter. This happens **once**, here, as part of the spec. Nothing downstream re-classifies.
4. **Approve** — a human accepts the problem, outcome, scope, classification, and risk posture.
5. **Track** — create or update the issue with a link to the approved spec.
6. **Plan** — inspect the repository, identify files and dependencies, write an implementation plan.
7. **Isolate** — create a branch, and a worktree when parallel or risky work benefits from isolation.
8. **Build** — implement in small increments, adding tests and updating the plan as facts change.
9. **Verify** — run the track's required checks and emit evidence.
10. **Preview** — deploy isolated state and complete UI QA. Required only for `ui`, `api`, and `database` tags.
11. **Review** — every PR receives an authorized human approval; resolve findings with evidence.
12. **Release** — merge under protected-branch policy, obtain production approval, deploy through CI, observe, and update durable documents.

Classification (step 3) precedes planning deliberately: the plan cannot know which gates apply until the track is fixed.

## State transitions

| State | Entry requirement | Exit evidence | Owner |
|---|---|---|---|
| `idea` | Problem statement exists | Draft spec | Requester / spec agent |
| `specified` | Spec complete and classified | Human approval | Human product owner |
| `planned` | Approved spec and repository inspection | Implementation plan | Planning agent |
| `in_progress` | Branch/worktree exists | Code + tests | Build agent |
| `verified` | Implementation complete | Corroborated check results | Build agent + CI |
| `previewed` | Preview validation completed *(tagged changes only)* | UI QA sign-off when `ui` applies | QA reviewer |
| `ready_for_review` | Verification complete | PR with linked evidence | Build agent |
| `reviewing` | PR is open | Findings resolved or accepted | Reviewers |
| `released` | Merged and production-approved | Release notes and state update | Maintainer / CI |

There is no `staged` state and no staging branch in the default model. The default is trunk-based; see [standards/branching.md](../standards/branching.md). A project that configures `repository.qa_branch` adds a `staged` state between `reviewing` and `released`, and documents why in its manifest.

## Core operating rule

When new information invalidates the approved scope, stop implementation and return to the spec or plan. Do not silently expand the change.

## Stop conditions

An agent must stop and hand back to a human when any of these occur. Stopping is a successful outcome; a silent retry loop is not.

- **The same check fails three times.** Three attempts at one failing test, build, or lint error is the limit. Report the failure, what was tried, and the current hypothesis. Do not disable the check, mark the test skipped, or loosen the assertion to proceed.
- **A plan assumption is proved wrong.** The plan named an assumption; the repository contradicts it. Return to the plan.
- **The change would need a higher track.** Schema, authorization, secrets, or production configuration turn out to be in scope. Re-classify before continuing.
- **A required input is missing.** No approved spec, no manifest, an unreadable dependency, an environment that will not provision.
- **The next step is destructive, external, or irreversible** and is not covered by explicit project authorization.
- **Scope has grown past the acceptance criteria** and the extra work is not incidental.

On stopping, report: what was completed, what is in a partial state, exactly what failed with evidence, what was tried, and the specific decision needed to proceed.

## Working in an existing codebase

Most AI-assisted work is not greenfield. Before the first edit in an unfamiliar area:

- Read the project's conventions document ([templates/conventions.md](../templates/conventions.md)) if one exists. If it does not, writing it is a legitimate first contribution.
- Identify the nearest existing implementation of the same kind of thing and follow it, including its test style.
- Prefer the codebase's actual patterns over the patterns you would choose. A consistent codebase is worth more than a locally optimal file.
- If existing patterns conflict with each other, name the conflict in the plan rather than picking silently.

## Verification minimum

Every PR reports:

- changed files and why;
- checks run, with **corroborated** pass/fail status — see [standards/evidence.md](../standards/evidence.md);
- behavior not covered by automation;
- security, data, performance, and compatibility considerations;
- remaining risks and rollback approach.

Self-reported check results do not satisfy a gate. The agent's job is to produce artifacts a runner can corroborate, not to assert outcomes.
