---
type: deployment-record
status: healthy
owner: engineering@example.test
environment: production
source-revision: abc1234
---

# Deployment record: Saved searches v1.8.0

## Approvals and checks

- PR approval: security reviewer
- UI QA sign-off: [14-ui-qa-signoff.md](14-ui-qa-signoff.md)
- Production approval: release maintainer
- Checks: lint, typecheck, saved-search tests, build, Preview smoke checks — pass

## State changes

- Migration plan: [12-migration-plan.md](12-migration-plan.md)
- Recovery point: approved pre-release database snapshot

## Verification and observation

- Smoke checks: create and rerun a saved search with a synthetic account — pass
- Observation window / owner: 30 minutes / on-call engineer
- Rollback: disable feature flag; application rollback remains schema compatible

## Result

- Status: `healthy`
- Completed: 2026-07-25 14:30 UTC
