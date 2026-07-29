# Worktree flow

Bare-clone layout: one bare repository, plus a persistent worktree for each long-lived branch (`main`, `develop`) and a sibling worktree per short-lived branch. See [standards/worktrees.md](../standards/worktrees.md).

```mermaid
stateDiagram-v2
    [*] --> BareRepoCloned
    BareRepoCloned --> MainWorktree
    BareRepoCloned --> DevelopWorktree
    DevelopWorktree --> Approved: spec + plan approved on develop
    Approved --> BranchCreated: Isolate — branch from develop
    BranchCreated --> FeatureWorktreeReady
    FeatureWorktreeReady --> AgentSession
    AgentSession --> Implementing
    Implementing --> Verifying
    Verifying --> Implementing: failed check / fix
    Verifying --> PR
    PR --> Review
    Review --> Implementing: requested changes
    Review --> MergedToDevelop
    MergedToDevelop --> FeatureWorktreeRemoved
    FeatureWorktreeRemoved --> [*]
```

Spec and plan are approved on `develop` before `BranchCreated`. See [guide/03-workflow.md](../guide/03-workflow.md) steps 2, 7, and 9, and [lifecycle.md](lifecycle.md).