#!/usr/bin/env bash

NPM_PACKAGES=$(cat mac/packages.npm.list)
npm i -g $NPM_PACKAGES
