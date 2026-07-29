# 03 — Development Workflow

**This file is the canonical definition of the AIDF lifecycle.** The README diagram and every file in `diagrams/` are derived from it. Where any other document appears to describe a different sequence, this one is correct and the other is a defect.

The lifecycle below is the full Track C path. Track B skips the tag-driven artifacts; Track A skips steps 2–8 and begins at **Isolate** (step 9). See [02-tracks.md](02-tracks.md).

## How a human starts

The human starts the process — not the agent, and not by opening a feature branch.

1. **State the problem** in plain language (chat with an agent, a short note, or an issue draft). One or two sentences about who is stuck and what “better” looks like is enough. You do not need a full spec yet.
2. **Invoke the right first role:** for a behavior change, ask for **`spec`** (or paste the problem and say “start with a feature spec”). For an obvious non-behavioral fix (typo, comment, formatting), say it is **Track A** and skip to a PR branch — no spec.
3. **Expect questions, not code.** On Track B/C the agent returns a draft spec, a recommended track/tags, open questions, and the next human decision. Approve (or correct) that before any feature branch or implementation.

Do **not** cut `feat/*` at the start. Do **not** expect the agent to invent product scope silently. An issue linked to the approved spec comes later (step 6).

### Start examples

**Track A — trivial typo**

> Fix the typo in `README.md`: “recieve” → “receive”. This is Track A — no behavior change.

*What to expect:* No spec or plan. Agent creates a short-lived branch, makes the one-line fix, opens a PR to `develop`, runs AI review, and waits for human approval.

**Track B — standard product change**

> Frequent users rebuild the same search filters every time. They should be able to save a named search and rerun it from the dashboard. Please start with a feature spec — don’t implement yet.

*What to expect:* Agent drafts a spec (problem, outcome, in/out of scope, acceptance criteria), recommends Track B with tags such as `ui` and `api`, and asks only questions that could change scope or risk. You answer, then approve the spec. If `ui` is tagged, design + mockup comes next; otherwise planning. The feature branch still does not exist.

**Track C — high risk / unclear boundary**

> We need to store customer payment methods for faster checkout. I’m not sure how much of this is schema vs API vs UI. Start with a spec and classify the risk — don’t write migrations yet.

*What to expect:* Agent inspects the repo lightly, drafts a spec, and likely recommends Track C with tags such as `database`, `api`, and `security`. It asks clarifying questions (who can read/write cards, PCI boundary, retention). You approve classification and scope before plan, migrations, or a feature branch.

## Lifecycle

