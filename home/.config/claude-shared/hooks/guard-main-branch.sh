#!/usr/bin/env bash
# PreToolUse (Write|Edit|MultiEdit|NotebookEdit): block edits while main or master is checked out.
# Passes: gitignored paths (for example outputs/handoffs/), files outside a repository, detached HEAD.
# Works with bash 3.2 (macOS). Requires jq; without jq it blocks (fail closed).
set -uo pipefail

command -v jq >/dev/null 2>&1 || { echo "guard-main-branch: jq is required" >&2; exit 2; }

input=$(cat)
file=$(printf '%s' "$input" | jq -r '.tool_input.file_path // .tool_input.notebook_path // empty')
[ -n "$file" ] || exit 0

case "$file" in
  /*) ;;
  *)
    cwd=$(printf '%s' "$input" | jq -r '.cwd // empty')
    file="${cwd:-$PWD}/$file"
    ;;
esac

# The target directory may not exist yet: walk up to the nearest existing one.
dir=$(dirname "$file")
while [ ! -d "$dir" ] && [ "$dir" != "/" ]; do
  dir=$(dirname "$dir")
done

git -C "$dir" rev-parse --is-inside-work-tree >/dev/null 2>&1 || exit 0

branch=$(git -C "$dir" symbolic-ref --short -q HEAD || true)
case "$branch" in
  main | master) ;;
  *) exit 0 ;;
esac

git -C "$dir" check-ignore -q -- "$file" && exit 0

echo "Blocked: $file is on branch $branch. Create or check out a feature branch or worktree, then edit there." >&2
exit 2
