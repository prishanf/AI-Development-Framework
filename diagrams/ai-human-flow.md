# AI and human activities

Derived from [guide/03-workflow.md](../guide/03-workflow.md) (canonical lifecycle) and [guide/04-roles.md](../guide/04-roles.md). If this diagram and those files disagree, this diagram is wrong.

Swimlanes show **who leads** each activity. CI corroborates evidence and enforces protected-branch rules; it does not replace human approval. Ownership by irreversibility is summarized in [responsibility-matrix.md](responsibility-matrix.md). How a human kicks off the process (with prompt examples): [guide/03-workflow.md](../guide/03-workflow.md) § How a human starts.

```mermaid
flowchart TB
    subgraph human["Human"]
        direction TB
        h0[State problem + invoke spec or Track A]
        h1[Answer open questions]
        h2[Approve spec + classification]
        h3[Approve design + mockup when ui]
        h4[Approve implementation plan]
        h5[UI QA sign-off when ui]
        h6[Human PR review + approval]
        h7[Production / release approval]
        h8[Decide stop / escalate / waive]
    end

    subgraph ai["AI agent"]
        direction TB
        a1[Draft spec + recommend track]
        a2[Draft design + mockup when ui]
        a3[Draft implementation plan]
        a4[Isolate: branch + worktree off develop]
        a5[Build: code + tests on feature branch]
        a6[Verify: run checks, emit evidence]
        a7[Open PR to develop]
        a8[AI review: findings on PR]
        a9[Remediate P0/P1 findings]
        a10[Post ready-for-human comment]
        a11[Prepare release notes / docs]
    end

    subgraph ci["CI / automation"]
        direction TB
        c1[Corroborate check evidence]
        c2[Enforce PR checks]
        c3[Deploy preview / QA / production]
    end

    h0 -->|Track A| a4
    h0 -->|Track B/C| a1
    a1 --> h1
    h1 --> a1
    a1 --> h2
    h2 --> a2
    a2 --> h3
    h2 --> a3
    h3 --> a3
    a3 --> h4
    h4 --> a4
    a4 --> a5
    a5 --> a6
    a6 --> c1
    c1 --> a7
    a7 --> c2
    a7 --> a8
    a8 -->|P0/P1| a9
    a9 --> a6
    a8 --> a10
    a10 --> h5
    a10 --> h6
    h5 --> h6
    h6 --> c3
    c3 --> a11
    a11 --> h7
    a5 -.-> h8
    a6 -.-> h8
```

## Activity cheat sheet

| Step | AI | Human | CI |
|---|---|---|---|
| **Start (Discover)** | — | State the problem; invoke `spec` or declare Track A | — |
| Spec + classify | Draft, recommend track/tags, ask questions | Answer questions; approve scope and classification | — |
| Design *(ui)* | Draft design + throwaway mockup | Approve design **and** mockup together | — |
| Plan | Draft plan; leave `Approval.decision` pending | Approve plan before any implementation | — |
| Isolate | Create `feat/*`/`fix/*` from `develop` + worktree | — | — |
| Build | Implement and test on the feature branch | — | — |
| Verify | Run safe checks; emit `runner: agent` evidence | Interpret risk; never invent pass/fail | **Corroborate** evidence |
| Preview *(tagged)* | Prepare isolated target | UI QA decision when `ui` | Deploy isolated state |
| AI review | Publish findings; remediate loop; ready-for-human | — | Enforce automated checks |
| Human review | — | Authorize merge; accept or reject findings | Enforce checks |
| Merge / QA | Prepare | Approve PR | Merge policy + deploy QA |
| Release | Prepare notes, tag checklist, docs | Production approval | Deploy; annotated tag on authorized tip |
| Stop / waive | Stop and hand back; **never** waive a gate | Decide next action; waive only with expiry | Expire waivers |

**Hard boundaries:** humans own the kickoff, intent, and irreversible actions (scope, plan, merge, production). Agents draft and implement within those gates. CI alone corroborates evidence — an agent cannot validate its own work.