1. **Discover** — the human states the problem and invokes the first role (`spec`, or Track A straight to Isolate). Capture only enough context to classify and specify; do not implement. Exit when a problem statement exists and the next command is clear.
2. **Specify** — draft a feature spec; ask questions where facts or intent are missing. Commit the draft (and later the approved revision) on the integration branch — `develop` by default — **before** any feature branch exists. Spec and plan are not first committed on `feat/*`.
3. **Classify** — assign track, risk level, and tags in the spec front matter. This happens **once**, here, as part of the spec. Nothing downstream re-classifies.
4. **Approve** — a human accepts the problem, outcome, scope, classification, and risk posture.
5. **Design** *(ui tag only)* — produce `templates/design.md`: flow, every required state, and — by default — a clickable static mockup built with mock data, distinct from and earlier than the Preview environment in step 12. A human design/product owner approves the design and mockup together before planning begins. Skipped when the `ui` tag is absent. See [standards/ui-and-preview.md](../standards/ui-and-preview.md).
6. **Track** — create or update the issue with a link to the approved spec (and design, if produced).
7. **Plan** — inspect the repository, identify files and dependencies, write an implementation plan. Like the spec, commit it on `develop` (or the project's integration branch) while it is still draft and again when approved — still **before** Isolate.
8. **Approve plan** — for Track B and C, a human approves the implementation plan before any code is written. Track A has no plan document and skips this step.
9. **Isolate** — **this is when the feature branch is created.** Cut `feat/<issue>-<slug>` (or `fix/...`) off `develop` (`hotfix/...` off `main`), and add a worktree — see [standards/worktrees.md](../standards/worktrees.md) and [standards/branching.md](../standards/branching.md). Do not create the feature branch earlier to hold the spec or plan. Under the default GitFlow model this is not optional busywork: `develop` and `main` are long-lived worktrees off a shared bare clone, and every feature/fix/release/hotfix branch gets its own sibling worktree.
10. **Build** — on the branch from step 9, implement in small increments, adding tests and updating the plan as facts change.
11. **Verify** — run the track's required checks and emit evidence.
12. **Preview** — deploy isolated state and complete UI QA. Required only for `ui`, `api`, and `database` tags.
13. **Open PR** — open the pull request to `develop` with linked evidence. The build agent's next action is `review`, not a human handoff.
14. **AI review** — the review agent inspects the diff, publishes findings on the PR, and — when P0/P1 findings exist — hands remediation to `build`. The loop repeats until blocking findings are fixed or explicitly accepted. The review agent then posts a final PR comment that AI review is complete and human review may begin. AI review never satisfies the human approval gate. See [`commands/review.md`](../commands/review.md).
15. **Human review** — every PR receives an authorized human approval; remaining findings are resolved or accepted with evidence. Merges to `develop`.
16. **Release** — when the release scope on `develop` is complete, cut `release/<version>`, harden and sign off in the QA environment, obtain production approval, merge to `main` under protected-branch policy, create and push an annotated git tag whose name equals the release notes `version` on that tip, deploy through CI, observe, back-merge to `develop`, and update durable documents.

Classification (step 3) precedes planning deliberately: the plan cannot know which gates apply until the track is fixed. Design (step 5) precedes planning for the same reason applied to UX: a plan built against an unapproved screen is a plan for the wrong feature. Isolate (step 9) comes **after** plan approval for the same reason applied to Git: a feature branch that exists only to hold unapproved paperwork is the wrong place for durable intent, and implementation must not start until that intent is approved.

### Where documents and code land

| Artifact | Lifecycle steps | Lands on |
|---|---|---|
| Feature spec (and design, if `ui`) | 2–5 | Integration branch (`develop` by default) |
| Implementation plan | 7–8 | Integration branch (`develop` by default) |
| Implementation, tests, PR | 9–15 | Feature/fix branch off `develop` (hotfix off `main`) |

Track A skips steps 2–8 and begins at Isolate (step 9) for the change itself.

## State transitions

| State | Entry requirement | Exit evidence | Owner |
|---|---|---|---|
| `idea` | Human stated a problem and chose the first role (`spec` or Track A) | Draft spec (B/C) or ready to Isolate (A) | Human requester; spec agent may draft |
| `specified` | Spec complete and classified | Human approval | Human product owner |
| `designed` *(ui tag only)* | Spec approved, `ui` tag present | Human approval of design **and mockup** together (or a stated reason the mockup was skipped) | Human design/product owner |
| `planned` | Approved spec (and design, if `ui`) and repository inspection | Implementation plan | Planning agent |
| `plan_approved` *(Track B/C)* | Implementation plan drafted | Human plan approval | Human product/tech owner |
| `in_progress` | Branch and worktree exist off `develop` (or `main` for a hotfix) | Code + tests | Build agent |
| `verified` | Implementation complete | Corroborated check results | Build agent + CI |
| `previewed` | Preview validation completed *(tagged changes only)* | UI QA sign-off when `ui` applies | QA reviewer |
| `ready_for_review` | Verification complete | PR with linked evidence | Build agent |
| `ai_reviewing` | PR is open | AI findings published on the PR; P0/P1 fixed or accepted; ready-for-human comment posted | Review agent (+ build for remediation) |
| `reviewing` | AI review marked ready for human | Human findings resolved or accepted; authorized approval recorded | Human reviewers |
| `merged_to_develop` | PR approved | Deployed to the QA environment | Maintainer / CI |
| `staged` | `release/<version>` cut from `develop` | QA hardening sign-off | Release owner |
| `released` | Merged to `main` and production-approved | Release notes, annotated version tag on `main`, and state update | Maintainer / CI |

The `staged` state and a release branch **are** part of the default model — see [standards/branching.md](../standards/branching.md). A project that opts out of `develop` (trunk-based mode) collapses `merged_to_develop`, `staged`, and `released` into a single `released` state after merge to `main`, and records that deviation in its own documentation.

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
