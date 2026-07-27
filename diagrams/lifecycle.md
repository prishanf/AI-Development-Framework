# Lifecycle

Derived from [guide/03-workflow.md](../guide/03-workflow.md), which is canonical. If this diagram and that file disagree, this diagram is wrong.

```mermaid
flowchart TD
    idea[Idea] --> track{Which track?}

    track -->|Track A| build
    track -->|Track B or C| spec[Draft spec]

    spec --> questions{Questions remain?}
    questions -->|Yes| answer[Human answers]
    answer --> spec
    questions -->|No| classify[Classify: track, risk, tags]
    classify --> approval{Human approves scope?}
    approval -->|No| spec
    approval -->|Yes| issue[Create issue]
    issue --> plan[Implementation plan]
    plan --> build[Branch / worktree, implement + test]

    build --> verify[Verify: emit corroborated evidence]
    verify --> preview{ui, api or database tag?}
    preview -->|Yes| previewenv[Preview env + UI QA]
    preview -->|No| pr[Open PR]
    previewenv --> pr

    pr --> review[AI + human review]
    review --> merge[Merge to main]
    merge --> relapprove{Production approval}
    relapprove --> release[Deploy via CI]
    release --> observe[Observation window]
    observe --> archive[Update durable docs + state]

    build -.->|stop condition| halt[Stop and hand back]
    verify -.->|3 failures| halt
```

The dashed edges are not exceptional paths. Stopping on a repeated failure or an invalidated assumption is a normal, successful outcome — see "Stop conditions" in the workflow.
