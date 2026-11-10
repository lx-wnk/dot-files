#!/usr/bin/env bash
# PreToolUse (Bash): block commands that are likely to print secret values.
# Heuristic: it reduces accidental exposure, it does not catch every case.
# Works with bash 3.2 (macOS). Requires jq; without jq it blocks (fail closed).
set -uo pipefail

command -v jq >/dev/null 2>&1 || { echo "guard-secrets-bash: jq is required" >&2; exit 2; }

cmd=$(jq -r '.tool_input.command // empty')
[ -n "$cmd" ] || exit 0

block() {
  echo "Blocked: $1 Check that the key exists, or print a masked value." >&2
  exit 2
}

# 1. printenv, or a bare `env`, prints environment values.
if printf '%s\n' "$cmd" | grep -Eq '(^|[;&|(]|[[:space:]])printenv([[:space:]]|[;&|)]|$)'; then
  block "printenv prints environment values."
fi
if printf '%s\n' "$cmd" | grep -Eq '(^|[;&|(])[[:space:]]*env[[:space:]]*([;&|)]|$)'; then
  block "A bare env prints the whole environment."
fi

# 2. echo/printf of a variable whose name looks like a secret.
#    The existence check ${NAME:+set} is allowed.
stripped=$(printf '%s\n' "$cmd" | sed -E 's/\$\{[A-Za-z_][A-Za-z0-9_]*:\+[^}]*\}//g')
if printf '%s\n' "$stripped" | grep -Eq '(^|[;&|(]|[[:space:]])(echo|printf)[[:space:]][^;&|]*\$\{?[A-Za-z0-9_]*(KEY|SECRET|TOKEN|PASSWORD|PASSWD)'; then
  block "The command prints a secret-named variable."
fi

# 3. A reader command applied to a .env file. Template files pass.
readers='cat|less|more|head|tail|bat|nl|grep|rg|awk|sed|strings|xxd|source'
if printf '%s\n' "$cmd" | grep -Eq "(^|[;&|(]|[[:space:]])(($readers)|\\.)[[:space:]]"; then
  while IFS= read -r word; do
    base=${word##*/}
    case "$base" in
      .env | .env.*) ;;
      *) continue ;;
    esac
    case "$base" in
      *.example | *.dist | *.sample | *.template) continue ;;
    esac
    block "The command reads $base."
  done <<WORDS
$(printf '%s\n' "$cmd" | tr -s "[:space:];&|()<>=\"'" '\n')
WORDS
fi

exit 0
