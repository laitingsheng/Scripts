#!/usr/bin/env bash

source ubuntu/base.sh $* || exit $?

# install extra packages
xargs apt-get install -fy <<- EOL
libboost-all-dev
clang
clang-format
clang-tidy
clang-tools
llvm
valgrind
gdb
lldb
openjdk-8-jdk
openjdk-11-jdk
haskell-platform
haskell-stack
mono-complete
EOL

# official Docker repo
info_echo "Adding Docker repo"
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
echo "deb https://download.docker.com/linux/ubuntu $dist stable" >> /etc/apt/sources.list
apt-get update

info_echo "Installing Docker"
apt-get install -fy docker-ce docker-ce-cli containerd.io

# Miniconda 3
info_echo "downloading Miniconda 3"
wget -O /tmp/install.sh https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
info_echo "installing Miniconda 3"
sh /tmp/install.sh -bf -p /usr/local
rm -f /tmp/install.sh

# update/create conda environments
conda env update -f conda/linux/base.yml

info_echo "Desktop script finalised"
