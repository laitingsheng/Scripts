#!/bin/bash

conda_init() {
    # first install the gpg key
    curl https://repo.anaconda.com/pkgs/misc/gpgkeys/anaconda.asc | gpg --dearmor > conda.gpg
    install -o root -g root -m 644 conda.gpg /etc/apt/trusted.gpg.d/

    # add the conda repo
    echo "deb [arch=amd64] https://repo.anaconda.com/pkgs/misc/debrepo/conda stable main" > /etc/apt/sources.list.d/conda.list

    apt-get update
    apt-get -y install conda
}
