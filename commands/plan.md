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

If the change is tagged `ui`, treat the approved design and its mockup as authoritative
for layout and flow — reference specific screens/states from it in the change map
rather than re-deciding UI structure in the plan. If the plan reveals the mockup missed
something material, say so and send it back to the design gate; do not quietly design
around it here.

Flag any mismatch between the approved spec and the repository.

For Track B and Track C, the plan's `Approval` block is a hard gate, not a
recommendation: leave `Approval.decision` as `pending` and tell the human explicitly
that implementation must not begin until they set it to `approved`. Track A has no
plan document and this gate does not apply to it.

Return: plan, assumptions, risks, files to inspect or change, and the explicit
statement that build must wait for plan approval (Track B/C) or that no plan approval
gate applies (Track A).
```

## Completion criteria

- The plan names likely files and tests.
- The sequence is incremental and reversible.
- Verification is concrete and uses the manifest's commands.
- Assumptions are listed separately from findings.
- Scope drift and classification mismatches are surfaced, not absorbed.
- For Track B/C, `Approval.decision` is left `pending` and the response states plainly that build must wait for it.
