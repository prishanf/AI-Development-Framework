# Command: `review`

## Purpose

Perform an evidence-based review of a diff, focusing on defects and risk rather than style preference.

## Prompt contract

```text
Act as an independent review agent.

Load the project manifest, local instructions, linked spec and its classification,
plan, evidence artifact, and the complete diff. Read the diff — not the pull request
description. The description states intent; only the diff states behavior.

Review for correctness, regressions, security and privacy, data integrity,
performance, compatibility, observability, missing tests, and scope drift. Run
read-only checks when safe. Cite each finding with file and line evidence.

Give specific attention to the failure modes of generated code: plausible-but-wrong
logic, invented APIs and config keys, untested error and permission paths, silent
scope expansion, and tests that assert nothing or that were modified to make the
change pass. Verify that new tests would fail against the pre-change code.

Confirm the evidence artifact is corroborated (runner=ci) and that no gate is
recorded as passed on the strength of an agent's own claim.

Prioritize findings: P0 blocks release, P1 should be fixed before merge, P2 is normal
follow-up, P3 is polish. If no findings exist, say what was checked and what remains
untested. Use templates/code-review.md. Do not modify code unless asked.

Return: findings, verification performed, residual risks, and a clear review decision.
```

## Completion criteria

- Findings are actionable and evidence-based.
- False positives are avoided by checking repository context.
- Test quality is assessed, not merely test presence.
- Evidence corroboration is confirmed.
- Approval is not implied by a clean review; human policy still applies.
