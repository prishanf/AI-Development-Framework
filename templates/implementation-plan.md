---
type: implementation-plan
track: B
required_when: "every Track B and Track C change"
status: draft
owner: ""
created: YYYY-MM-DD
updated: YYYY-MM-DD
spec: ""
issue: ""
branch: ""
---

# Implementation plan: <short name>

## Goal and boundaries

<Restate the approved outcome and non-goals.>

## Repository findings

| Area | Finding | Evidence |
|---|---|---|
| Existing behavior | <what exists> | `<file>:<line>` |
| Integration point | <where change belongs> | `<file>:<line>` |
| Test coverage | <current coverage> | `<test file>` |

## Change map

| File or area | Change | Why |
|---|---|---|
| `<path>` | <add/edit/remove> | <reason> |

## Sequence

1. <small reversible step>
2. <implementation step>
3. <test and verification step>

## Data and migration

<Schema changes, backfill, compatibility, or “none”.>

## Verification plan

- Unit: `<command or test>`
- Integration: `<command or test>`
- Static: `<command>`
- Manual: <steps and expected result>

## Risks and assumptions

- Assumption: <assumption>
- Risk: <risk>; mitigation: <mitigation>

## Completion checklist

- [ ] Scope matches approved spec.
- [ ] Tests added or updated.
- [ ] Verification commands recorded.
- [ ] Documentation decision made.
- [ ] PR evidence prepared.
