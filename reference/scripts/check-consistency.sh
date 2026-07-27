#!/bin/sh
# Check the AIDF repository against its own rules.
#
# Usage:  reference/scripts/check-consistency.sh
# Exit:   0 consistent · 1 problems found · 2 could not run
#
# The v1 review of this framework found eight internal contradictions -- three
# different lifecycles, a staging branch that both was and was not required, a
# taxonomy defined in three places. Every one of them was the kind of thing a
# script can catch. This is that script.

set -eu

ROOT=$(CDPATH= cd -- "$(dirname -- "$0")/../.." && pwd)
command -v python3 >/dev/null 2>&1 || { echo "aidf: python3 is required" >&2; exit 2; }

ROOT="$ROOT" python3 - <<'PY'
import os, re, sys

root = os.environ["ROOT"]
problems = []

def read(rel):
    with open(os.path.join(root, rel)) as fh:
        return fh.read()

def walk(exts=(".md",)):
    for base, dirs, files in os.walk(root):
        dirs[:] = [d for d in dirs if d not in {".git", "node_modules"}]
        for name in files:
            if name.endswith(exts):
                yield os.path.relpath(os.path.join(base, name), root)

# ---------------------------------------------------------------- version
version = read("VERSION").strip()
for rel, pattern in [("README.md", r"\*\*Version:\*\*\s*([0-9.]+)"),
                     ("AGENTS.md", r"v([0-9]+\.[0-9]+\.[0-9]+)"),
                     ("project.yaml", r"version:\s*([0-9.]+)"),
                     ("templates/project.yaml", r"version:\s*([0-9.]+)")]:
    try:
        found = re.search(pattern, read(rel))
    except FileNotFoundError:
        problems.append("%s: missing" % rel); continue
    if not found:
        problems.append("%s: no version string found" % rel)
    elif found.group(1) != version:
        problems.append("%s: version %s does not match VERSION (%s)" % (rel, found.group(1), version))

# ------------------------------------------------------------ broken links
link_re = re.compile(r"\[[^\]]*\]\(([^)]+)\)")
for rel in walk():
    src_dir = os.path.dirname(os.path.join(root, rel))
    for target in link_re.findall(read(rel)):
        target = target.split("#")[0].strip()
        if not target or target.startswith(("http://", "https://", "mailto:")):
            continue
        if not os.path.exists(os.path.normpath(os.path.join(src_dir, target))):
            problems.append("%s: broken link -> %s" % (rel, target))

# ------------------------------------------------------ one canonical lifecycle
# guide/03-workflow.md is the only file permitted to define lifecycle steps.
canonical = "guide/03-workflow.md"
if "canonical definition of the AIDF lifecycle" not in read(canonical):
    problems.append("%s: no longer declares itself canonical" % canonical)
for rel in ("diagrams/lifecycle.md", "diagrams/quality-gates.md"):
    if "canonical" not in read(rel).lower():
        problems.append("%s: must state which file it is derived from" % rel)

# GitFlow (main + develop + release/hotfix branches) is the default model as
# of v3.0.0 -- see standards/branching.md. A project may still opt out to
# trunk-based, but nothing in this repository should claim trunk-based is
# the only supported shape, or that a release/staging branch is disallowed.
for rel in walk():
    body = read(rel)
    if rel in (canonical, "standards/branching.md", "diagrams/deployment.md",
               "CHANGELOG.md", "reference/scripts/check-consistency.sh"):
        continue
    if re.search(r"no staging branch|staging branch.*not (?:in|part of) the default model", body):
        problems.append("%s: describes trunk-based as the only default model, which is stale since v3.0.0" % rel)

# -------------------------------------------------------- tag taxonomy
gates_doc = read("standards/quality-gates.md")
if "sole definition of the risk-tag taxonomy" not in gates_doc:
    problems.append("standards/quality-gates.md: no longer declares itself the sole tag definition")

defined = set(re.findall(r"^\| `([a-z-]+)` \|", gates_doc, re.M))
expected = {"ui","api","database","security","mcp-write","infra","dependency","release","docs"}
if defined != expected:
    problems.append("standards/quality-gates.md: tag table defines %s, expected %s"
                    % (sorted(defined), sorted(expected)))

schema_tags = set(re.findall(r'"(ui|api|database|security|mcp-write|infra|dependency|release|docs)"',
                             read("schemas/project.schema.json")))
if schema_tags != expected:
    problems.append("schemas/project.schema.json: tag enum drifted from the standard")

for rel in ("project.yaml", "templates/project.yaml"):
    # Only the `tags:` block declares risk tags. `adapters.enabled` is a
    # different list that happens to share a key name.
    block = re.search(r"^tags:\n((?:[ \t]+.*\n|\n)*)", read(rel), re.M)
    if not block:
        problems.append("%s: missing a `tags:` section" % rel); continue
    for listed in re.findall(r"^\s*(?:enabled|preview_required_for|track_c_forced_by):\s*\[([^\]]*)\]",
                             block.group(1), re.M):
        for name in (t.strip() for t in listed.split(",") if t.strip()):
            if name not in expected:
                problems.append("%s: tag '%s' is not defined in standards/quality-gates.md" % (rel, name))

# --------------------------------------------- deleted artifacts stay deleted
for gone, why in [("templates/change-classification.md", "classification is spec front matter"),
                  ("templates/seed-data-plan.md", "merged into templates/migration-plan.md")]:
    if os.path.exists(os.path.join(root, gone)):
        problems.append("%s: should not exist (%s)" % (gone, why))

# ---------------------------------------------- templates declare their track
for rel in walk():
    if not rel.startswith("templates/"):
        continue
    head = read(rel)[:400]
    if head.startswith("---") and "track:" not in head:
        problems.append("%s: front matter is missing a `track:` field" % rel)

# ------------------------------------------------------ adapters stay honest
# An adapter must not promise a command surface the repository does not ship.
for rel in (".claude/CLAUDE.md", ".codex/AGENTS.md", ".cursor/rules/aidf.mdc"):
    body = read(rel)
    if re.search(r"(?<!`)/(?:spec|plan|build|review|ship)\b", body) and \
       not os.path.isdir(os.path.join(root, os.path.dirname(rel), "commands")):
        problems.append("%s: advertises slash commands that this repository does not ship" % rel)

# ------------------------------------------------------------------- report
if problems:
    print("aidf: %d consistency problem%s\n" % (len(problems), "" if len(problems) == 1 else "s"))
    for p in sorted(problems):
        print("  - %s" % p)
    sys.exit(1)

print("aidf: consistent -- version %s, links resolve, one lifecycle, one taxonomy" % version)
PY
