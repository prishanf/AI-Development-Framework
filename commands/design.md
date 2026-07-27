# Command: `design`

## Purpose

Produce an approved design — description and, by default, a clickable static mockup — for a `ui`-tagged change, before an implementation plan is written.

This command exists because the design gate previously had no contract of its own: it was a step named by `spec` with no agent responsible for actually producing the visual artifact a human needs to approve it. See [standards/ui-and-preview.md](../standards/ui-and-preview.md) for what distinguishes this from `preview` — this produces a **throwaway** mockup before planning; `preview` proves the **real, built** implementation later.

## Prompt contract

```text
Act as the design agent.

Load the project manifest, approved feature spec with its classification block, and
any existing design system, CSS, or component library the project already has.

Produce templates/design.md: user goal, flow, and every state (empty, loading,
success, validation-error, permission-error).

Then build the mockup. Default to building one — do not skip it because the change
looks simple; layout problems are exactly the ones prose hides. It must be:
- static HTML/CSS/JS, using the project's real design tokens or component classes
  where they exist;
- built with fabricated mock data at realistic volume, not placeholder rows;
- navigable between every screen and state named above, by click;
- responsive at the project's declared breakpoints, at least roughly.

It must NOT be: wired to a backend, written to pass tests, held to production code
quality, or written in a way that invites reuse as the real implementation. Say so
explicitly in your handoff, so the build agent does not copy it in.

Skip the mockup only when you can name a specific, checkable reason (e.g. "single
microcopy change on an already-mocked screen") and record it in the design doc's
"Not required, because" field. "This seems simple" is not sufficient — leave the field
blank and ask, rather than assert it silently.

Leave `Approval.decision` as `pending`. Tell the human explicitly that planning must
not begin until they set it to `approved`, and that once approved, the design and its
mockup — not a future conversation — are the authoritative source for what the build
agent implements.

Return: the design doc, the mockup's location (or the stated reason it was skipped),
open questions, and the explicit statement that plan must wait for this approval.
```

## Completion criteria

- Every state named in the spec/design has a reachable mockup state, or a specific stated reason it does not.
- The mockup uses the project's real visual language where one exists, not a generic template.
- The handoff states plainly that the mockup is throwaway and must not become the implementation.
- `Approval.decision` is left `pending`, with an explicit statement that build and plan must wait for it.
