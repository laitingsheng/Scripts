#!/usr/bin/env bash

# exit on error & prevent unset variable
set -u

# disable interactive mode
export DEBIAN_FRONTEND=noninteractive

# source the common file
source utils.sh

# check if current is root
if [ $EUID -ne 0 ]
then
    warning_echo "This script must be run as root, use 'sudo $0$([ ! -z "$*" ] && printf " $*")' instead"
    exit 126
fi

print_usage()
{
    echo "Usage: (sudo) $0 [-d Ubuntu distribution] [-l location] [-r repository] [-u user]"
}

# default settings
dist='bionic'
loc='au'
eval declare -A prefixes=([conda]='/usr/local')
win_path='false'

test_url()
{
    curl -fILs "$1" > /dev/null
}

# parse options
while getopts ":d:hl:p:r:u:w" opt
do
    case $opt in
        d )
            dist=$OPTARG

            # validate $dist - validate pattern
            echo $dist | grep -Eq '^[a-z]+$'
            if [ $? -ne 0 ]
            then
                warning_echo "'$dist' should contain lowercase letters only"
                exit 1
            fi

            # validate $dist - validate if still support
            test_url http://releases.ubuntu.com/$dist
            if [ $? -ne 0 ]
            then
                warning_echo "'$dist' is not a valid distribution or no longer supported"
                exit 1
            fi
            ;;
        h)
            print_usage
            exit 0
            ;;
        l )
            loc=$OPTARG
            # validate $loc
            echo $loc | grep -Eq '^[a-z]+$'
            if [ $? -ne 0 ]
            then
                warning_echo "'$loc' is not a valid location"
                exit 1
            fi
            ;;
        p)
            eval declare -A prefixes=($(echo $OPTARG | sed 's/:/\n/' | awk -F= '{print "["$1"]="$2}'))
            for ind in "${!prefixes[@]}"
            do
                if [ ! -d "${prefixes[$ind]}" ]
                then
                    warning_echo "'$ind' has an invalid path '${prefixes[$ind]}'"
                    exit 1
                fi
            done
            ;;
        r )
            repo=$OPTARG

            test_url $repo
            if [ $? -ne 0 ]
            then
                warning_echo "'$repo' is not a valid repository URL"
                exit 1
            fi
            ;;
        u )
            user=$OPTARG

            id -u $user &> /dev/null
            if [ $? -ne 0 ]
            then
                warning_echo "'$user' is an invalid user name"
                exit 1
            fi
            ;;
        w )
            win_path='true'
            ;;
        \? )
            warning_echo "unknown argument '-$OPTARG'"
            print_usage
            exit 1
            ;;
        : )
            warning_echo "'-$OPTARG' requires an argument"
            print_usage
            exit 1
            ;;
    esac
done

# $user is mandatory
[ -z $user ] && warning_echo 'user was not set' && exit 1

# possible backup repositories
loc_repo=http://$loc.archive.ubuntu.com/ubuntu
default_repo=http://archive.ubuntu.com/ubuntu

# function to validate a given repository URL combined with the given distribution
POOLS=(backports proposed security updates)
test_repo()
{
    curl -fILs $1/dists/$2 > /dev/null && echo ${POOLS[@]} | xargs -d ' ' -i -n 1 bash -c "curl -fILs $1/dists/$2-{} > /dev/null"
}

# validate if $repo is set
if [ $repo ]
then
    test_repo $repo $dist
    if [ $? -ne 0 ]
    then
        warning_echo "'$repo' is not a valid repository, attempting '$loc_repo'"
        unset repo
    fi
fi
# use $loc_repo if $repo is unset
if [ -z $repo ]
then
    test_repo $loc_repo $dist
    [ $? -eq 0 ] && repo=$loc_repo || warning_echo "'$loc_repo' is not a valid URL, falling back to '$default_repo'"
fi
# falling back to $default_repo
if [ -z $repo ]
then
    test_repo $default_repo $dist
    if [ $? -ne 0 ]
    then
        warning_echo "'$default_repo' cannot be fetched, check the Internet connection before proceeding"
        exit 1
    else
        repo=$default_repo
    fi
fi

# WSL only
if uname -a | grep -q Microsoft
then
    # add wsl.conf to /etc/ for customised configuration
    info_echo 'Adding wsl.conf to /etc/'
    install -o root -g root -m 644 templates/wsl.conf.template /etc/wsl.conf
    sed -i "s/%INTEROP_APPEND_WINDOWS_PATH%/$win_path/" /etc/wsl.conf
fi

# generate sources.list from template
info_echo 'Updateing /etc/apt/sources.list'
install -o root -g root -m 644 templates/ubuntu.sources.list.template /etc/apt/sources.list
sed -i "s/%COMMAND%/deb/;s/%REPO%/$repo/;s/%DIST%/$dist/" /etc/apt/sources.list

# set timezone for tzdata
ln -fs /usr/share/zoneinfo/Australia/Melbourne /etc/localtime

# manage packages
info_echo 'Refreshing the index and installing/upgrading packages'
apt-get update
apt-get dist-upgrade -fy
apt-get upgrade -fy
apt-get install -fy bash sudo cron locales software-properties-common gcc g++ make wget curl perl git nano moreutils parallel htop net-tools expect tree vim python python-pip python3 python3-pip maven

# Generate & change locale
locale="en_$country.utf8"
info_echo "Changing locale to $locale"
locale-gen $locale
update-locale LANG=$locale LC_ALL=$locale LANGUAGE=$locale

# Remove Ubuntu builtin container
info_echo "Removing unnecessary lxd and snap"
apt-get purge lxd lxd-client snapd -fy

home=$(eval echo ~$user)

if [ -d $home ]
then
    # clone repo for nano syntax highlight
    old_dir=$(pwd)
    cd $home
    if [ -d .nano ]
    then
        info_echo ""
    else
        info_echo "Cloning nano rc repo"
        git clone https://github.com/scopatz/nanorc.git .nano
        chown -R $user:$user .nano
        chmod -R go-w .nano
        ln -fs .nano/nanorc .nanorc
        chown $user:$user .nanorc
    fi
    cd -
else
    info_echo "'$user' does not have home directory, ignoring step to download nanorc"
fi

info_echo "Base script finalised"
