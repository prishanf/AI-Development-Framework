# Contributing

Contributions should improve the framework without making it dependent on a particular AI vendor.

The framework runs its own gates. Before opening a change:

```bash
sh reference/scripts/check-consistency.sh
sh reference/scripts/self-test.sh
```

If AIDF cannot pass AIDF, the change is not ready.

## Before opening a change

- Read [guide/01-overview.md](guide/01-overview.md) and [guide/05-documents.md](guide/05-documents.md).
- Keep new rules explicit about ownership, evidence, and the human gate involved.
- Prefer adding a reusable contract or template over adding vendor-specific prose.
- Update the examples when a lifecycle, quality gate, or required field changes.
- **Prefer deleting to adding.** The most common defect in this repository has been volume, not absence: a rule nobody can follow is worse than a gap somebody notices.

## Rules that are load-bearing

Changing any of these is a major version bump, and needs a stated reason:

- Only a runner corroborates evidence; agent claims never satisfy a gate.
- Gates fail closed; an empty required command fails.
- Process is proportional to risk — Track A must stay genuinely cheap.
- One canonical lifecycle, one tag taxonomy, one version string.
- Adapters never promise a surface the repository does not ship.

## Change categories

- **Patch:** clarification, typo, or non-behavioral example fix.
- **Minor:** new optional template, adapter guidance, or additive workflow guidance.
- **Major:** changed required fields, command behavior, lifecycle states, track definitions, schemas, or approval boundaries.

## Review checklist

- [ ] `check-consistency.sh` and `self-test.sh` pass.
- [ ] Links resolve locally.
- [ ] Mermaid diagrams remain readable, focused, and derived from the canonical workflow.
- [ ] New templates declare a `track:` and a `required_when:`.
- [ ] A new rule is stated in exactly one file; others link to it.
- [ ] Command contracts state inputs, authority limits, outputs, and completion criteria.
- [ ] `VERSION` and every document that names a version agree.
- [ ] The change is reflected in `CHANGELOG.md`.
