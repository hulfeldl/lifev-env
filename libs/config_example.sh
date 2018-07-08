#!/bin/bash
#
# Example of configuration file for building the libraries
#
# Copy this file to "config.sh" and customize it for your needs
#
# Andrea Bartezzaghi, 15-Nov-2017
#

# build type, can be "Release" or "Debug"
export BUILD_TYPE=Release

# compilers to use
export C_COMPILER=gcc
export CXX_COMPILER=g++
export FORTRAN_COMPILER=gfortran

export MPI_C_COMPILER=mpicc
export MPI_CXX_COMPILER=mpic++
export MPI_FORTRAN_COMPILER=mpif90
export MPI_EXEC=mpiexec

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
#export CMAKE_BIN=cmake

# uncomment this to use the freshly installed cmake to build
export CMAKE_BIN=${CMAKE_INSTALL_DIR}/bin/cmake

#============================================================
#  BOOST
#============================================================

export BOOST_VERSION_1=1_65_1
export BOOST_VERSION_2=1.65.1
export BOOST_INSTALL_DIR=${INSTALLS_DIR}/boost_${BOOST_VERSION_1}_install${BUILD_TYPE}
export BOOST_INCLUDE_DIR=${BOOST_INSTALL_DIR}/include

#============================================================
#  BLAS + Lapack
#============================================================

export OPENBLAS_VERSION=0.2.20  # 24-Jul-2017
export OPENBLAS_INSTALL_DIR=${INSTALLS_DIR}/OpenBLAS-${OPENBLAS_VERSION}_install${BUILD_TYPE}
export BLAS_LIBRARIES="${OPENBLAS_INSTALL_DIR}/lib/libopenblas.a"
export BLAS_LIBRARIES_ADDITIONAL="gfortran"

export LAPACK_LIBRARIES="${OPENBLAS_INSTALL_DIR}/lib/libopenblas.a"

#============================================================
#  METIS
#============================================================

export METIS_VERSION=5.1.0
export METIS_INSTALL_DIR=${INSTALLS_DIR}/metis-${METIS_VERSION}_install${BUILD_TYPE}
export METIS_INCLUDE_DIR=${METIS_INSTALL_DIR}/include
export METIS_LIB_DIR=${METIS_INSTALL_DIR}/lib
export METIS_LIBRARIES=${METIS_LIB_DIR}/libmetis.a

#============================================================
#  ParMETIS
#============================================================

export PARMETIS_VERSION=4.0.3
export PARMETIS_INSTALL_DIR=${INSTALLS_DIR}/parmetis-${PARMETIS_VERSION}_install${BUILD_TYPE}
export PARMETIS_INCLUDE_DIR=${PARMETIS_INSTALL_DIR}/include
export PARMETIS_LIB_DIR=${PARMETIS_INSTALL_DIR}/lib

# NOTE: here we separate the two libraries by a semicolon; this works with CMake, but NOT
# with standard makefiles! be aware!
export PARMETIS_LIBRARIES="$PARMETIS_LIB_DIR/libparmetis.a;$METIS_LIB_DIR/libmetis.a"

#============================================================
#  HDF5
#============================================================

export HDF5_VERSION=1.8.19
export HDF5_VERSION_MAJOR=1.8
export HDF5_INSTALL_DIR=${INSTALLS_DIR}/hdf5-${HDF5_VERSION}_install${BUILD_TYPE}
export HDF5_INCLUDE_DIR=${HDF5_INSTALL_DIR}/include
export HDF5_LIB_DIR=${HDF5_INSTALL_DIR}/lib

#============================================================
#  SuiteSparse
#============================================================

export SUITESPARSE_VERSION=4.5.6
#export SUITESPARSE_VERSION=4.4.5
export SUITESPARSE_INSTALL_DIR=${INSTALLS_DIR}/suitesparse-${SUITESPARSE_VERSION}_install${BUILD_TYPE}
export SUITESPARSE_INCLUDE_DIR=${SUITESPARSE_INSTALL_DIR}/include
export SUITESPARSE_LIB_DIR=${SUITESPARSE_INSTALL_DIR}/lib

#============================================================
#  Trilinos
#============================================================

export TRILINOS_VERSION=12.12.1
#export TRILINOS_VERSION=12.6.1
export TRILINOS_INSTALL_DIR=${INSTALLS_DIR}/trilinos-${TRILINOS_VERSION}_install${BUILD_TYPE}
export TRILINOS_INCLUDE_DIR=${TRILINOS_INSTALL_DIR}/include
export TRILINOS_LIB_DIR=${TRILINOS_INSTALL_DIR}/lib

#============================================================
#  FEAP Wrapper
#============================================================

#export FEAPHOME8_2=${INSTALLS_DIR}/feap_install${BUILD_TYPE}

# cf also makefile.in.macosx
export FEAP_FFOPTFLAG="-O3 -ftree-vectorize -fdefault-integer-8 -Wall"
export FEAP_CCOPTFLAG="-O3 -ftree-vectorize -Wall"

export FW_CFLAGS="-std=c99 -pedantic -Wall  -fPIC -DPIC -DUSE_MPI"
export FW_CXXFLAGS='-Wall -ggdb3 -fPIC -DPIC -DUSE_MPI -I$(FDDP_INCLUDE_DIR)'

export FW_INSTALL_DIR=${INSTALLS_DIR}/feap_install${BUILD_TYPE}
export FW_INCLUDE_DIR=${FW_INSTALL_DIR}/include
export FW_LIB_DIR=${FW_INSTALL_DIR}/lib

