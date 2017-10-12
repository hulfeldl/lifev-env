#!/bin/bash
#
# Script to build OpenBLAS
# Webpage: http://www.openblas.net/
#
# Andrea Bartezzaghi, 10-Oct-2017
#

# version to consider
VERSION=4.0.3

# load config
source config.sh

# stop on errors
set -e

# download package in temporary directory
PACKAGE="parmetis-${VERSION}.tar.gz"
mkdir -p temp
cd temp
wget -c "http://glaros.dtc.umn.edu/gkhome/fetch/sw/parmetis/${PACKAGE}"
cd ..

# extract
tar -xf temp/$PACKAGE

# get current directory
CUR_DIR=$(pwd)

# directory of the source files
SOURCE_DIR=${CUR_DIR}/parmetis-${VERSION}

# directory of build
BUILD_DIR=${CUR_DIR}/parmetis_build${BUILD_TYPE}

# directory of install
INSTALL_DIR=${CUR_DIR}/parmetis_install${BUILD_TYPE}

# enter build directory
mkdir -p ${BUILD_DIR}
cd ${BUILD_DIR}

# configure
${CMAKE_BIN} -DCMAKE_BUILD_TYPE=${BUILD_TYPE} \
      -DCMAKE_INSTALL_PREFIX=${INSTALL_DIR} \
      -DCMAKE_C_COMPILER:STRING=${MPI_C_COMPILER} \
      -DCMAKE_CXX_COMPILER:STRING=${MPI_CXX_COMPILER} \
      -DGKLIB_PATH=${SOURCE_DIR}/metis/GKlib \
      -DMETIS_PATH=${SOURCE_DIR}/metis \
      -DOPENMP=ON \
      ${SOURCE_DIR}

# build and install
make -j${NUM_PROC} install

# exit build directory
cd ${CUR_DIR}

