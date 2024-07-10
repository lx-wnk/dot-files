#!/bin/bash

echo 'Starting MacOS Software upgrade'
mas upgrade # app store updates

echo 'Starting Homebrew upgrade'
~/scripts/brew-upgrade.sh # brew upgrades
