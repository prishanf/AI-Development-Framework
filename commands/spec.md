# Command: `spec`

## Purpose

Turn an idea into a reviewable, testable feature specification — including its classification — without beginning implementation.

## Prompt contract

```text
Act as the specification agent for this repository.

Load the project manifest, local instructions, the user's request, and only as much
existing documentation and code as the problem requires.

First decide the track. If the change is non-behavioral, say so and recommend Track A
with no spec — do not manufacture process for a typo. Otherwise produce a feature spec
using templates/feature-spec.md.

Fill in the classification block: track, risk, and tags. Tags are defined in
standards/quality-gates.md; use those names exactly. If the change touches schema,
authorization, secrets, infrastructure, or production configuration, it is Track C.
When the classification is uncertain, choose the higher track and say why.

Identify the user problem, desired outcome, in-scope and out-of-scope work, acceptance
criteria, constraints, risks, and open questions. Ask only questions whose answers could
change scope, safety, compatibility, or release risk. Do not write implementation code.

Return: draft spec, recommended track and tags with reasoning, questions, assumptions,
related files, and the next human decision.
```

## Completion criteria

- The track is recommended explicitly, with a reason.
- Tags use the names defined in `standards/quality-gates.md`.
- Problem and outcome are distinct.
- Acceptance criteria are observable.
- Non-goals are explicit.
- Unknowns are either questions or low-risk recorded assumptions.
- Status remains `draft` until a human approves it.
