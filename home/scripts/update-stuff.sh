#!/usr/bin/env zsh

source ~/.zshrc

#echo 'Starting MacOS Software upgrade'
#mas upgrade # app store updates # currently has some issues with xcode

echo 'upgrading oh-my-zsh'
omz update

echo 'Starting Homebrew upgrade'
~/scripts/brew-upgrade.sh

echo 'Starting npm upgrade'
# somehow node gets overwritten sometimes, so just in case
brew link node --overwrite
npm update -g
