---
type: implementation-plan
status: complete
owner: engineering@example.test
created: 2026-07-21
updated: 2026-07-23
spec: ./01-feature-spec.md
issue: ./02-issue.md
branch: feat/142-saved-searches
---

# Implementation plan: Saved searches

## Repository findings

| Area | Finding | Evidence |
|---|---|---|
| Search filters | Existing filters serialize to JSON | `src/search/filters.ts:18` |
| API | Search routes use tenant middleware | `src/api/search.ts:11` |
| UI | Dashboard has a saved-items panel placeholder | `src/pages/search.tsx:92` |
| Tests | API integration harness supports tenant fixtures | `test/api/search.test.ts:24` |

## Change map

| File or area | Change | Why |
|---|---|---|
| `db/migrations/014_saved_searches.sql` | Add table and owner indexes | Persist private filters |
| `src/api/saved-searches.ts` | Add CRUD endpoints | Expose feature |
| `src/search/run.ts` | Reuse authorization-aware query builder | Enforce runtime permissions |
| `src/pages/search.tsx` | Add save and dashboard controls | User workflow |
| `test/api/saved-searches.test.ts` | Add CRUD and tenant isolation cases | Evidence |

## Sequence

1. Add migration and repository model.
2. Add API with ownership and tenant checks.
3. Add UI controls and all states.
4. Add integration and component tests.
5. Run format, typecheck, tests, and build.

## Verification plan

- Unit: `pnpm test saved-searches`
- Static: `pnpm lint && pnpm typecheck`
- Build: `pnpm build`
- Manual: save, rerun, rename, delete; verify a cross-tenant record is absent.

## Completion checklist

- [x] Scope matches approved spec.
- [x] Tests added.
- [x] Verification recorded.
- [x] Documentation decision made.
