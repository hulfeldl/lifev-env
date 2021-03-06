#!/bin/bash
#
# Example configuration file for LifeV
#
# Andrea Bartezzaghi, 14-Nov-2017
#

# LifeV source directory (lifev-release, lifev-dev, ...)
LIFEV=lifev-epfl

# additional postfix to add to the build directory
POSTFIX=

# build type, can either be "Release" or "Debug"
BUILD_TYPE=Release
#BUILD_TYPE=Debug

# module selection
# for each module, uncomment and set to ON to force its inclusion, uncomment and
# set to OFF to disable it, leave commented to use the default setting

#ENABLE_ETA=ON

#ENABLE_ONEDFSI=ON

#ENABLE_LEVEL_SET=ON

#ENABLE_DARCY=ON

#ENABLE_NAVIER_STOKES=ON

ENABLE_NAVIER_STOKES_BLOCKS=ON

#ENABLE_STRUCTURE=ON

#ENABLE_ELECTROPHYSIOLOGY=ON

ENABLE_FSI_BLOCKS=ON

#ENABLE_FSI=ON

#ENABLE_HEART=ON

#ENABLE_BC_INTERFACE=ON

#ENABLE_ZERO_DIMENSIONAL=ON

#ENABLE_MULTISCALE=ON

ENABLE_INTEGRATED_HEART=ON

ENABLE_REDUCED_BASIS=OFF

ENABLE_IGA=ON

# enable the compilation of the tests
ENABLE_TESTS=ON

# enable the compilation of the examples
ENABLE_EXAMPLES=ON

# set this to pass additional parameters to cmake
PARAMS=

# pass isoglib TPL path

# current directory
CURDIR=$(pwd)

# directories of isoglib
ISOGLIB_BASE="$CURDIR/$LIFEV/iga/isoglib"
ISOGLIB_BUILD_DIR="$ISOGLIB_BASE/BuildRelease"
ISOGLIB_INCLUDE_DIR="$ISOGLIB_BUILD_DIR;$ISOGLIB_BASE"
ISOGLIB_LIB_DIR="$ISOGLIB_BUILD_DIR"
ISOGLIB_LIBRARIES="$ISOGLIB_LIB_DIR/libisoglib_epetra.a"
ISOGLIB_LIBRARIES="$ISOGLIB_LIBRARIES;$ISOGLIB_LIB_DIR/libisoglib_electrophysiology.a"
ISOGLIB_LIBRARIES="$ISOGLIB_LIBRARIES;$ISOGLIB_LIB_DIR/libisoglib.a"

# pass them to cmake
PARAMS="${PARAMS} -D isoGlib_INCLUDE_DIRS:PATH=$ISOGLIB_INCLUDE_DIR"
PARAMS="${PARAMS} -D isoGlib_LIBRARY_DIRS:PATH=$ISOGLIB_LIB_DIR"
PARAMS="${PARAMS} -D TPL_isoGlib_LIBRARIES:PATH=$ISOGLIB_LIBRARIES"

