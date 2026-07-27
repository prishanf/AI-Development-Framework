# Sample feature: Saved searches — Track C

A fictional feature moving through AIDF end to end. It assumes a web application with authenticated users, a search API, and a PostgreSQL database.

**This is Track C** — it carries `ui`, `api`, `database`, and `security` tags, so it pulls in nearly every artifact the framework defines. That makes it a useful tour and a **misleading baseline**: most changes are Track B and produce five documents, and a Track A change produces one. Do not read this directory as "what every feature costs."

```text
idea → spec (with classification) → plan → migration + seed → preview UI QA
     → PR → review → release → deployment record
```

## What is deliberately absent

- **No classification document.** It is front matter on [01-feature-spec.md](01-feature-spec.md).
- **No seed data plan.** It is a section of [12-migration-plan.md](12-migration-plan.md).
- **No implementation record.** [05-pull-request.md](05-pull-request.md) is the record. A second narrative of the same change is a second source of truth, and one of them will be wrong.

Note how the PR reports verification: it **links** a CI evidence artifact and separately labels what a human checked and what nobody checked. It does not contain a table of self-reported passes. That distinction is the point — see [standards/evidence.md](../../standards/evidence.md).

For a run that does not go smoothly, see [../scope-change/](../scope-change/).
