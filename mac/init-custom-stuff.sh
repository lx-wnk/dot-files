#!/usr/bin/env bash

# atuin
bash <(curl --proto '=https' --tlsv1.2 -sSf https://setup.atuin.sh)

# install composer
curl https://getcomposer.org/download/latest-stable/composer.phar -o /usr/local/bin/composer
chmod +x /usr/local/bin/composer

# zsh is done via brew - not sure if the following is needed anymore
#sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Installs python2
#pyenv install 2

# vim plugins
#git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim

# install rosetta for compatibility
softwareupdate --install-rosetta

# install nix
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
zsh # need to reload shell here
echo "trusted-users = root ${USER}" | sudo tee -a /etc/nix/nix.conf && sudo pkill nix-daemon
nix-env -iA cachix -f https://cachix.org/api/v1/install
cachix use devenv
nix-env -if https://github.com/cachix/devenv/tarball/latest
cachix use fossar; cachix use shopware
brew install direnv