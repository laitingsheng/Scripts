#!/bin/bash

# colours
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# logging levels
INFO="${YELLOW}INFO${NC}"
WARNING="${RED}WARNING${NC}"

apt_init() {
    if [ $# -ne 2 ]
    then
        printf "$WARNING: apt_init() takes three parameters\n"
        return -1
    fi

    # replace sources.list
    sources=/etc/apt/sources.list
    cp "$sources" "$sources.back"
    sed -i "s/\/archive\.ubuntu/\/$1\.archive\.ubuntu/g;s/$(lsb_release -c | awk -F\  '{printf $2}')/$2/g" $sources

    apt-get update

    apt-get -y install < apt.list
}

apt_upgrade() {
    apt-get -y dist-upgrade
    apt-get -y upgrade
}
