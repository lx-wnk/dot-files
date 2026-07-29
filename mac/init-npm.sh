#!/usr/bin/env bash
set -uo pipefail
cd "$(dirname "$0")/.."

# shellcheck disable=SC2046
npm i -g $(grep -vE '^\s*(#|$)' mac/packages.npm.list)
