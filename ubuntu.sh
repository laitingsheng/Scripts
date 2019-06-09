#!/bin/bash

# colours
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# logging levels
INFO="${YELLOW}INFO${NC}"
WARNING="${RED}WARNING${NC}"

info_echo() {
    printf "$INFO: $*\n"
}

info_printf() {
    printf "$INFO: $*"
}

warning_echo() {
    printf "$WARNING: $*\n"
}

warning_printf() {
    printf "$WARNING: $*"
}

# check if current is root
if [[ $EUID -ne 0 ]]
then
    warning_printf "This script must be run as root, use \"sudo $0"
    [[ ! -z $@ ]] && printf " $*"
    echo "\" instead"
    return 1
fi


if uname -a | grep -q Microsoft
then
    # add wsl.conf to /etc to enable permission bits on NTFS for WSL
    cat > wsl.conf <<- EOL
[automount]
enabled = true
root = /mnt/
options = "metadata,fmask=0133,dmask=0022"
mountFsTab = true

[network]
generateHosts = true
generateResolvConf = true

[interop]
enabled = true
appendWindowsPath = true
EOL
    info_echo "Adding wsl.conf to /etc"
    install -o root -g root -m 644 wsl.conf /etc/
    rm wsl.conf

    # containerisation is not supported yet
    info_echo "Removing lxd from the system for WSL"
    apt-get -y remove lxd lxd-client
fi

print_usage() {
    echo "Usage: (sudo) $0 -m -u"
}

location=au
distro=disco

while getopts ":d:l:mu" opt; do
    case $opt in
        d )
            distro=$OPTARG
            ;;
        l )
            location=$OPTARG
            ;;
        \? )
            print_usage
            exit 0
            ;;
        : )
            warning_echo "-$OPTARG requires an argument"
            print_usage
            exit 1
            ;;
    esac
done

# create a sources.list file
rm sources.list
for pool in $distro $distro-updates $distro-backports $distro-security
do
    echo "deb http://$location.archive.ubuntu.com/ubuntu/" $pool main restricted universe multiverse >> sources.list
done
echo "deb http://archive.canonical.com/ubuntu $distro partner" >> sources.list
cp /etc/apt/sources.list /etc/apt/sources.list.backup
install -o root -g root -m 644 sources.list /etc/apt/
rm sources.list

info_echo "Adding Miniconda repo"
# first install the gpg key
curl https://repo.anaconda.com/pkgs/misc/gpgkeys/anaconda.asc | gpg --dearmor > conda.gpg
install -o root -g root -m 644 conda.gpg /etc/apt/trusted.gpg.d/
# add the conda repo
echo "deb [arch=amd64] https://repo.anaconda.com/pkgs/misc/debrepo/conda stable main" > /etc/apt/sources.list.d/conda.list

info_echo "Refreshing the index and installing/upgrading packages"
apt-get update
# generate the list
cat > apt.list <<- EOL
gcc
g++
make
libboost-dev-all
clang
llvm
valgrind
gdb
lldb
openjdk-8-jdk
openjdk-11-jdk
haskell-platform
git
nano
moreutils
htop
net-tools
expect
tree
conda
EOL
apt-get -y install < apt.list
rm apt.list
# Upgrade the rest
apt-get -y dist-upgrade
apt-get -y upgrade

info_echo "Script finalised"
