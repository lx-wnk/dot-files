#!/usr/bin/env bash

BREW_PACKAGES=$(cat mac/packages.brew.list)
brew install $BREW_PACKAGES
brew link --force libpq

# Install DDEV @see https://ddev.readthedocs.io/en/latest/users/install/ddev-installation/
brew install ddev/ddev/ddev
# Initialize mkcert
mkcert -install