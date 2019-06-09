#!/bin/bash

# colours
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# logging levels
INFO="${YELLOW}INFO${NC}"
WARNING="${RED}WARNING${NC}"

apt_init() {
    if [ $# -ne 3 ]
    then
        printf "$WARNING: apt_init() takes three parameters\n"
        return -1
    fi

    # replace sources.list
    cp "$1" "$1.backup"
    sed -i "s/\/archive\.ubuntu/\/$2\.archive\.ubuntu/g;s/$(lsb_release -c | awk -F\  '{printf $2}')/$3/g" $1

    apt-get update
}

apt_install() {
    if [ $# -ne 1 ]
    then
        printf "$WARNING: apt_install() takes one parameter\n"
        return -1
    fi

    apt-get -y install < $1
}

apt_upgrade {
    apt-get -y dist-upgrade
    apt-get -y upgrade
}
