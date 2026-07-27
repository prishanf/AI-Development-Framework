# Reference implementation

**These files are a reference, not the contract.** The canonical rules live in [standards/](../standards/). Any CI system, any language, any hosting provider that produces the same corroborated evidence is equally AIDF-compliant.

They exist because AIDF v1 described quality gates without implementing a single one, which meant adopting the framework required a team to rebuild every gate from prose. That is the difference between a framework and an essay.

## What is here

| Path | Purpose | Depends on |
|---|---|---|
| `scripts/validate-manifest.sh` | Validate `project.yaml` against the schema; empty required commands fail | `python3` |
| `scripts/validate-evidence.sh` | Enforce the corroboration rule and waiver validity | `python3` |
| `scripts/run-gates.sh` | Run the track's required checks, emit `evidence.json` | `python3`, `git` |
| `scripts/check-consistency.sh` | Catch framework self-contradictions and broken links | `python3` |
| `scripts/self-test.sh` | Prove the gates fail when they should | `python3` |
| `scripts/lib/minischema.py` | Dependency-free JSON Schema subset validator | — |
| `github/workflows/aidf-gates.yml` | PR-time gates, evidence upload, size budget | GitHub Actions |
| `github/workflows/aidf-selfcheck.yml` | Consistency + self-test + diagram parsing | GitHub Actions |
| `github/PULL_REQUEST_TEMPLATE.md` | Links evidence rather than restating it | GitHub |
| `github/CODEOWNERS` | Turns "specialist review required" into a control | GitHub |

`python3` is the only runtime requirement, and PyYAML is optional — a fallback parser handles the manifest shape. A gate that needs `pip install` before it runs is a gate that gets skipped.

## Adopting it

```bash
cp -r reference/github/workflows/. .github/workflows/
cp reference/github/PULL_REQUEST_TEMPLATE.md .github/
cp reference/github/CODEOWNERS .github/
cp templates/project.yaml project.yaml
sh reference/scripts/validate-manifest.sh project.yaml
```

Then, in repository settings:

1. Protect the integration branch: require pull requests and passing checks.
2. Require review from Code Owners so the Track C specialist gate is enforced.
3. Create the labels the workflow reads: `track-a`, `track-c`, and one per risk tag.
4. Add an environment protection rule for production so the release-time approval gate is real.

Steps 1, 2 and 4 are the ones that matter. The workflow reports gate outcomes; **branch and environment protection is what makes a failed gate actually block a merge or a deploy.** Without them, every gate in this directory is advisory.

## Running locally

```bash
sh reference/scripts/run-gates.sh --track B --tags ui
```

This writes `evidence.json` with `runner: local`, which by default does not corroborate anything — it tells you whether CI will pass, it does not substitute for CI having passed. That asymmetry is deliberate; see [standards/evidence.md](../standards/evidence.md).

## Porting to another CI system

Reimplement three behaviors and you are compliant:

1. Run the checks the change's track and tags require, per [standards/quality-gates.md](../standards/quality-gates.md).
2. Emit an `evidence.json` that validates against [schemas/evidence.schema.json](../schemas/evidence.schema.json) with `runner: ci`.
3. Block the merge when `validate-evidence.sh` exits non-zero.

The scripts in `scripts/` are portable POSIX shell and Python; only the `github/` directory is platform-specific.
