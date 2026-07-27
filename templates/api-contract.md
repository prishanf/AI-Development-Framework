---
type: api-contract
track: B
required_when: "the change carries the `api` tag"
status: draft
owner: ""
updated: YYYY-MM-DD
service: ""
---

# API contract: <service or endpoint>

## Purpose and consumers

<What problem this API solves and who calls it.>

## Interface

- Contract source: <OpenAPI, JSON Schema, or code path>
- Authentication: <mechanism>
- Authorization: <required permissions and object-level rule>
- Request schema: <link or summary>
- Response schema: <link or summary>
- Errors: <stable format and safe messages>

## Behavior

- Pagination/limits: <rule>
- Idempotency/retries: <rule>
- Rate limit: <rule>
- Versioning/deprecation: <rule>
- Audit/correlation: <fields>

## NFR profile

| Concern | Target or explicit pending decision | Owner / review date |
|---|---|---|
| Latency | <target or pending> | <owner> |
| Availability | <target or pending> | <owner> |
| Capacity | <target or pending> | <owner> |
| Recovery | <target or pending> | <owner> |
| Cost | <target or pending> | <owner> |

## Verification

- [ ] Contract tests
- [ ] Allowed and denied authorization tests
- [ ] Input validation tests
- [ ] Smoke test
