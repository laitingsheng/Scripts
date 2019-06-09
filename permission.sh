#!/bin/bash

for f in $(find . -type f -name "*.sh")
do
    chmod a+x $f
done
