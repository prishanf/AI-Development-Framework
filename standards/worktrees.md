# Worktrees

A worktree gives each feature an isolated filesystem checkout while sharing the same Git history. Use one when work is parallel, long-running, risky, or likely to require a second agent session.

## Naming

Use a stable issue key and short slug:

```text
branch:  feat/123-saved-searches
worktree: ../project-123-saved-searches
```

The branch and worktree name should be recoverable from the issue or PR. Avoid names based on a model, person, or temporary chat title.

## Example commands

Run these from the parent directory of the repository. Replace the paths and branch names with the project manifest values.

```bash
git fetch origin
git switch main
git pull --ff-only
git switch -c feat/123-saved-searches
git worktree add ../project-123-saved-searches feat/123-saved-searches
```

After the pull request is merged:

```bash
git worktree remove ../project-123-saved-searches
git worktree prune
git branch -d feat/123-saved-searches
```

The commands are examples, not an authorization to delete unmerged work. Confirm the branch is merged and the path is exact before removal.

## Lifecycle

1. Confirm the spec is approved and the issue exists.
2. Create the feature branch from the configured integration branch.
3. Create a sibling worktree using the branch name.
4. Copy only approved local configuration; never copy secrets into a worktree.
5. Launch the agent with the manifest, spec, plan, and repository rules in context.
6. Commit coherent increments; keep generated artifacts intentional.
7. Push the branch and open the PR.
8. After merge, remove the worktree and prune stale references.

## Parallel work rules

- Two agents must not edit the same worktree concurrently.
- Split parallel work by file ownership or independent deliverable.
- The coordinator owns integration and conflict resolution.
- Each parallel task has a written contract: objective, inputs, output files, and stop conditions.
- If two tasks need the same foundational API, finish the foundation first or designate one owner.

## Recovery

If an agent session ends, another agent can resume from `project-state.md`, the implementation plan, branch history, and the last verification report. Never rely on chat history as the only source of state.
