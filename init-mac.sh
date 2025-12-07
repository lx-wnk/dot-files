#!/usr/bin/env bash

# install brew (needs password)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
# update pip
/usr/local/opt/python@3.9/bin/python3.9 -m pip install --upgrade pip
curl -sS https://get.symfony.com/cli/installer | bash
mv ~/.symfony/bin/symfony /usr/local/bin/

# package installation
bash ./mac/init-brew.sh
bash ./mac/init-npm.sh
bash ./mac/init-pip.sh
bash ./mac/init-custom-stuff.sh

# create symlinks
ln -sfn $(pwd)/home/* ~/
ln -sfn $(pwd)/home/.claude ~/.claude
ln -sfn $(pwd)/home/.vimrc ~/.vimrc
ln -sfn $(pwd)/home/.zsh* ~/.zsh*
ln -sfn $(pwd)/home/.p10k.zsh ~/.p10k.zsh
ln -sfn $(pwd)/home/.hyper* ~/.hyper*

# init folders
mkdir -p ~/code/_privat
mkdir -p ~/code/_work