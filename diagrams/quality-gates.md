# Quality gates

Derived from [standards/quality-gates.md](../standards/quality-gates.md), which is canonical.

```mermaid
flowchart TD
    classify[Classify: track, risk, tags] --> baseline[Baseline: format, lint, typecheck, build, unit tests, secret scan]
    baseline --> trackA{Track A?}
    trackA -->|Yes| approve[1 human PR approval]
    approve --> merge[Merge to develop]
    trackA -->|No| ui{ui tag?}

    ui -->|Yes| uiqa[Approved design + Preview + UI QA sign-off]
    ui -->|No| api{api tag?}
    uiqa --> api

    api -->|Yes| contract[Preview + contract + authorization tests]
    api -->|No| db{database tag?}
    contract --> db

    db -->|Yes| migration[Preview + migration plan + schema review]
    db -->|No| dep{dependency tag?}
    migration --> dep

    dep -->|Yes| prov[Provenance + vulnerability diff]
    dep -->|No| secure{security, mcp-write or infra?}
    prov --> secure

    secure -->|Yes| threat[Threat model + named specialist review]
    secure -->|No| approve2[Human PR approval]
    threat --> approve2
    approve2 --> merge

    merge --> reltime[release/&lt;version&gt; -> main: production approval, recovery point, post-release verification, observation window, deployment record]
```

Preview appears inside the tag branches, not in the baseline. It is required for `ui`, `api`, and `database` changes and for all of Track C — not for every pull request.

Release-time gates are separated deliberately: they apply to a deployment, not to a pull request.
