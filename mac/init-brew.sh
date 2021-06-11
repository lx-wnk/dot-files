#!/usr/bin/env bash

BREW_PACKAGES=$(cat mac/packages.brew.list)
brew install $BREW_PACKAGES
brew link --force libpq
