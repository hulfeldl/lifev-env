#!/bin/bash
#
# Clone lifev
#
# Andrea Bartezzaghi, 19-Feb-2018
#

if [ "$#" != "1" ]; then
    echo "Usage:"
    echo "./clone_lifev.sh <repo>"
    echo
    echo "Example: ./clone_lifev.sh lifev-release"
    exit 1
fi

REPO="$1"

git clone git@bitbucket.org:lifev-dev/$REPO $REPO

