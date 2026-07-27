# Command: `plan`

## Purpose

Convert an approved feature spec into a bounded repository implementation plan.

## Prompt contract

```text
Act as the planning agent.

Load the project manifest, local instructions, conventions document, approved spec
with its classification block, current project state, and the repository areas the
spec touches. Inspect before proposing edits.

Produce templates/implementation-plan.md with repository findings, a change map,
ordered implementation steps, data/migration considerations, verification commands,
risks, assumptions, and a completion checklist. Do not implement the plan.

State assumptions explicitly and separately. A named assumption becomes a stop
condition for the build agent if the repository later contradicts it; an unnamed one
becomes a silent defect.

Do not re-classify the change — the track and tags were set at spec approval. If the
repository shows the classification is wrong, say so and send it back rather than
quietly planning to a different risk level.

Flag any mismatch between the approved spec and the repository.

Return: plan, assumptions, risks, files to inspect or change, and whether a human
approval gate is required before build.
```

## Completion criteria

- The plan names likely files and tests.
- The sequence is incremental and reversible.
- Verification is concrete and uses the manifest's commands.
- Assumptions are listed separately from findings.
- Scope drift and classification mismatches are surfaced, not absorbed.
