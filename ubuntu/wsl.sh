#!/bin/bash

source ../print.sh

# check if current is root
if [[ $EUID -ne 0 ]]
then
    warning_printf "This script must be run as root, use \"sudo $0"
    [[ ! -z $@ ]] && printf " $*"
    echo "\" instead"
    exit 1
fi

print_usage() {
    echo "Usage: (sudo) $0 [-$$OPT [$$ARG]]"
    echo "    -a file path contains list of package to be installed"
    echo "    -c WSL config file path"
    echo "    -d distro"
    echo "    -l location"
    echo "    -m"
    echo "    -p sources.list path"
}

apt_list=$(pwd)/apt.list
config=$(pwd)/wsl.conf
distro=disco
location=au
miniconda=true
source_path=$(pwd)/sources.list

while getopts ":a:c:d:l:m:p:" opt; do
    case $opt in
        a )
            apt_list=$OPTARG
            ;;
        c )
            config=$OPTARG
            ;;
        d )
            distro=$OPTARG
            ;;
        l )
            location=$OPTARG
            ;;
        m )
            miniconda=$OPTARG
            ;;
        p )
            source_path=$OPTARG
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

info_echo "file for list of packages to be installed set to $apt_list"
info_echo "WSL configuration file path set to $config"
info_echo "distro set to $distro"
info_echo "location set to $location"
info_echo "Miniconda will $([[ $miniconda = true ]] || printf "not ")be installed"
info_echo "sources.list path set to $source_path"

# add wsl.conf to /etc to enable permission bits on NTFS
install -o root -g root -m 644 $config /etc/wsl.conf

# containerisation is not supported yet
apt-get remove lxd lxd-client

source ./apt.sh

apt_init $source_path $location $distro && exit $?

apt_install $apt_list

apt_upgrade

if [ $miniconda = true ]
then
    source ../conda/conda.sh

    conda_init
fi
