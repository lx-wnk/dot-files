#!/usr/bin/env bash
# One-time installs that are not covered by brew/npm/pip.
# Every step is guarded so a re-run is a no-op instead of a reinstall.
set -uo pipefail

# atuin
if command -v atuin >/dev/null; then
  echo ">> atuin already installed"
else
  bash <(curl --proto '=https' --tlsv1.2 -sSf https://setup.atuin.sh)
fi

# composer
if command -v composer >/dev/null; then
  echo ">> composer already installed"
else
  curl -fsSL https://getcomposer.org/download/latest-stable/composer.phar -o /usr/local/bin/composer \
    && chmod +x /usr/local/bin/composer
fi

# rosetta — only on Apple Silicon, and never interactively
if [ "$(uname -m)" = "arm64" ] && ! /usr/bin/pgrep -q oahd; then
  softwareupdate --install-rosetta --agree-to-license
else
  echo ">> rosetta not needed or already present"
fi

# nix
if command -v nix >/dev/null; then
  echo ">> nix already installed"
else
  curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install --no-confirm
fi

# trusted-users must be appended exactly once — `tee -a` on every run duplicated it
NIX_CONF=/etc/nix/nix.conf
if [ -f "$NIX_CONF" ] && sudo grep -q "^trusted-users = root ${USER}$" "$NIX_CONF"; then
  echo ">> nix trusted-users already set"
else
  echo "trusted-users = root ${USER}" | sudo tee -a "$NIX_CONF" >/dev/null && sudo pkill nix-daemon
fi

# devenv toolchain — needs nix on PATH, which the installer only adds to new shells
NIX_PROFILE=/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
# shellcheck disable=SC1090
[ -e "$NIX_PROFILE" ] && . "$NIX_PROFILE"

if command -v nix-env >/dev/null; then
  command -v cachix >/dev/null || nix-env -iA cachix -f https://cachix.org/api/v1/install
  cachix use devenv
  command -v devenv >/dev/null || nix-env -if https://github.com/cachix/devenv/tarball/latest
  cachix use fossar
  cachix use shopware
else
  echo "!! nix-env not on PATH — open a new shell and re-run this script for the devenv toolchain"
fi

brew install direnv
