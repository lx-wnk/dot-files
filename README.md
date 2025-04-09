# Dot files
A (Sometimes when I think about it) updated summary and script library for the setup of my mac.

It'll install most used programms for developers, add some configuration for `zsh` and other quality of life improvements

## What are dot files
> Dotfiles are configuration files for various programs, and they help those programs manage their functionality

What are they for me?
* (Base-) Configuration of my system
* Helper for needed programms to daily work with

## What does it do (exactly)
* Install packages via 
  * [brew](mac/brew/packages.brew.list) and [brew](mac/brew/brew-casks.sh)
  * [npm](mac/packages.npm.list)
  * [pip](mac/packages.pip.list)
* Development environments (nix, devenv, docker)
* Configure shell
  * For [zsh](./home/.zsh-custom.zsh)
  * For usage with [warp](https://github.com/warpdotdev/Warp)
  * Add custom shell [aliases](./home/shell.alias.sh)

## Contribution
You are free to fork, improve and optimize the current state. But keep in mind that this is for my personal use (so maybe add a few switches to prevent the installation of tools that not everyone needs).

Nevertheless, I would be grateful for contributions **and feedback**.