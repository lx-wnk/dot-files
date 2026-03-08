#!/usr/bin/env bash
set -euo pipefail

# install brew (needs password)
command -v brew &>/dev/null || /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
# update pip
python3 -m pip install --upgrade pip
# install symfony cli
command -v symfony &>/dev/null || { curl -sS https://get.symfony.com/cli/installer | bash && mv ~/.symfony/bin/symfony /usr/local/bin/; }

# package installation
bash ./mac/init-brew.sh
bash ./mac/init-npm.sh
bash ./mac/init-pip.sh
bash ./mac/init-custom-stuff.sh

# create symlinks
DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"
for item in "$DOTFILES_DIR"/home/.* "$DOTFILES_DIR"/home/*; do
    name="$(basename "$item")"
    [[ "$name" == "." || "$name" == ".." ]] && continue
    ln -sfn "$item" "$HOME/$name"
done

# init folders
mkdir -p ~/code/_privat
mkdir -p ~/code/_work