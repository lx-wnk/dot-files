#!/usr/bin/env bash
set -uo pipefail
cd "$(dirname "$0")/.."

PACKAGES=$(grep -vE '^\s*(#|$)' mac/packages.pip.list)

# Homebrew's Python marks itself externally managed (PEP 668), which rejects
# --user installs. Fall back rather than fail the whole bootstrap.
# shellcheck disable=SC2086
pip3 install --user $PACKAGES 2>/dev/null \
  || pip3 install --user --break-system-packages $PACKAGES
