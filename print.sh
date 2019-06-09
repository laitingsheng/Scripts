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
