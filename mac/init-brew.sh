#!/usr/bin/env bash

BREW_PACKAGES=$(cat $(pwd)/mac/brew/packages.brew.list)

#taps
brew tap homebrew/cask-versions

# install main packages
brew install $BREW_PACKAGES
brew link --force libpq
bash $(pwd)/mac/brew/brew-casks.sh