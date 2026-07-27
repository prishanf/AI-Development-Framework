---
type: pull-request
status: merged
issue: ./02-issue.md
spec: ./01-feature-spec.md
plan: ./03-implementation-plan.md
---

# feat: saved searches

## Summary

Adds private saved searches to the search dashboard, including persistence, CRUD API, runtime authorization, and UI states.

## Scope check

- In scope: save, list, rerun, rename, delete, current permission filtering.
- Out of scope: sharing and scheduled delivery.
- Deviation from plan: none.

## Classification

`track: C` · `tags: [ui, api, database, security]`

## Evidence

- CI run: `https://ci.example.test/runs/8814` (commit `9f2c1ab`)
- Evidence artifact: [`aidf-evidence`](https://ci.example.test/runs/8814/artifacts/evidence.json) — `runner: ci`, 5 checks, 0 failures
- Preview: `https://pr-142.preview.example.test` (revision `9f2c1ab`, seed profile `search-tenants-v3`)

Not covered by automation:

- Cross-tenant leakage was checked manually against two seeded tenants — **claimed evidence**, one reviewer, recorded in the UI QA sign-off.
- Query cost under a filter set larger than 50 predicates: **not tested**. Follow-up issue #147.

## Risks and rollout

- Risk: unusually large filters could increase query cost.
- Rollback: hide save controls with the feature flag; retain data for safe re-enable.
- Migration: additive table; no backfill.

## Documentation

- [x] ADR added
- [x] Wiki updated
- [x] Release notes prepared
