#!/bin/bash
#
# Build all libraries at once
#
# Andrea Bartezzaghi, 15-Nov-2017
#
# Modified: 
# Matthias Lange, 27-Jun-2017
# Added comand line interface argument for config file.

set -e


# Remove from the list the packages that you already installed
PACKS=" cmake openblas boost metis parmetis hdf5 suitesparse trilinos"

for p in $PACKS; do
    echo building $p, outout to $p.out
    nohup ./build_$p.sh $1 > $p.out || ( echo error compiling $p && exit 1)
    echo built $p
done
