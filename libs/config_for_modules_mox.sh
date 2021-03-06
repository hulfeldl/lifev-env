#!/bin/bash
#
# Configuration file for the third part libraries compatible with the modules system at MOX
#
# Copy this file to "config.sh" and customize it for your needs
#
# Stefania Fresca, Simone di Gregorio, Francesco Regazzoni, 24-Nov-2017
#

# build type, can be "Release" or "Debug"
export BUILD_TYPE=Release

# compilers to use
export C_COMPILER=gcc
export CXX_COMPILER=g++
export FORTRAN_COMPILER=gfortran

export MPI_C_COMPILER=$mkToolchainBase/bin/mpicc
export MPI_CXX_COMPILER=$mkToolchainBase/bin/mpic++
export MPI_FORTRAN_COMPILER=$mkToolchainBase/bin/mpif90
export MPI_EXEC=$mkToolchainBase/bin/mpiexec

# wget, for downloading packages
export WGET=wget # uncomment this to enable downloads
#export WGET=echo # uncomment this to disable downloads

# main directory with all the libraries
SCRIPT_PATH=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
export LIBRARIES_DIR=$SCRIPT_PATH

# directory with all the packages
export PACKAGES_DIR=$LIBRARIES_DIR/packages
mkdir -p $PACKAGES_DIR

# directory with all the sources
export SOURCES_DIR=$LIBRARIES_DIR/sources
mkdir -p $SOURCES_DIR

# directory with all the builds
export BUILDS_DIR=$LIBRARIES_DIR/builds
mkdir -p $BUILDS_DIR

# directory with all the installs
export INSTALLS_DIR=$LIBRARIES_DIR/installs
mkdir -p $INSTALLS_DIR

# set number of parallel builds to use
export NUM_PROC=$(grep processor /proc/cpuinfo | wc -l)
if [ $NUM_PROC -gt 8 ]; then NUM_PROC=8; fi

#============================================================
#  CMake
#============================================================

# version to consider
export CMAKE_VERSION=3.9.4  # 12-Oct-2017
export CMAKE_VERSION_MAJOR=3.9
export CMAKE_INSTALL_DIR=${INSTALLS_DIR}/cmake-${CMAKE_VERSION}_install${BUILD_TYPE}

# uncomment this to use cmake provided by the system
export CMAKE_BIN=cmake

# uncomment this to use the freshly installed cmake to build
#export CMAKE_BIN=${CMAKE_INSTALL_DIR}/bin/cmake

#============================================================
#  BOOST
#============================================================

export BOOST_INSTALL_DIR=$mkBoostPrefix
export BOOST_INCLUDE_DIR=$mkBoostInc

#============================================================
#  BLAS + Lapack
#============================================================

export OPENBLAS_INSTALL_DIR=$mkOpenblasPrefix
export BLAS_LIBRARIES="${OPENBLAS_INSTALL_DIR}/lib/libopenblas.so;gfortran"

export LAPACK_LIBRARIES=${OPENBLAS_INSTALL_DIR}/lib/libopenblas.so

#============================================================
#  METIS
#============================================================

export METIS_INSTALL_DIR=$mkMetisPrefix
export METIS_INCLUDE_DIR=${METIS_INSTALL_DIR}/include
export METIS_LIB_DIR=${METIS_INSTALL_DIR}/lib
export METIS_LIBRARIES=${METIS_LIB_DIR}/libmetis.so

#============================================================
#  ParMETIS
#============================================================

export PARMETIS_INSTALL_DIR=$mkMetisPrefix
export PARMETIS_INCLUDE_DIR=${PARMETIS_INSTALL_DIR}/include
export PARMETIS_LIB_DIR=${PARMETIS_INSTALL_DIR}/lib
export PARMETIS_LIBRARIES="$PARMETIS_LIB_DIR/libparmetis.so;$METIS_LIB_DIR/libmetis.so"

#============================================================
#  HDF5
#============================================================

export HDF5_VERSION=1.8.19
export HDF5_VERSION_MAJOR=19
export HDF5_INSTALL_DIR=$mkHdf5Prefix
export HDF5_INCLUDE_DIR=${HDF5_INSTALL_DIR}/include
export HDF5_LIB_DIR=${HDF5_INSTALL_DIR}/lib

#============================================================
#  SuiteSparse
#============================================================

export SUITESPARSE_VERSION=4.5.4
export SUITESPARSE_INSTALL_DIR=$mkSuitesparsePrefix
export SUITESPARSE_INCLUDE_DIR=${SUITESPARSE_INSTALL_DIR}/include
export SUITESPARSE_LIB_DIR=${SUITESPARSE_INSTALL_DIR}/lib

#============================================================
#  Trilinos
#============================================================

export TRILINOS_VERSION=12.6.3
export TRILINOS_INSTALL_DIR=$mkTrilinosPrefix
export TRILINOS_INCLUDE_DIR=${TRILINOS_INSTALL_DIR}/include
export TRILINOS_LIB_DIR=${TRILINOS_INSTALL_DIR}/lib


#============================================================
#  VTK
#============================================================

export VTK_VERSION=8.1.1
export VTK_INSTALL_DIR=$mkVtkPrefix
export VTK_INCLUDE_DIR=${VTK_INSTALL_DIR}/include
export VTK_LIB_DIR=${VTK_INSTALL_DIR}/lib
export VTK_DIR=${VTK_LIB_DIR}/cmake/vtk-8.1

