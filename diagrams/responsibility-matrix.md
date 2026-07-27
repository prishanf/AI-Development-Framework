# Responsibility matrix

```mermaid
quadrantChart
    title Ownership by stage
    x-axis AI-led --> Human-led
    y-axis Reversible --> Irreversible
    quadrant-1 Human decision
    quadrant-2 Human decision with evidence
    quadrant-3 Agent execution
    quadrant-4 CI / controlled automation
    Create spec: [0.25, 0.2]
    Classify change: [0.4, 0.3]
    Ask questions: [0.45, 0.2]
    Approve spec and track: [0.9, 0.65]
    Plan implementation: [0.35, 0.25]
    Write code and tests: [0.25, 0.2]
    Run checks: [0.15, 0.15]
    Corroborate evidence: [0.1, 0.3]
    Deploy preview: [0.3, 0.35]
    Review PR: [0.65, 0.5]
    Waive a gate: [0.95, 0.7]
    Merge: [0.9, 0.85]
    Deploy production: [0.75, 0.95]
```

| Stage | AI | Human | CI |
|---|---|---|---|
| Create spec and classify | Draft, recommend track | Answer, approve track | |
| Plan and build | Lead | Set boundaries | |
| Verification | Run and report | Interpret risk | **Corroborate** |
| Preview | Prepare target | QA decision | Deploy isolated state |
| Review | Analyze | Decide | Enforce checks |
| Waive a gate | Never | Approve with expiry | Expire it |
| Merge | Prepare | Approve | Enforce checks |
| Deploy | Prepare | Approve | Execute |

Two rows carry most of the weight. **Corroboration is CI-only** — an agent cannot validate its own work, which is why the Verification row splits reporting from corroborating. And **waiving a gate is human-only, never AI** — an agent that could waive a gate could satisfy every gate.
