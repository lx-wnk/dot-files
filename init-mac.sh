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
ln -sfn home/* ~
# install composer
curl https://getcomposer.org/download/2.0.13/composer.phar -o /usr/local/bin/composer
chmod +x /usr/local/bin/composer
# TODO: add zsh installation
