---
type: release-notes
version: v1.8.0
date: 2026-07-25
status: published
---

# Search improvements — v1.8.0

## Highlights

- Users can save and rerun frequent searches from the dashboard.

## Added

- Private saved searches with rename and delete actions.
- Runtime permission filtering on every rerun.

## Upgrade notes

- Migration: additive `saved_searches` table; run standard migrations.
- Compatibility: no API breaking changes.
- Rollback: disable the feature flag and leave records in place for re-enable.

## References

- PR: [05-pull-request.md](05-pull-request.md)
- ADR: [07-adr.md](07-adr.md)
