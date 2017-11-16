#!/bin/bash
#
# Example configuration file for LifeV
#
# Andrea Bartezzaghi, 14-Nov-2017
#

# LifeV source directory (lifev-release, lifev-dev, ...)
LIFEV=lifev-release

# additional postfix to add to the build directory
POSTFIX=

# build type, can either be "Release" or "Debug"
BUILD_TYPE=Release
#BUILD_TYPE=Debug

# module selection
# for each module, uncomment and set to 1 to force its inclusion, uncomment and
# set to 0 to disable it, leave commented to use the default setting

#ENABLE_ETA=1

#ENABLE_ONEDFSI=1

#ENABLE_LEVEL_SET=1

#ENABLE_DARCY=1

#ENABLE_NAVIER_STOKES=1

#ENABLE_NAVIER_STOKES_BLOCKS=1

#ENABLE_STRUCTURE=1

#ENABLE_ELECTROPHYSIOLOGY=1

#ENABLE_FSI_BLOCKS=1

#ENABLE_FSI=1

#ENABLE_HEART=1

#ENABLE_BC_INTERFACE=1

#ENABLE_ZERO_DIMENSIONAL=1

#ENABLE_MULTISCALE=1

#ENABLE_INTEGRATED_HEART=1

#ENABLE_REDUCED_BASIS=1

#ENABLE_IGA=1

# enable the compilation of the tests
ENABLE_TESTS=1

# enable the compilation of the examples
ENABLE_EXAMPLES=1

# set this to pass additional parameters to cmake
PARAMS=

