#!/bin/bash

source root-check.sh || exit $?

if uname -a | grep -q Microsoft
then
    # add wsl.conf to /etc to enable permission bits on NTFS for WSL
    curl https://gitlab.com/snippets/1864926/raw > wsl.conf
    install -o root -g root -m 644 ./wsl.conf /etc/
    rm wsl.conf

    # containerisation is not supported yet
    apt-get -y remove lxd lxd-client
fi

print_usage() {
    echo "Usage: (sudo) $0 -m -u"
    echo "    -m - install Miniconda"
    echo "    -u - update ubuntu"
}

miniconda=false
update=false

while getopts ":mu" opt; do
    case $opt in
        m )
            miniconda=true
            ;;
        u )
            update=true
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

# change to au server
sed -i "s/\/archive\.ubuntu/\/au\.archive\.ubuntu/g" /etc/apt/sources.list


[[ -z $update ]] || info_echo "Upgrading to new release" && do-release-upgrade -q

if [ $miniconda = true ]
then
    info_echo "Installing Miniconda 3"

    # first install the gpg key
    curl https://repo.anaconda.com/pkgs/misc/gpgkeys/anaconda.asc | gpg --dearmor > conda.gpg
    install -o root -g root -m 644 conda.gpg /etc/apt/trusted.gpg.d/

    # add the conda repo
    echo "deb [arch=amd64] https://repo.anaconda.com/pkgs/misc/debrepo/conda stable main" > /etc/apt/sources.list.d/conda.list
fi

apt-get update
curl https://gitlab.com/snippets/1864928/raw 2> /dev/null | apt-get -y install
apt-get -y install conda
apt-get -y dist-upgrade
apt-get -y upgrade

# Clone nano improved syntax highlight file
git clone https://github.com/scopatz/nanorc.git .nano
ln -s .nano/nanorc .nanorc
