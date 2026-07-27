---
type: code-review
track: B
required_when: "every Track B and Track C pull request"
reviewer: ""
pr: ""
date: YYYY-MM-DD
---

# Review: <pull request>

## Summary

<One-paragraph assessment of correctness and risk.>

## Findings

### [P0] <blocking issue>

- Location: `<file>:<line>`
- Evidence: <what demonstrates the issue>
- Impact: <user, system, or security impact>
- Suggested direction: <fix or question>

### [P1] <important issue>

<Repeat as needed. Use P2 for normal, P3 for polish.>

## Verification performed

- Commands: `<commands>`
- Tests: <what was covered>
- Not tested: <gaps>

## Decision

- Result: `approve | request-changes | comment`
- Conditions: <conditions or none>
