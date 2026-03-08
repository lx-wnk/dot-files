# Dot files

A (sometimes when I think about it) updated summary and script library for the setup of my Mac.

It'll install most used programs for developers, add some configuration for `zsh` and other quality of life improvements.

## Prerequisites

- macOS
- Git
- Terminal access (Warp, Terminal.app, etc.)

## Quick Start

```bash
git clone <repo-url> ~/code/_privat/dot-files
cd ~/code/_privat/dot-files
make install
```

Or step by step:

```bash
make link    # Create symlinks only
make brew    # Install Homebrew packages only
make update  # Update all packages
make lint    # Run shellcheck on scripts
```

## Structure

```
.
├── Brewfile              # All Homebrew taps, formulae, and casks
├── Makefile              # Task runner (make help)
├── init-mac.sh           # Full setup script
├── home/                 # Files symlinked to ~/
│   ├── .gitconfig
│   ├── .zshrc
│   ├── .p10k.zsh
│   ├── .vimrc
│   ├── shell.alias.sh    # Custom aliases and functions
│   └── scripts/          # Helper scripts (~/scripts/)
└── mac/                  # macOS-specific installers
    ├── init-brew.sh
    ├── init-npm.sh
    ├── init-pip.sh
    └── init-custom-stuff.sh
```

## What does it do

- Install packages via [Brewfile](Brewfile), [npm](mac/packages.npm.list), and [pip](mac/packages.pip.list)
- Development environments (nix, devenv, docker)
- Configure shell
  - For [zsh](./home/.zshrc) with [Powerlevel10k](https://github.com/romkatv/powerlevel10k)
  - For usage with [Warp](https://github.com/warpdotdev/Warp)
  - Add custom shell [aliases](./home/shell.alias.sh)

## Contribution

You are free to fork, improve and optimize the current state. But keep in mind that this is for my personal use (so maybe add a few switches to prevent the installation of tools that not everyone needs).

Nevertheless, I would be grateful for contributions **and feedback**.
