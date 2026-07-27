# Environment and promotion flow

```mermaid
flowchart LR
    local[Local: synthetic state] --> branch[Feature/fix branch off develop]
    branch --> pr[Pull request to develop]
    pr --> needpreview{ui, api, database<br/>or Track C?}
    needpreview -->|Yes| preview[Preview: isolated app + state]
    needpreview -->|No| approval[PR approval]
    preview --> approval
    approval --> develop[Protected develop]
    develop --> qa[QA: continuously deployed, resettable state]
    qa --> relbranch[release/&lt;version&gt;: QA hardening]
    relbranch --> release[Production approval]
    release --> main[Protected main]
    main --> prod[Production: protected app + real state]
    prod --> observe[Observe / recover]
    main -.->|back-merge| develop
```

Code promotion and data promotion are different actions. An immutable source revision is promoted through the gates; versioned migration artifacts are applied to the target database. A preview database is never promoted into production.
