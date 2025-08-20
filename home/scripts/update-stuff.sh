#!/usr/bin/env zsh

source ~/.zshrc

echo 'Starting MacOS Software upgrade'
mas upgrade # app store updates

echo 'upgrading oh-my-zsh'
omz update

echo 'Starting Homebrew upgrade'
~/scripts/brew-upgrade.sh
