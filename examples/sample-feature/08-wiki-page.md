---
type: wiki-page
status: current
owner: engineering@example.test
updated: 2026-07-24
audience: developer
---

# Saved searches

## Summary

Saved searches contain a user’s normalized filter definition. They are private to the owner and tenant, and permissions are checked again every time a search is run.

## When to use this

Use the saved-search repository and authorization-aware query builder for this feature. Do not read stored result IDs as an authorization shortcut.

## Troubleshooting

| Symptom | Likely cause | Resolution |
|---|---|---|
| Search returns fewer results later | Permissions or source data changed | Expected; rerun uses current access |
| Save button disabled | Invalid or empty filter | Complete a valid search first |
| Slow rerun | Expensive filter | Inspect query plan and monitor p95 latency |

## Related

- ADR: [07-adr.md](07-adr.md)
- Release: [09-release-notes.md](09-release-notes.md)
