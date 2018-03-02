#!/bin/bash
#
# Clone lifev
#
# Andrea Bartezzaghi, 19-Feb-2018
#

if [ "z$1" == "z-h" ]; then

    echo "Usage:"
    echo "./clone_lifev.sh <repo>"
    echo "if <repo> is not given. it is taken from lifev_config.sh"
    echo
    echo "Example: ./clone_lifev.sh lifev-release"
    exit 1
fi

if [ "$#" != "1" ]; then
    source lifev_config.sh
    REPO=$LIFEV
else
    REPO="$1"
fi

git clone git@bitbucket.org:lifev-dev/$REPO $REPO

