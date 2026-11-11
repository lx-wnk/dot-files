#!/usr/bin/env bash
# Install the brew formulae and casks listed in mac/brew/.
set -uo pipefail
cd "$(dirname "$0")/.."

# homebrew/cask-versions was deprecated and removed by Homebrew; versioned casks
# now live in homebrew/cask. Nothing to tap.

# shellcheck disable=SC2046
brew install $(grep -vE '^\s*(#|$)' mac/brew/packages.brew.list)
brew link --force libpq
bash ./mac/brew/brew-casks.sh
