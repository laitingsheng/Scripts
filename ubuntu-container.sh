#!/bin/bash

source ubuntu-base.sh || exit $?

info_echo "Adding Docker repo"
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $distro stable"
apt-get update
apt-get -y install docker-ce docker-ce-cli containerd.io
