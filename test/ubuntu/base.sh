#!/usr/bin/env bash

# exit on error & prevent unset variable
set -eu

sudo bash ubuntu-base.sh $* -u $(whoami)
