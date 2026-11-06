#!/bin/bash
# Self-check for stop-guard.sh. Run: bash plugins/sdlc/hooks/test-stop-guard.sh
set -euo pipefail
HOOK="$(cd "$(dirname "$0")" && pwd)/stop-guard.sh"
cd "$(mktemp -d)"
run() { bash "$HOOK" < /dev/null; }

[[ -z "$(run)" ]] || { echo "FAIL: no status file should allow stop"; exit 1; }
mkdir -p docs/project
echo "state: waiting_user" > docs/project/status.yaml
[[ -z "$(run)" ]] || { echo "FAIL: waiting_user should allow stop"; exit 1; }
echo "state: running" > docs/project/status.yaml
run | grep -q '"block"' || { echo "FAIL: running should block"; exit 1; }
[[ -z "$(run)" ]] || { echo "FAIL: no progress should allow stop"; exit 1; }
sleep 1; touch docs/project/status.yaml
run | grep -q '"block"' || { echo "FAIL: progress should block again"; exit 1; }
echo "state: done" > docs/project/status.yaml
[[ -z "$(run)" && ! -f .claude/sdlc-stop.local ]] || { echo "FAIL: done should allow stop and clear marker"; exit 1; }
echo "PASS"
