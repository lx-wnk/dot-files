#!/usr/bin/env bash

PIP_PACKAGES=$(cat mac/packages.pip.list)
pip install --user $PIP_PACKAGES
