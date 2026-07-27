---
type: adr
status: accepted
number: "0012"
date: 2026-07-23
decision-makers: [engineering, security]
related: [./01-feature-spec.md, ./05-pull-request.md]
---

# ADR 0012: Store filters, not result snapshots

## Context

Saved searches must remain useful as data and permissions change. Caching result IDs would create stale results and could expose records after access is revoked.

## Decision

Store the normalized filter definition and owner/tenant metadata. Rerun the filter through the current authorization-aware query builder on every request.

## Options considered

| Option | Benefits | Costs / risks | Result |
|---|---|---|---|
| Store result snapshot | Fast reads | Stale data and authorization exposure | Rejected |
| Store filters and rerun | Current data and permissions | Query cost on each run | Chosen |
| Store filters plus cache | Faster repeated runs | Invalidation and security complexity | Deferred |

## Consequences

- Positive: authorization semantics stay centralized.
- Negative: repeated searches consume query capacity.
- Follow-up: monitor query latency and add bounded caching only with a new decision.
