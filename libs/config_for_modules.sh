#!/bin/bash
#
# Configuration file for the third part libraries compatible with the modules system at MOX
#
# Copy this file to "config.sh" and customize it for your needs
#
# Stefania Fresca, Simone di Gregorio, Francesco Regazzoni, 24-Nov-2017
#

# build type, can be "Release" or "Debug"
BUILD_TYPE=Release

# compilers to use
C_COMPILER=gcc
CXX_COMPILER=g++
FORTRAN_COMPILER=gfortran

MPI_C_COMPILER=mpicc
MPI_CXX_COMPILER=mpic++
MPI_FORTRAN_COMPILER=mpif90
MPIEXEC=mpiexec

# wget, for downloading packages
WGET=wget # uncomment this to enable downloads
#WGET=echo # uncomment this to disable downloads

# main directory with all the libraries
SCRIPT_PATH=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
LIBRARIES_DIR=$SCRIPT_PATH

# directory with all the packages
PACKAGES_DIR=$LIBRARIES_DIR/packages
mkdir -p $PACKAGES_DIR

# directory with all the sources
SOURCES_DIR=$LIBRARIES_DIR/sources
mkdir -p $SOURCES_DIR

# directory with all the builds
BUILDS_DIR=$LIBRARIES_DIR/builds
mkdir -p $BUILDS_DIR

# directory with all the installs
INSTALLS_DIR=$LIBRARIES_DIR/installs
mkdir -p $INSTALLS_DIR

# set number of parallel builds to use
NUM_PROC=$(grep processor /proc/cpuinfo | wc -l)
if [ $NUM_PROC -gt 8 ]; then NUM_PROC=8; fi

#============================================================
#  CMake
#============================================================

# version to consider
CMAKE_VERSION=3.9.4  # 12-Oct-2017
CMAKE_VERSION_MAJOR=3.9
CMAKE_INSTALL_DIR=${INSTALLS_DIR}/cmake-${CMAKE_VERSION}_install${BUILD_TYPE}

# uncomment this to use cmake provided by the system
CMAKE_BIN=cmake

# uncomment this to use the freshly installed cmake to build
#CMAKE_BIN=${CMAKE_INSTALL_DIR}/bin/cmake

#============================================================
#  BOOST
#============================================================

BOOST_INSTALL_DIR=$mkBoostPrefix
BOOST_INCLUDE_DIR=$mkBoostInc

#============================================================
#  BLAS + Lapack
#============================================================

OPENBLAS_INSTALL_DIR=$mkOpenblasPrefix
BLAS_LIBRARIES=${OPENBLAS_INSTALL_DIR}/lib/libopenblas.so

LAPACK_LIBRARIES=${OPENBLAS_INSTALL_DIR}/lib/libopenblas.so

#============================================================
#  METIS
#============================================================

METIS_INSTALL_DIR=$mkMetisPrefix
METIS_INCLUDE_DIR=${METIS_INSTALL_DIR}/include
METIS_LIB_DIR=${METIS_INSTALL_DIR}/lib
METIS_LIBRARIES=${METIS_LIB_DIR}/libmetis.so

#============================================================
#  ParMETIS
#============================================================

PARMETIS_INSTALL_DIR=$mkMetisPrefix
PARMETIS_INCLUDE_DIR=${PARMETIS_INSTALL_DIR}/include
PARMETIS_LIB_DIR=${PARMETIS_INSTALL_DIR}/lib

#============================================================
#  HDF5
#============================================================

HDF5_VERSION=1.8.19
HDF5_VERSION_MAJOR=18
HDF5_INSTALL_DIR=$mkHdf5Prefix
HDF5_INCLUDE_DIR=${HDF5_INSTALL_DIR}/include
HDF5_LIB_DIR=${HDF5_INSTALL_DIR}/lib

#============================================================
#  SuiteSparse
#============================================================

SUITESPARSE_VERSION=4.5.6
#SUITESPARSE_VERSION=4.4.5
SUITESPARSE_INSTALL_DIR=$mkSuitesparsePrefix
SUITESPARSE_INCLUDE_DIR=${SUITESPARSE_INSTALL_DIR}/include
SUITESPARSE_LIB_DIR=${SUITESPARSE_INSTALL_DIR}/lib

#============================================================
#  Trilinos
#============================================================

TRILINOS_VERSION=12.12.1
#TRILINOS_VERSION=12.6.1
TRILINOS_INSTALL_DIR=$mkTrilinosPrefix
TRILINOS_INCLUDE_DIR=${TRILINOS_INSTALL_DIR}/include
TRILINOS_LIB_DIR=${TRILINOS_INSTALL_DIR}/lib
