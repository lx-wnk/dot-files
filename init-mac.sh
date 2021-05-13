#!/usr/bin/env bash

#install brew (needs password)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
# package installation
bash ./mac/init-brew.sh
bash ./mac/init-npm.sh
cp -r home/* ~/
# install composer
curl https://getcomposer.org/download/2.0.13/composer.phar -o /usr/local/bin/composer
chmod +x /usr/local/bin/composer
