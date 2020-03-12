#!/usr/bin/env bash

set -eu

xargs pacman -Syuu --noconfirm <<- EOL
git
svn
nano
gcc
mingw-w64-x86_64-boost
python2
python2-pip
python3
python3-pip
EOL
