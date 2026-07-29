#!/usr/bin/env bash
# First-run bootstrap for a fresh Mac: install tooling, then hand the whole
# symlink/config layout over to dotfiles-sync.sh.
#
# Everything idempotent lives in home/scripts/dotfiles-sync.sh — run that alone
# to re-align an existing machine. This script only does the one-time installs.
#
# Must be run from the repo root.
set -uo pipefail

cd "$(dirname "$0")"

# No `set -e`: a bootstrap step that is already satisfied should not abort the
# rest. step() makes the failure visible instead of swallowing it.
FAILED=()
step() {
  local label="$1"; shift
  echo ">> $label"
  if ! "$@"; then
    echo "!! failed: $label"
    FAILED+=("$label")
  fi
}

install_brew() {
  command -v brew >/dev/null && { echo "   already installed"; return 0; }
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
}

upgrade_pip() {
  command -v python3 >/dev/null || { echo "   no python3 yet"; return 0; }
  python3 -m pip install --upgrade pip 2>/dev/null \
    || python3 -m pip install --upgrade --break-system-packages pip
}

install_symfony_cli() {
  command -v symfony >/dev/null && { echo "   already installed"; return 0; }
  curl -sS https://get.symfony.com/cli/installer | bash || return 1
  # The installer has used ~/.symfony and ~/.symfony5 over time — take whichever exists.
  local bin
  for bin in "$HOME/.symfony5/bin/symfony" "$HOME/.symfony/bin/symfony"; do
    [ -x "$bin" ] || continue
    if [ -w /usr/local/bin ]; then
      ln -sfn "$bin" /usr/local/bin/symfony
    else
      sudo ln -sfn "$bin" /usr/local/bin/symfony
    fi
    return 0
  done
  echo "   installer produced no binary in ~/.symfony5/bin or ~/.symfony/bin"
  return 1
}

step "Homebrew"      install_brew
step "pip"           upgrade_pip
step "Symfony CLI"   install_symfony_cli

step "brew packages" bash ./mac/init-brew.sh
step "npm packages"  bash ./mac/init-npm.sh
step "pip packages"  bash ./mac/init-pip.sh
step "custom stuff"  bash ./mac/init-custom-stuff.sh

# Symlinks, Claude accounts, secret templates, base folders.
step "dotfiles sync" bash ./home/scripts/dotfiles-sync.sh

echo
if [ ${#FAILED[@]} -eq 0 ]; then
  echo "bootstrap complete"
else
  echo "bootstrap finished with ${#FAILED[@]} failed step(s):"
  printf '  - %s\n' "${FAILED[@]}"
  echo "Re-run this script, or fix them individually. dotfiles-sync.sh is safe to re-run alone."
fi
