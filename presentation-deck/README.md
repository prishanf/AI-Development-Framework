# AIDF Talk Deck

Self-contained HTML/CSS/JS presentation. No build step, no dependencies, no
network — open `index.html` in any browser.

## Present

| Key | Action |
|---|---|
| `→` `space` `PgDn` | Next |
| `←` `PgUp` | Back |
| `O` | Slide index — jump anywhere |
| `F` | Fullscreen |
| `Home` / `End` | First / last slide |
| `Esc` | Close the index |

Swipe works on touch screens. The URL carries `#slide-N`, so you can link
someone straight to a slide.

## Before presenting

1. **Slide 2 (Bio)** — the card is filled in. Check it still reads the way you
   want to introduce yourself.
2. **Slides 26–31 (Case study)** — "Beacon" is a composite, and the deck says
   so on slide 26. If you have a real product you can name instead, swap it in;
   the four changes map onto any codebase with a UI, an API, and a database.
3. **Slide 36 (Demo)** — dry-run the commands in your own repo. If the demo
   can't run, say so and skip it. Never narrate a result you did not just
   produce on screen.
4. **Slide 39 (Close)** — check the repository URL.

## Structure

Six acts, 39 slides, plus a five-slide appendix for Q&A (not presented).
Roughly 50–60 minutes with discussion.

| Act | Slides | Job |
|---|---|---|
| **I — The bottleneck moved** | 1–5 | Agents made writing code cheap, not trusting it. Introduce the with/without comparison as the spine. |
| **II — Proportional process** | 6–12 | Track triage, the lifecycle with its human gates and loop-backs, the eight command contracts. |
| **III — Evidence, not confidence** | 13–18 | The load-bearing idea: a claim is not a result. Corroboration, gate states, the evidence artifact, the testing rule. |
| **IV — Where it earns its keep** | 19–24 | Four real gaps, each shown with and without the framework. |
| **V — One product, four kinds of change** | 25–31 | The abstract process run four times on one codebase: a feature, three flavours of bug, an architecture change, a theme. |
| **VI — Adoption** | 32–39 | Vendored install, parallel work, risk tags, live demo, rollout, health signals. |
| *Appendix* | 40–44 | Environments, database lifecycle, AI-workflow safety, portability. |

### Act V is the concrete one

Acts II and III describe the machinery; Act V is where an audience sees it
sized to four different jobs and stops picturing one heavyweight pipeline.

| Slide | Change | What it demonstrates |
|---|---|---|
| 27 | Feature — saved filters | Classification **composes**: Track B baseline, then `ui` and `api` each bolt on their own artifacts and gates. |
| 28 | Defect — dev / QA / production | Where a bug is found picks the base branch and the process weight. A hotfix shortens the path, never the accountability. |
| 29 | Architecture — polling → queue | An `infra` tag forces Track C whether or not it looks like a refactor. Boundary moved ⇒ ADR plus an architecture update. |
| 30 | UI design — palette and dark theme | A one-file diff with a whole-product review surface. The one place the framework subtracts a step — the mockup — and only against a written reason. |
| 31 | The four compared | Same eight contracts, four weights, none of it negotiated on the day. |

## Design rules

Two decisions carry the look. Both are in the header comment of `style.css`.

**Serif display headlines on warm paper.** A deck set entirely in a UI
sans-serif reads as a slide template. The stack is system-only — no webfont,
no network dependency, because conference wifi fails and a deck must not.

**Colour means something.** One accent for structure, three semantic colours
used *only* for their meaning:

| Token | Meaning |
|---|---|
| `--danger` | The path without the framework. Failure. |
| `--success` | A gate passing. The path with the framework. |
| `--warn` | A waiver — conditional, expiring, never neutral. |

Nothing is tinted decoratively. If a panel is red, it is red because the
outcome is bad.

## Editing

Slides are plain `<section class="slide">` elements. Two attributes matter:

```html
<section class="slide" data-title="Gate states" data-act="III · Evidence">
```

`data-title` feeds the footer and the `O` index; `data-act` feeds the act
label. The index is built from the DOM at load, so it can never drift out of
sync with the deck.

Slide variants: `slide--title`, `slide--act` (divider), `slide--statement`
(one sentence, maximum air), `slide--closing`.

Content blocks: `.versus` (with/without panels), `.ledger` (multi-row
comparison), `.trees` (before/after file trees), `.rows`, `.cards`, `.cmds`,
`.artifact` (code with an annotation bar), `.demo`, `.dgm` (SVG wrapper).

Arrowheads are defined once at the top of `index.html` and referenced by every
diagram as `url(#mAccent)`, `url(#mDanger)`, `url(#mSuccess)`, `url(#mWarn)`,
`url(#mLine)`.

## Keeping it honest

The deck makes no time, cost, or percentage claims. The comparisons are
qualitative — outcome contrast only. Four of the five gaps in Act IV are real
findings from building an application with v4.0.0 and reading what the
framework actually produced; they are described as observations, not as
measured results.

Act V's product is a composite and is labelled as one on slide 26. What is
*not* invented there is the process: every gate, tag, branch name, and document
on slides 27–31 is what `guide/`, `standards/`, and `commands/` actually
specify at v5.0.2. If you change the framework, re-read those five slides.

If you add a number, be able to name where it came from.
