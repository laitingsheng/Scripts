#!/usr/bin/env bash

DIR=`dirname ${BASH_SOURCE[0]}`

source ${DIR}/general.bash

source ${DIR}/lists/desktop.bash
source ${DIR}/lists/refresh.bash

# System
xargs apt-get install -fy <<- EOL
ubuntu-minimal
ubuntu-standard
ubuntu-server
kubuntu-desktop
kubuntu-restricted-extras
kde-standard
kdeadmin
kdenetwork
kdepim
kdesdk
kdeutils
linux-generic-hwe-20.04
grub-efi
shim-signed
locales-all
language-pack-kde-en
language-pack-kde-zh-hans
language-pack-kde-zh-hant
fonts-noto
errno
parallel
expect
tree
p7zip-full
EOL

# Development
xargs apt-get install -fy <<- EOL
build-essential
cmake-extras
meson
gcc-multilib
g++-multilib
gcc-opt
uuid-dev
uuid-runtime
gdc
gcovr
flex
bison
git-all
git-ftp
git-lfs
subversion
ruby-all-dev
python3-all-dbg
python3-pip
python3-venv
python3-pygments
python3-coverage-test-runner
mypy
cython3-dbg
pycodestyle
jupyter
gradle
maven
openjdk-8-jdk
openjdk-11-jdk
haskell-platform
haskell-stack
valgrind-dbg
mono-complete
lldb
llvm-dev
ldc
clang
clang-format
clang-tidy
clang-tools
clangd
texlive
texlive-full
gccgo
golang
gnugo
npm
julia
nvidia-cuda-toolkit-gcc
EOL

# Libraries
xargs apt-get install -fy <<- EOL
libboost-all-dev
libyaml-cpp-dev
libfmt-dev
intel-mkl-full
python3-ddt
python3-keras
python3-sklearn-pandas
python3-skimage
python3-seaborn
python3-matplotlib-dbg
python3-py
python3-pytools
python3-selenium
python3-pythonmagick
python3-mpi4py-dbg
node-react
node-typescript-types
EOL

# Apps
xargs apt-get install -fy <<- EOL
azure-cli
dotnet-sdk-*
docker-ce
google-cloud-sdk
kubeadm
google-chrome-stable
steam
code
EOL

# Docs
xargs apt-get install -fy <<- EOL
gccgo-doc
gcc-doc
haskell-platform-doc
julia-doc
kubuntu-docs
libboost-doc
libfmt-doc
libtbb-doc
mypy-doc
openjdk-8-doc
openjdk-11-doc
python3-doc
EOL
