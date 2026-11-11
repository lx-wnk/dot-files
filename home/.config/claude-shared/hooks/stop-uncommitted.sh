#!/usr/bin/env bash
# Stop: report uncommitted changes when a turn ends.
# CLAUDE_STOP_UNCOMMITTED = warn (default) | block | off
#   warn  - show a message to the user, do not hold the agent
#   block - send the agent back once to commit (use for headless runs)
# Works with bash 3.2 (macOS). Without jq it does nothing.
set -uo pipefail

input=$(cat)
mode=${CLAUDE_STOP_UNCOMMITTED:-warn}
[ "$mode" = "off" ] && exit 0
command -v jq >/dev/null 2>&1 || exit 0

cwd=$(printf '%s' "$input" | jq -r '.cwd // empty')
[ -n "$cwd" ] || exit 0
cd "$cwd" 2>/dev/null || exit 0
git rev-parse --is-inside-work-tree >/dev/null 2>&1 || exit 0

count=$(git status --porcelain 2>/dev/null | wc -l | tr -d ' ')
[ "$count" -gt 0 ] || exit 0

msg="$count uncommitted change(s) in $(git rev-parse --show-toplevel). Commit them on a feature branch, or state why they stay uncommitted."

active=$(printf '%s' "$input" | jq -r '.stop_hook_active // false')
if [ "$mode" = "block" ] && [ "$active" != "true" ]; then
  echo "$msg" >&2
  exit 2
fi

jq -n --arg m "Warning: $msg" '{systemMessage: $m}'
exit 0
