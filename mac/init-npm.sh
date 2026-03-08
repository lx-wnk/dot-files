#!/usr/bin/env bash
set -euo pipefail

NPM_PACKAGES=$(cat mac/packages.npm.list)
npm i -g $NPM_PACKAGES
