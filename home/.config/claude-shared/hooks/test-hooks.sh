#!/usr/bin/env bash
# Self-test for the three hooks. Usage: bash test-hooks.sh [hooks-dir]
# Exit 0 when every case passes. Works with bash 3.2 (macOS).
# shellcheck disable=SC2016  # the test commands must reach the hooks unexpanded
set -uo pipefail

H=${1:-$(cd "$(dirname "$0")" && pwd)}
command -v jq >/dev/null 2>&1 || { echo "jq is required" >&2; exit 1; }
command -v git >/dev/null 2>&1 || { echo "git is required" >&2; exit 1; }

fail=0
total=0
report() { # want, got, description
  total=$((total + 1))
  if [ "$1" = "$2" ]; then
    printf 'PASS | %s\n' "$3"
  else
    printf 'FAIL | %s (want exit %s, got %s)\n' "$3" "$1" "$2"
    fail=$((fail + 1))
  fi
}

secrets() { # want, description, command
  local payload
  payload=$(jq -n --arg c "$3" '{tool_name:"Bash",tool_input:{command:$c}}')
  bash "$H/guard-secrets-bash.sh" <<<"$payload" 2>/dev/null
  report "$1" "$?" "secrets: $2"
}

secrets 2 "printenv" 'printenv'
secrets 2 "printenv VAR" 'printenv DHL_API_KEY'
secrets 2 "bare env piped" 'env | grep DHL'
secrets 0 "env VAR=x cmd" 'env FOO=1 make test'
secrets 2 "cat .env" 'cat .env'
secrets 2 "grep in .env.local" 'grep KEY config/.env.local'
secrets 0 "cat .env.example" 'cat .env.example'
secrets 0 "cat .envrc" 'cat .envrc'
secrets 0 "debug:container --env-vars" 'docker compose exec php bin/console debug:container --env-vars | grep KEY'
secrets 2 "echo secret variable" 'echo $DHL_API_KEY'
secrets 2 "echo braced secret" 'echo "key=${STRIPE_SECRET}"'
secrets 0 "existence check" 'echo "${DHL_API_KEY:+set}"'
secrets 0 "curl with key header" 'curl -sk -H "Authorization: Bearer $OBSIDIAN_API_KEY" "$OBSIDIAN_BASE_URL/vault/"'
secrets 0 "git status" 'git status --short'
secrets 0 "compose --env-file" 'docker compose --env-file .env up -d'
secrets 2 "source .env" 'source .env && make'
secrets 2 "multi-line cat .env" 'cd app
cat ".env"'
secrets 0 "word environment" 'echo environment ready'

R=$(mktemp -d)
trap 'rm -rf "$R"' EXIT
git -C "$R" init -q
git -C "$R" symbolic-ref HEAD refs/heads/main
printf 'outputs/\n' >"$R/.gitignore"
git -C "$R" add .gitignore
git -C "$R" -c user.email=test@example.com -c user.name=test commit -qm init

branch_guard() { # want, description, file
  local payload
  payload=$(jq -n --arg f "$3" --arg c "$R" '{tool_name:"Write",cwd:$c,tool_input:{file_path:$f}}')
  bash "$H/guard-main-branch.sh" <<<"$payload" 2>/dev/null
  report "$1" "$?" "main-branch: $2"
}

branch_guard 2 "tracked path on main" "$R/src/app.go"
branch_guard 0 "gitignored handoff on main" "$R/outputs/handoffs/latest.md"
branch_guard 2 "relative path on main" "README.md"
branch_guard 0 "outside any repository" "$(dirname "$R")/scratch-note-$$.md"
git -C "$R" checkout -q -b feat/x
branch_guard 0 "feature branch" "$R/src/app.go"
git -C "$R" checkout -q --detach
branch_guard 0 "detached HEAD" "$R/src/app.go"
git -C "$R" checkout -q feat/x

stop_hook() { # want, description, stop_hook_active, mode
  local payload
  payload=$(jq -n --arg c "$R" --argjson a "$3" '{cwd:$c,stop_hook_active:$a}')
  CLAUDE_STOP_UNCOMMITTED="$4" bash "$H/stop-uncommitted.sh" <<<"$payload" >/dev/null 2>&1
  report "$1" "$?" "stop: $2"
}

stop_hook 0 "clean tree, warn" false warn
echo x >"$R/new.txt"
stop_hook 0 "dirty tree, warn" false warn
stop_hook 2 "dirty tree, block" false block
stop_hook 0 "dirty tree, block, already continued" true block
stop_hook 0 "dirty tree, off" false off

echo "---"
echo "$((total - fail)) of $total passed"
[ "$fail" -eq 0 ]
