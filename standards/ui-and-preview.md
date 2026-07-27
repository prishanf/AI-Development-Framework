# Design, Preview, and UI Approval

UI work begins with an approved design, then proves that the implementation matches it in a clickable Preview environment. The framework does not require a component-workbench product or a particular test runner.

## Design gate

Before implementation, the spec or linked design must define:

- user goal and primary flow;
- approved screens or wireframes;
- desktop and narrow-screen behavior;
- empty, loading, success, validation-error, and permission-error states;
- content, accessibility, and localization notes where relevant;
- acceptance criteria that a reviewer can observe.

The human product/design owner approves this design during the spec stage. Implementation should not invent a competing UX.

## Preview contract

Each UI PR provides a clickable review page or flow using mock or controlled data. Native HTML, CSS, Tailwind, and JavaScript are sufficient; choose additional UI tooling only if the project needs it.

The reviewer must be able to exercise:

- the intended happy path;
- all defined states and role/permission boundaries;
- keyboard navigation and visible focus;
- responsive layout at the project’s declared breakpoints;
- form validation and recovery;
- a stable fixture reset path.

## Approval evidence

Use `templates/ui-qa-signoff.md` to record the preview URL, source revision, data profile, scenarios checked, reviewers, results, unresolved defects, and approval. Every UI PR requires this sign-off before merge.

## Feedback handling

Feedback belongs on the preview or in the linked PR. A feedback item that changes approved scope returns to the spec; an implementation defect stays in the PR or becomes a bounded follow-up issue.
