# Example: the run that goes wrong

[sample-feature/](../sample-feature/) shows a feature that goes to plan. Nothing in a framework is tested by that. This example is the other one: a spec rejected, a track escalated mid-build, a stop condition hit, a gate failed and formally waived, and a P0 found in review.

Read it as four moments, in order. Each is a place where AIDF either does something useful or is just paperwork.

---

## Moment 1 — The spec is rejected

**Request:** "Let users export their search results to CSV."

The spec agent drafts it as Track B: an export button, a background job, a download link.

The product owner rejects it:

> Decision: `rejected`
> Notes: Export means data leaves the product. Which fields? Whose records — only the caller's, or everything the search returned? What happens to the generated file, and for how long? Come back with those answered.

**What the framework did:** the spec's `Approval.decision` field is what forced this to be an explicit decision rather than a vague "sounds good" that an agent would treat as authorization. The revised spec answers all three questions and reclassifies to **Track C**, because the answers involve retention and object-level authorization.

**Cost of getting this wrong:** an agent starts building. Two hours later there is a working exporter that includes fields the caller cannot see, and nobody notices because the happy path works.

---

## Moment 2 — The track escalates mid-build

Approved spec: `track: B`, `tags: [ui, api]`. Export runs in-request, no persistence.

Three files in, the build agent finds the search backend paginates and cannot stream a full result set in one request. Delivering the feature needs a job table to track export requests.

The agent **stops**:

```text
STOP — plan assumption invalidated.

Assumption (plan §Risks): "export can run in-request; no persistence required."
Repository contradicts it: search returns a cursor-paginated iterator
(src/search/query.ts:88); a full export needs 40+ round trips.

Delivering this requires a job table. That adds the `database` tag and
forces Track C, which needs a migration plan and a schema review.

Completed: DTO and CSV serializer (src/export/serialize.ts) — self-contained, tests pass.
Partial: none. No schema changes made.
Decision needed: approve Track C escalation and a migration plan, or re-scope
to "export the current page only", which stays Track B.
```

**What the framework did:** the plan named its assumption, so its violation was recognizable. The agent escalated instead of quietly adding a table — the single most valuable behavior in the whole framework, because a silently-added table is a schema change that reached production without a migration plan or a review.

The product owner picks the smaller thing: **export the current page only.** Track B stands. The escalation was avoided by changing the product, not by weakening the process.

---

## Moment 3 — A gate fails and is waived

Preview is required (`ui`, `api`). It fails: the preview environment's object storage is misconfigured, unrelated to this change. Two days of platform work to fix.

The change is a client-side CSV of already-rendered data. The team waives the gate:

```json
{ "name": "preview", "status": "waived", "source": "waiver",
  "waiver": {
    "approver": "platform-lead",
    "reason": "Preview object storage misconfigured (INFRA-88), unrelated to this change. Export is client-side over already-rendered rows; verified locally against the seed profile.",
    "expires": "2026-08-15",
    "follow_up": "INFRA-88"
  } }
```

**What the framework did:** made the exception a record instead of a decision nobody wrote down. The expiry is the part that matters — `validate-evidence.sh` fails the build once the date passes, so the gap cannot quietly become the new normal. A waiver without an expiry is not a waiver; the schema rejects it.

**What the framework did not do:** stop the team from shipping. A gate that cannot be waived gets deleted instead.

---

## Moment 4 — Review finds a P0

Everything is green. The review agent reads the diff anyway.

```markdown
### [P0] Export bypasses the field-level permission filter

- Location: `src/export/serialize.ts:34`
- Evidence: `serialize()` receives the raw row objects from `useSearchResults()`,
  not the redacted view model the table renders. Rows carry `internal_notes`
  and `owner_email`, which the table masks in `SearchRow.tsx:61` but the CSV does not.
- Impact: any user who can run a search can export fields the UI deliberately
  hides from them.
- Suggested direction: serialize from the view model, and add a test asserting
  that a masked column is absent from CSV output.
```

**Why automation missed it:** every check passed. The tests covered CSV formatting — correctly, and thoroughly. They asserted the shape of the output, never its *contents against the caller's permissions*. This is precisely the anti-pattern in [standards/testing.md](../../standards/testing.md): happy-path coverage that measures the code that was written rather than the requirement that mattered.

**What the framework did:** required review to read the diff rather than the PR description, and required denied-path authorization tests for `api`-tagged work — which is what turned a vague "looks fine" into a specific, evidenced finding.

The fix adds the failing test first, confirms it fails against the pre-change code, then serializes from the view model.

---

## What this example is actually for

| Moment | The framework's job | If it had no answer |
|---|---|---|
| Rejected spec | Force an explicit approval decision | Ambiguity read as authorization |
| Mid-build escalation | Make assumptions nameable, then stop | Unreviewed schema change in production |
| Failed gate | Waivers with approver, expiry, follow-up | Gate deleted, or silently ignored |
| P0 in review | Read the diff; test denied paths | Green build ships a data leak |

Three of the four are *stopping* well. A framework that only describes the happy path has nothing to say on the days that matter.
