#!/usr/bin/env bash
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
brew install --cask phpstorm

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

#screen recording software
brew install --cask kap

# browser
## arc browser
brew install --cask arc
## brave browser
brew install --cask brave-browser

# logitech configurator for mx vertical
#brew install --cask logi-options+ # can currently not be installed