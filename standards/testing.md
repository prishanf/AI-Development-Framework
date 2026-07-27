# Testing

AIDF requires tests as evidence in a dozen places. Requiring tests without defining a good one produces a suite that satisfies gates and catches nothing — and an agent optimizing for a green check will produce exactly that suite, quickly and in volume.

Corroborated evidence proves a command ran and what it returned. It cannot prove the command was meaningful. This file closes that half of the gap; [evidence.md](evidence.md) closes the other. Neither works alone.

## The rule that does the most work

> **A new test must fail against the pre-change code.**

If a test passes before the fix, it is not testing the fix. This single rule eliminates most worthless tests, and it is mechanically checkable: stash the source change, run the new test, confirm it fails, restore.

For a bug fix, this is non-negotiable — the failing test *is* the reproduction, and writing it first is the only way to know you found the actual bug rather than a plausible neighbour of it.

## Anti-patterns

These are the specific ways AI-written test suites go wrong. They are common enough to check for by name.

**Asserting current behavior.** A test written by observing what the code does and encoding that. It passes forever, including after a regression, because it was derived from the implementation rather than the requirement. Symptom: the test was written after the code and never failed.

**Mocking the system under test.** Enough mocking that the assertions only exercise the mocks. Symptom: the test passes when you delete the implementation body.

**Tautologies.** `expect(result).toBeDefined()`, `expect(true).toBe(true)`, `assert response is not None`, snapshot tests regenerated until green. Symptom: no assertion references an expected *value*.

**Happy path only.** Agents implement the success case first and test what they implemented. The error, permission-denied, empty, concurrent, and malformed-input cases are where defects live and where coverage is thinnest.

**Testing the framework.** Verifying that the ORM saves a record or the router routes. Someone else already tests that.

**Coverage as the objective.** Coverage measures which lines executed, not which behaviors are protected. A suite can reach 90% and assert nothing meaningful. Use it to find untested areas, never as a gate target — the moment it becomes a target, agents will hit it the cheap way.

**Skips and loosened assertions to get green.** Widening a tolerance, adding `.skip`, catching the exception the test existed to detect. This is a stop condition, not a fix: see [guide/03-workflow.md](../guide/03-workflow.md).

## What to test

Test **behavior at a boundary**, not implementation detail. A test that must change whenever the code is refactored is testing the wrong thing.

For a typical change:

| Layer | What it protects | Notes |
|---|---|---|
| Unit | A pure function's contract, including edge inputs | Fast, no I/O |
| Integration | The seams — real database, real HTTP boundary | Where most real defects hide |
| Contract | The promise an API makes to its consumers | Required for the `api` tag |
| Authorization | **Denied** paths, per object and per role | Required for `api` and `security`; test refusal as deliberately as permission |
| Smoke | The system starts and serves | Post-deploy |

Deliberately included in that table: authorization tests of the *denied* path. Broken access control is the most common serious vulnerability in real applications, and it is invisible to a suite that only ever tests authorized users.

## Flaky tests

A flaky test is a defect, not a status. It has two honest resolutions: fix it, or delete it and record the coverage gap. Retrying until green teaches everyone — human and agent — that a red check is negotiable, which quietly disables every gate that depends on it.

## Agent instructions

When the build agent writes tests:

- Write the test for a bug **before** the fix, and confirm it fails.
- Name what the test protects, not what it calls: `rejects a saved search whose filters exceed the caller's permissions`, not `test saved search 3`.
- Mirror the existing test style in the file you are nearest to; see [templates/conventions.md](../templates/conventions.md).
- When a test cannot be written — genuine environmental limits — say so in the PR under "not covered by automation". An honest gap is evidence. A tautology dressed as coverage is not.
- Never modify an existing test to make a change pass without saying so explicitly and prominently. Silently editing an assertion is the single most dangerous edit an agent can make, because it removes a control while appearing to add work.
