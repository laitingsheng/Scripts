#!/usr/bin/env bash

# exit on error
set -e

# disable interactive mode
export DEBIAN_FRONTEND=noninteractive

# test cases
while read cmd
do
    which $cmd
done <<- EOL
bash
sudo
crontab
gcc
g++
wget
curl
git
nano
parallel
htop
ifconfig
expect
tree
vim
vimtutor
EOL
