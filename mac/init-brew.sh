#!/usr/bin/env bash

BREW_PACKAGES=$(cat mac/packages.brew.list)

#taps
brew tap homebrew/cask-versions

# install main packages
brew install $BREW_PACKAGES
brew link --force libpq


#################
# Install casks #
#################

# Install DDEV @see https://ddev.readthedocs.io/en/latest/users/install/ddev-installation/
brew install ddev/ddev/ddev
# Initialize mkcert
mkcert -install

# install mail client from https://sparkmailapp.com/download (v3)
#brew install --cask readdle-spark

# install shell from https://github.com/vercel/hyper
brew install --cask hyper

# install spotify
brew install --cask spotify

# install code editors
brew install --cask visual-studio-code
#brew install --cask phpstorm # due to broken 2024.1 version, I installed the latest 2023
brew install --cask https://raw.githubusercontent.com/Homebrew/homebrew-cask/5b134dfb0249181b8a4a345b1776a23d05eb8377/Casks/p/phpstorm.r

# install zoom
brew install --cask zoom

## chat clients
brew install --cask slack
brew install --cask discord

# copy&paste history
brew install --cask flycut

# window manager
brew install --cask rectangle

# Workspace organizer
brew tap ferdium/ferdium
brew install ferdium

# translator
brew install --cask deepl

# docker desktop
brew install --cask docker

# browser
## arc browser
brew install --cask arc
## brave browser
brew install --cask brave-browser