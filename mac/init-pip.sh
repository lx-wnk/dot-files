#!/usr/bin/env bash
set -euo pipefail

PIP_PACKAGES=$(cat mac/packages.pip.list)
pip install --user $PIP_PACKAGES
