#!/usr/bin/env bash

wget -O /tmp/miniconda3.sh 'https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh'
sh /tmp/miniconda3.sh -bfut
rm /tmp/miniconda3.sh

~/miniconda3/bin/conda init
