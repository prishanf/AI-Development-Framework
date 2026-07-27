#!/bin/sh
# AIDF's own test suite. Proves the gates work in both directions -- a control
# that only ever passes is not a control.
#
# Usage:  reference/scripts/self-test.sh
# Exit:   0 all assertions held · 1 a test failed

set -eu

ROOT=$(CDPATH= cd -- "$(dirname -- "$0")/../.." && pwd)
TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT
PASS=0
FAIL=0

ok()   { PASS=$((PASS+1)); printf '  ok   %s\n' "$1"; }
bad()  { FAIL=$((FAIL+1)); printf '  FAIL %s\n' "$1"; }

expect_pass() { # description, command...
  desc=$1; shift
  if "$@" >"$TMP/out" 2>&1; then ok "$desc"; else bad "$desc"; sed 's/^/       /' "$TMP/out"; fi
}
expect_fail() { # description, command...
  desc=$1; shift
  if "$@" >"$TMP/out" 2>&1; then bad "$desc (expected failure, got success)"; else ok "$desc"; fi
}

echo "manifest validation"
expect_pass "valid manifest is accepted" \
  sh "$ROOT/reference/scripts/validate-manifest.sh" "$ROOT/project.yaml"

sed 's/^  test: .*/  test: ""/' "$ROOT/project.yaml" > "$TMP/empty-command.yaml"
expect_fail "empty required command fails (not skipped)" \
  sh "$ROOT/reference/scripts/validate-manifest.sh" "$TMP/empty-command.yaml"

sed 's/^  integration_branch:/  integraton_branch:/' "$ROOT/project.yaml" > "$TMP/typo.yaml"
expect_fail "typo'd key fails instead of silently disabling a gate" \
  sh "$ROOT/reference/scripts/validate-manifest.sh" "$TMP/typo.yaml"

sed 's/^  enabled: \[ui,/  enabled: [made-up-tag, ui,/' "$ROOT/project.yaml" > "$TMP/badtag.yaml"
expect_fail "undefined risk tag is rejected" \
  sh "$ROOT/reference/scripts/validate-manifest.sh" "$TMP/badtag.yaml"

echo "evidence contract"
cat > "$TMP/ci.json" <<'JSON'
{ "schema_version": "1", "commit": "abc1234", "runner": "ci",
  "generated_at": "2026-07-26T00:00:00Z",
  "classification": { "track": "B", "risk": "standard", "tags": [] },
  "checks": [ { "name": "test", "command": "true", "exit_code": 0 } ],
  "gates":  [ { "name": "test", "status": "pass", "source": "ci" } ] }
JSON
expect_pass "corroborated evidence is accepted" \
  sh "$ROOT/reference/scripts/validate-evidence.sh" "$TMP/ci.json" "$ROOT/project.yaml"

sed 's/"runner": "ci"/"runner": "agent"/' "$TMP/ci.json" > "$TMP/agent.json"
expect_fail "agent-authored evidence CANNOT satisfy a gate" \
  sh "$ROOT/reference/scripts/validate-evidence.sh" "$TMP/agent.json" "$ROOT/project.yaml"

sed 's/"status": "pass"/"status": "not_run"/' "$TMP/ci.json" > "$TMP/notrun.json"
expect_fail "not_run does not count as pass (fail closed)" \
  sh "$ROOT/reference/scripts/validate-evidence.sh" "$TMP/notrun.json" "$ROOT/project.yaml"

cat > "$TMP/expired.json" <<'JSON'
{ "schema_version": "1", "commit": "abc1234", "runner": "ci",
  "generated_at": "2026-07-26T00:00:00Z",
  "classification": { "track": "B", "risk": "standard", "tags": [] },
  "checks": [],
  "gates": [ { "name": "test", "status": "waived", "source": "waiver",
    "waiver": { "approver": "lead", "reason": "flaky", "expires": "2020-01-01",
                "follow_up": "issue-1" } } ] }
JSON
expect_fail "expired waiver fails the build" \
  sh "$ROOT/reference/scripts/validate-evidence.sh" "$TMP/expired.json" "$ROOT/project.yaml"

cat > "$TMP/nowaiver.json" <<'JSON'
{ "schema_version": "1", "commit": "abc1234", "runner": "ci",
  "generated_at": "2026-07-26T00:00:00Z",
  "classification": { "track": "B", "risk": "standard", "tags": [] },
  "checks": [],
  "gates": [ { "name": "test", "status": "waived", "source": "waiver" } ] }
JSON
expect_fail "waiver without approver/expiry/follow-up is invalid" \
  sh "$ROOT/reference/scripts/validate-evidence.sh" "$TMP/nowaiver.json" "$ROOT/project.yaml"

echo
printf 'aidf self-test: %d passed, %d failed\n' "$PASS" "$FAIL"
[ "$FAIL" -eq 0 ]
