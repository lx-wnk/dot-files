#!/usr/bin/env bash
# Bring this machine in line with the dot-files repo: symlinks, Claude accounts,
# secret templates, base folders. Safe to run repeatedly — it only reports and
# repairs drift, it never overwrites a filled-in secret file.
#
#   dotfiles-sync.sh            apply
#   dotfiles-sync.sh --dry-run  report what would change, touch nothing
#
# Called at the end of init-mac.sh, and usable standalone from anywhere:
# the repo root is derived from this script's real location, not from $PWD.
set -euo pipefail
shopt -s nullglob

DRY_RUN=0
case "${1:-}" in
  --dry-run) DRY_RUN=1 ;;
  "") ;;
  *) echo "usage: $(basename "$0") [--dry-run]" >&2; exit 64 ;;
esac

# Resolve a possibly-symlinked path without relying on `readlink -f`,
# which BSD/macOS readlink does not reliably provide.
resolve() {
  local p="$1" t
  while [ -L "$p" ]; do
    t="$(readlink "$p")"
    case "$t" in
      /*) p="$t" ;;
      *) p="$(dirname "$p")/$t" ;;
    esac
  done
  printf '%s\n' "$p"
}

REPO="$(cd "$(dirname "$(resolve "${BASH_SOURCE[0]}")")/../.." && pwd)"
[ -f "$REPO/init-mac.sh" ] || { echo "not a dot-files checkout: $REPO" >&2; exit 1; }

CHANGED=0
STAMP="$(date +%Y%m%d-%H%M%S)"

say() { printf '  %s\n' "$*"; }
act() { CHANGED=$((CHANGED + 1)); [ "$DRY_RUN" -eq 1 ] && say "would $*" || say "$*"; }

# Point $2 at $1. Idempotent: an already-correct link is left alone. A real file
# or directory in the way is moved aside rather than clobbered — that path is how
# a first run on a fresh machine meets the OS defaults.
link() {
  local src="$1" dst="$2"
  [ -e "$src" ] || { say "SKIP missing source: $src"; return 0; }
  if [ -L "$dst" ] && [ "$(resolve "$dst")" = "$(resolve "$src")" ]; then
    return 0
  fi
  if [ -e "$dst" ] && [ ! -L "$dst" ]; then
    act "back up $dst -> $dst.bak-$STAMP"
    [ "$DRY_RUN" -eq 1 ] || mv "$dst" "$dst.bak-$STAMP"
  fi
  act "link $dst -> $src"
  [ "$DRY_RUN" -eq 1 ] || ln -sfn "$src" "$dst"
}

seed() {
  local src="$1" dst="$2"
  [ -f "$dst" ] && return 0
  act "seed $dst from $(basename "$src") (fill in real values!)"
  [ "$DRY_RUN" -eq 1 ] && return 0
  mkdir -p "$(dirname "$dst")"
  cp "$src" "$dst"
  chmod 600 "$dst"
}

ensure_dir() {
  [ -d "$1" ] && return 0
  act "create $1"
  [ "$DRY_RUN" -eq 1 ] || mkdir -p "$1"
}

echo "dot-files sync — repo: $REPO"
[ "$DRY_RUN" -eq 1 ] && echo "(dry run — nothing is written)"

echo "home files"
for src in "$REPO"/home/*; do
  link "$src" "$HOME/$(basename "$src")"
done
for src in "$REPO"/home/.vimrc "$REPO"/home/.p10k.zsh "$REPO"/home/.zshrc "$REPO"/home/.git*; do
  link "$src" "$HOME/$(basename "$src")"
done

echo "XDG config"
ensure_dir "$HOME/.config"
# One loop, one mechanism. The previous version globbed, then `rm -rf`'d the
# basename — with an empty glob that expanded to `rm -rf $HOME/.config/*`.
# nullglob plus link() removes that failure mode entirely.
for src in "$REPO"/home/.config/*/; do
  link "${src%/}" "$HOME/.config/$(basename "$src")"
done

echo "Claude accounts"
for acct in personal work; do
  dir="$HOME/.claude-$acct"
  ensure_dir "$dir"
  link "$REPO/home/.claude-$acct/CLAUDE.md" "$dir/CLAUDE.md"
  link "$REPO/home/.claude-$acct/settings.json" "$dir/settings.json"
done
link "$HOME/.claude-personal" "$HOME/.claude"

echo "Claude secrets (never tracked)"
ensure_dir "$HOME/.config/claude"
seed "$REPO/dist/claude-common.env.dist" "$HOME/.config/claude/common.env"
for acct in personal work; do
  seed "$REPO/dist/claude-account.env.dist" "$HOME/.config/claude/$acct.env"
done

echo "base folders"
ensure_dir "$HOME/code/_privat"
ensure_dir "$HOME/code/_work"

echo
if [ "$CHANGED" -eq 0 ]; then
  echo "in sync — nothing to do"
elif [ "$DRY_RUN" -eq 1 ]; then
  echo "$CHANGED change(s) pending — re-run without --dry-run to apply"
else
  echo "$CHANGED change(s) applied"
fi
