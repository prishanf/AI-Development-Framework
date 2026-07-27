---
type: threat-model
status: approved
owner: security@example.test
created: 2026-07-21
updated: 2026-07-23
related-change: ./02-issue.md
---

# Threat model: Saved searches

## Scope and assets

Saved filters, search criteria, user identity, tenant boundary, and the search results returned when a saved search runs.

## Trust boundaries

| Boundary | Data / action crossing | Controls |
|---|---|---|
| Browser to API | Filter and name input | Schema validation, session authentication |
| API to database | Owner/tenant filter persistence | Parameterized queries, tenant predicate |
| Saved search rerun | Filter to result query | Current authorization-aware query builder |

## Abuse cases

| Threat | Impact | Mitigation | Verification |
|---|---|---|---|
| Guess another saved-search ID | Cross-tenant data access | Owner and tenant checks on every action | Integration denial test |
| Permission revoked after save | Stale unauthorized results | Authorization applied at rerun | Manual and automated test |
| Oversized filter payload | Resource pressure | Input-size limit | API validation test |

## Approval

- Reviewer: Security reviewer
- Decision: `approved`
- Date: 2026-07-23
