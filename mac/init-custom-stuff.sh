#!/usr/bin/env bash

# atuin
bash <(curl --proto '=https' --tlsv1.2 -sSf https://setup.atuin.sh)
eval "$(atuin init zsh --disable-up-arrow)"

# install composer
curl https://getcomposer.org/download/2.0.13/composer.phar -o /usr/local/bin/composer
chmod +x /usr/local/bin/composer

# zsh is done via brew
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
echo "source $(brew --prefix)/share/powerlevel10k/powerlevel10k.zsh-theme" >>~/.zshrc