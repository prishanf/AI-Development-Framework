# Design, Preview, and UI Approval

UI work passes through **two** distinct visual gates, not one. Confusing them is a real failure mode — it happened in practice, not hypothetically — so this file names them separately and says explicitly what each is not.

| | **Design mockup** | **Preview** |
|---|---|---|
| When | Design gate, before planning | After build, before merge |
| Proves | The proposed layout, information density, and flow are right | The real implementation matches the approved design |
| Built from | Static HTML/CSS/JS and fabricated mock data | The actual application, deployed to isolated state |
| Code fate | **Throwaway.** Never merged, never becomes the implementation | Is the implementation |
| Approved by | Design/product owner, gating the plan | QA reviewer, gating the merge |
| Template | `templates/design.md` | `templates/ui-qa-signoff.md` |

Get these backwards and the framework fails at exactly the moment it exists to help: either the plan gets approved against prose nobody can actually picture, or the first real look at the UI arrives after the implementation is already written — too late to change layout cheaply.

## Design gate

Before implementation, and before the plan is written, the spec's linked design must define:

- user goal and primary flow;
- desktop and narrow-screen behavior;
- empty, loading, success, validation-error, and permission-error states;
- content, accessibility, and localization notes where relevant;
- acceptance criteria that a reviewer can observe.

**A static mockup is required by default** for any `ui`-tagged Track B or Track C change — not only for changes that look complex going in. A change that looks simple in prose (a details section, a summary panel) can still turn out to need real layout judgment once you see it, which is precisely what a mockup is for; deciding that from the spec alone reintroduces the guessing this gate exists to remove.

Markdown wireframes and a flow diagram remain part of `templates/design.md` regardless — they're cheap and they carry information a mockup doesn't (state transitions, error copy). The mockup is additional, not a replacement.

**Skipping the mockup** is allowed only with a stated reason recorded in the design doc — the same pattern the PR template already uses for "no docs needed, because": a one-line justification the approver can see and challenge, not a silent omission. Legitimate reasons look like "single microcopy change to an existing, already-mocked screen" or "visual change is purely a color-token swap with no layout impact." "It seemed small" is not a reason; if it turns out to matter, the plan gate is where that gets caught expensively, not cheaply.

The human product/design owner approves the design **and its mockup together** as one decision, during the spec-to-plan transition, before an implementation plan is written. Implementation — and planning — should not proceed against a design that has not cleared this gate, and should not invent a competing UX once it has.

## What the mockup covers

Enough to actually validate layout, colors, usability, and flow — not a polished, production-grade build:

- every screen or view the design introduces, navigable between each other as static links or JS-toggled panels;
- every state listed in the design doc (empty, loading, success, error, permission-error) reachable by a click, not just described;
- real layout structure for anything data-dense — tables, grids, multi-level groupings — built with fabricated data at realistic volume, not three placeholder rows;
- the project's actual design tokens, CSS variables, or component classes where the project has them, so colors and type read like the real product rather than an unrelated sketch;
- the declared responsive breakpoints, at least at a rough level.

It does not need: a backend, real data, accessibility implementation (though visible focus order is worth faking), production code quality, or tests. It is deleted or archived once the plan is approved — it is a decision aid, not a deliverable, and must not be treated as a head start on the implementation. Copying its markup into the real build is exactly how a throwaway prototype's shortcuts — no error handling, no real data model, no auth — end up shipping.

## Preview contract

Each UI PR **separately** provides a clickable review of the actual, working implementation using mock or controlled data. Native HTML, CSS, Tailwind, and JavaScript are sufficient; choose additional UI tooling only if the project needs it.

The reviewer must be able to exercise:

- the intended happy path;
- all defined states and role/permission boundaries;
- keyboard navigation and visible focus;
- responsive layout at the project's declared breakpoints;
- form validation and recovery;
- a stable fixture reset path.

This is a fidelity check against the design, not the first time anyone sees the layout. If Preview is where layout problems get discovered, the design gate above did not do its job.

## Approval evidence

Design and its mockup are approved together in `templates/design.md`'s own `Approval` block — no separate sign-off document. Preview is a distinct approval: use `templates/ui-qa-signoff.md` to record the preview URL, source revision, data profile, scenarios checked, reviewers, results, unresolved defects, and approval. Every UI PR requires this sign-off before merge, in addition to — not instead of — the design approval that already happened.

## Feedback handling

Feedback on the **mockup** belongs in the design doc, before planning: it can freely change layout, flow, or scope, because nothing has been built yet. Feedback on **Preview** belongs on the PR: a defect stays in the PR or becomes a bounded follow-up; a feedback item that changes approved scope or layout returns all the way to the spec and design, not just to the build agent.
