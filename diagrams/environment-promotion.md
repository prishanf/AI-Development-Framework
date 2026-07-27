# Environment and promotion flow

```mermaid
flowchart LR
    local[Local: synthetic state] --> branch[Feature branch]
    branch --> pr[Pull request]
    pr --> needpreview{ui, api, database<br/>or Track C?}
    needpreview -->|Yes| preview[Preview: isolated app + state]
    needpreview -->|No| approval[PR approval]
    preview --> approval
    approval --> main[Protected main]
    main --> qa[Optional QA: resettable state]
    main --> release[Production approval]
    qa --> release
    release --> prod[Production: protected app + real state]
    prod --> observe[Observe / recover]
```

Code promotion and data promotion are different actions. An immutable source revision is promoted through the gates; versioned migration artifacts are applied to the target database. A preview database is never promoted into production.
