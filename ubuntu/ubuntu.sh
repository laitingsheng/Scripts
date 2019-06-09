#!/bin/bash

source ../print.sh

# check if current is root
if [[ $EUID -ne 0 ]]; then
    warning_printf "This script must be run as root, use \"sudo $0"
    [[ ! -z $@ ]] && printf " $*"
    echo "\" instead"
    exit 1
fi

print_usage() {
    echo "Usage: (sudo) $0 [[-$$OPT $$ARG]]"
    echo "    -a file path contains list of package to be installed"
    echo "    -d distro"
    echo "    -l location"
    echo "    -p sources.list path"
}

apt_list=$(pwd)/apt.list
distro=disco
location=au
source_path=$(pwd)/sources.list

while getopts ":a:c:d:p:s:" opt; do
    case $opt in
        a )
            apt_list=$OPTARG
            ;;
        d )
            distro=$OPTARG
            ;;
        l )
            location=$OPTARG
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

info_echo "location set to $location"
info_echo "distro set to $distro"
info_echo "sources.list path set to $source_path"

source ./apt.sh

apt_init $source_path $location $distro && exit $?

apt_install $apt_list

apt_upgrade
