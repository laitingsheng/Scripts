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
    echo "Usage: (sudo) $0 [-$$OPT $$ARG]"
    echo "    -d distro"
    echo "    -l location"
    echo "    -m [true|false]"
}

distro=disco
location=au
miniconda=true

while getopts ":d:l:m:" opt; do
    case $opt in
        d )
            distro=$OPTARG
            ;;
        l )
            location=$OPTARG
            ;;
        m )
            miniconda=$OPTARG
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

info_echo "distro set to $distro"
info_echo "location set to $location"
info_echo "Miniconda will $([[ $miniconda = true ]] || printf "not ")be installed"

# add wsl.conf to /etc to enable permission bits on NTFS
install -o root -g root -m 644 ./wsl.conf /etc/

# containerisation is not supported yet
apt-get remove lxd lxd-client

source ./apt.sh

apt_init $location $distro && exit $?

apt_upgrade

if [ $miniconda = true ]
then
    source ../conda/conda.sh

    conda_init
fi
