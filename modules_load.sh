#!/bin/bash
#
# Script to load the modules needed by LifeV
#
# Francesco Regazzoni, 25-Nov-2017
#

echo "unloading modules..."

module purge

echo "loading toolchain..."

module load gcc-glibc/5

echo "loading modules..."

module load openblas boost metis hdf5 suitesparse trilinos

echo "done"
