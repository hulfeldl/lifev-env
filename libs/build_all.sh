#!/bin/bash

set -e

./build_cmake.sh

./build_openblas.sh

./build_metis.sh

./build_parmetis.sh

./build_hdf5.sh

./build_suitesparse.sh

./build_trilinos.sh

