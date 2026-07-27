# Worktree flow

Bare-clone layout: one bare repository, plus a persistent worktree for each long-lived branch (`main`, `develop`) and a sibling worktree per short-lived branch. See [standards/worktrees.md](../standards/worktrees.md).

```mermaid
stateDiagram-v2
    [*] --> BareRepoCloned
    BareRepoCloned --> MainWorktree
    BareRepoCloned --> DevelopWorktree
    DevelopWorktree --> Approved: spec + plan approved
    Approved --> BranchCreated: branch from develop
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
