#!/bin/bash
# Keeps the PM working while docs/project/status.yaml says "state: running".
# Blocks a stop only if status.yaml changed since the last block, so a PM that
# makes no progress is allowed to stop instead of looping forever.
set -euo pipefail

STATUS="docs/project/status.yaml"
MARKER=".claude/sdlc-stop.local"

[[ -f "$STATUS" ]] || exit 0
STATE=$(grep -m1 '^state:' "$STATUS" | awk '{print $2}' || true)
if [[ "$STATE" != "running" ]]; then
  rm -f "$MARKER"
  exit 0
fi

if [[ -f "$MARKER" && ! "$STATUS" -nt "$MARKER" ]]; then
  exit 0
fi

mkdir -p .claude
touch "$MARKER"
cat <<'JSON'
{"decision": "block", "reason": "SDLC PM: docs/project/status.yaml still says state: running. Continue the /sdlc:pm loop with the next item. If you need the user, set state: waiting_user and ask. If all work is done, set state: done."}
JSON
