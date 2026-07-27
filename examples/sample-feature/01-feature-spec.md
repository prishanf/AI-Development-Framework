---
type: feature-spec
status: approved
owner: product@example.test
created: 2026-07-20
updated: 2026-07-21
issue: "#142"

classification:
  track: C
  risk: high
  tags: [ui, api, database, security]
---

# Feature: Saved searches

## Problem

Frequent users repeat the same filters and lose time rebuilding them. They need a fast way to save and rerun a search without creating a separate report.

## Desired outcome

An authenticated user can save a named search, see their saved searches, and rerun or delete one. Results always reflect current permissions and current data.

## In scope

- Save the current filter state with a user-owned name.
- List, run, rename, and delete the user’s saved searches.
- Re-evaluate authorization when a saved search is run.

## Out of scope

- Sharing searches with other users.
- Scheduled email delivery.
- Cross-tenant or administrator-managed searches.

## Acceptance criteria

- [x] A user can save a valid search with a name from 1–80 characters.
- [x] A saved search can be rerun from the dashboard.
- [x] Unauthorized records are excluded at run time.
- [x] Duplicate names are allowed because identity is by ID, not name.
- [x] The user can rename and delete their own saved searches.
- [x] Empty, loading, validation-error, and unauthorized states are defined.

## Constraints and risks

- Data/security: saved filters are private to the owning user and tenant.
- Performance: list endpoint should return in under 200 ms at p95 for 100 saved searches.
- Rollback: disable the UI action and leave records inert; the table can be retained for rollback.

## Approval

- Decision: `approved`
- Approver: Product owner and security reviewer
- Date: 2026-07-21
- Notes: Authorization is evaluated at query execution time.
