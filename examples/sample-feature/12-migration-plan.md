---
type: migration-plan
status: approved
owner: engineering@example.test
created: 2026-07-21
updated: 2026-07-23
issue: ./02-issue.md
spec: ./01-feature-spec.md
---

# Migration plan: Saved searches persistence

## Change summary

Add an additive `saved_searches` table with owner and tenant indexes. Existing search behavior is unchanged.

## Migration artifacts

| Order | Path | Type | Forward-compatible? |
|---|---|---|---|
| 1 | `db/migrations/014_saved_searches.sql` | SQL | yes |

## Compatibility sequence

1. Expand: create table and indexes without changing existing tables.
2. Deploy: application begins writing and reading saved searches.
3. Backfill: none.
4. Contract: none.

## Preview validation

- Baseline/state source: approved production clone with controlled access.
- Seed profile: `search-tenants-v3` — defined in the "Seed profile" section below.
- Verification: migration applies, cross-tenant reads are denied, indexes support list queries.

## Production execution

- Recovery point: approved database snapshot before migration.
- Migration role: dedicated migration role.
- Rollback / forward fix: disable UI action; keep additive table intact; use a forward migration if correction is required.
