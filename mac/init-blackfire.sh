#!/usr/bin/env bash

mkdir -p /usr/local/var/run/
mkdir -p ~/blackfire

curl https://packages.blackfire.io/binaries/blackfire/2.2.0/blackfire-darwin_amd64.tar.gz -o ~/blackfire/blackfire-binaries.tar.gz
tar -zxf ~/blackfire/blackfire-binaries.tar.gz

curl https://packages.blackfire.io/binaries/blackfire-php/1.58.0/blackfire-php-darwin_amd64-php-70.so -o ~/blackfire/blackfire-70.so
curl https://packages.blackfire.io/binaries/blackfire-php/1.58.0/blackfire-php-darwin_amd64-php-71.so -o ~/blackfire/blackfire-71.so
curl https://packages.blackfire.io/binaries/blackfire-php/1.58.0/blackfire-php-darwin_amd64-php-72.so -o ~/blackfire/blackfire-72.so
curl https://packages.blackfire.io/binaries/blackfire-php/1.58.0/blackfire-php-darwin_amd64-php-73.so -o ~/blackfire/blackfire-73.so
curl https://packages.blackfire.io/binaries/blackfire-php/1.58.0/blackfire-php-darwin_amd64-php-74.so -o ~/blackfire/blackfire-74.so
curl https://packages.blackfire.io/binaries/blackfire-php/1.58.0/blackfire-php-darwin_amd64-php-80.so -o ~/blackfire/blackfire-80.so