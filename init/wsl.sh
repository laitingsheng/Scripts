#!/usr/bin/env bash

set -eu

export DEBIAN_FRONTEND=noninteractive

dist=${1:-$(lsb_release -cs)}

install -o root -g root -m 644 ubuntu.sources.list.template /etc/apt/sources.list
sed -i "s|%REPO%|http://au.archive.ubuntu.com/ubuntu|g;s/%DIST%/${dist}/g" /etc/apt/sources.list
apt-get update
apt-get purge -fy lxd lxd-client snapd
apt list --installed | cut -d '/' -f1 | xargs apt-mark auto
xargs apt-get install -fy <<- EOL
ubuntu-minimal
ubuntu-standard
ubuntu-server
ubuntu-core-libs-dev
build-essential
cmake-extras
git-all
git-ftp
ruby
wsl
errno
parallel
expect
tree
p7zip
python
python-pip
python3
python3-pip
maven
libboost-all-dev
openjdk-8-jdk
openjdk-11-jdk
haskell-platform
haskell-stack
valgrind
lldb
llvm-dev
mono-complete
clang
clang-format
clang-tidy
clang-tools
texlive
texlive-full
gccgo
golang
gnugo
command-not-found-data
EOL

install -o root -g root -m 644 wsl.conf /etc/wsl.conf
apt-get install -fy ubuntu-wsl

curl -fsSL 'https://download.docker.com/linux/ubuntu/gpg' | apt-key add -
echo "deb https://download.docker.com/linux/ubuntu $dist stable" > /etc/apt/sources.list.d/docker.list
curl -s 'https://packages.cloud.google.com/apt/doc/apt-key.gpg' | apt-key add -
echo 'deb https://apt.kubernetes.io kubernetes-xenial main' > /etc/apt/sources.list.d/google.list
echo 'deb http://packages.cloud.google.com/apt cloud-sdk main' >> /etc/apt/sources.list.d/google.list
curl -sL 'https://packages.microsoft.com/keys/microsoft.asc' | gpg --dearmor > /etc/apt/trusted.gpg.d/microsoft.asc.gpg
wget -q "https://packages.microsoft.com/config/ubuntu/$(lsb_release -rs)/packages-microsoft-prod.deb" -O /tmp/packages-microsoft-prod.deb
echo "deb https://packages.microsoft.com/repos/azure-cli/ $dist main" > /etc/apt/sources.list.d/azure.list
dpkg -i /tmp/packages-microsoft-prod.deb
rm /tmp/packages-microsoft-prod.deb
xargs apt-get install -fy <<- EOL
docker-ce
kubeadm
google-cloud-sdk
azure-cli
EOL
kubectl completion bash > /etc/bash_completion.d/kubectl

# apt-get autoremove -y
apt-get dist-upgrade -fy
apt-get upgrade -fy

version=$(curl -fLs https://api.github.com/repos/docker/machine/releases/latest | grep 'tag_name' | cut -d '"' -f 4)
wget -O /tmp/docker-machine "https://github.com/docker/machine/releases/download/$version/docker-machine-Linux-x86_64"
install -o root -g root -m 755 /tmp/docker-machine /usr/local/bin/docker-machine
rm /tmp/docker-machine

SCRIPTS=(docker-machine-prompt.bash docker-machine-wrapper.bash docker-machine.bash)
parallel -d ' ' -j 200% " \
wget -O /tmp/{} https://raw.githubusercontent.com/docker/machine/$version/contrib/completion/bash/{} && \
install -o root -g root -m 644 /tmp/{} /etc/bash_completion.d/{} && \
rm /tmp/{} \
" ::: ${SCRIPTS[@]}

wget -O /tmp/skaffold 'https://storage.googleapis.com/skaffold/releases/latest/skaffold-linux-amd64'
install -o root -g root -m 755 /tmp/skaffold /usr/local/bin/skaffold
rm /tmp/skaffold
