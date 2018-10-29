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
# for each module, uncomment and set to ON to force its inclusion, uncomment and
# set to OFF to disable it, leave commented to use the default setting

#ENABLE_ETA=ON

#ENABLE_ONEDFSI=ON

#ENABLE_LEVEL_SET=ON

#ENABLE_DARCY=ON

#ENABLE_NAVIER_STOKES=ON

#ENABLE_NAVIER_STOKES_BLOCKS=ON

#ENABLE_NAVIER_STOKES_MOX=ON

#ENABLE_STRUCTURE=ON

#ENABLE_ELECTROPHYSIOLOGY=ON

#ENABLE_FSI_BLOCKS=ON

#ENABLE_FSI=ON

#ENABLE_HEART=ON

#ENABLE_BC_INTERFACE=ON

#ENABLE_ZERO_DIMENSIONAL=ON

#ENABLE_MULTISCALE=ON

#ENABLE_INTEGRATED_HEART=ON

#ENABLE_REDUCED_BASIS=ON

#ENABLE_IGA=ON

# enable the compilation of the tests
ENABLE_TESTS=ON

# enable the compilation of the examples
ENABLE_EXAMPLES=ON

# set this to pass additional parameters to cmake
PARAMS=

