#!/bin/bash
#
# Build all libraries at once
#
# Andrea Bartezzaghi, 15-Nov-2017
#

set -e

./build_cmake.sh

./build_openblas.sh

./build_boost.sh

./build_metis.sh

./build_parmetis.sh

./build_hdf5.sh

./build_suitesparse.sh

./build_trilinos.sh

