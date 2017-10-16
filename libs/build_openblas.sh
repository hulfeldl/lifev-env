#!/bin/bash
#
# Script to build OpenBLAS
# Webpage: http://www.openblas.net/
#
# Andrea Bartezzaghi, 10-Oct-2017
#

# load config
source config.sh

# stop on errors
set -e

# NOTE: version is specified in config.sh

# name to use
NAME=OpenBLAS-${OPENBLAS_VERSION}

# download package in temporary directory
PACKAGE=${NAME}.tar.gz
cd ${PACKAGES_DIR}
wget -c -O ${PACKAGE} "http://github.com/xianyi/OpenBLAS/archive/v${OPENBLAS_VERSION}.tar.gz"

# extract sources
cd ${SOURCES_DIR}
tar -xf ${PACKAGES_DIR}/${PACKAGE}

# enter build directory
BUILD_DIR=${BUILDS_DIR}/${NAME}_build${BUILD_TYPE}
mkdir -p ${BUILD_DIR}
cd ${BUILD_DIR}

# NOTE: install directory is specified in config.sh

# configure
SOURCE_DIR=${SOURCES_DIR}/${NAME}
${CMAKE_BIN} -DCMAKE_BUILD_TYPE=${BUILD_TYPE} \
      -DCMAKE_INSTALL_PREFIX=${OPENBLAS_INSTALL_DIR} \
      -DCMAKE_C_COMPILER:STRING=${C_COMPILER} \
      -DCMAKE_CXX_COMPILER:STRING=${CXX_COMPILER} \
      -DCMAKE_Fortran_COMPILER:STRING=${FORTRAN_COMPILER} \
      ${SOURCE_DIR}

# build
make -j${NUM_PROC}

# manual install
mkdir -v -p ${OPENBLAS_INSTALL_DIR}
mkdir -v -p ${OPENBLAS_INSTALL_DIR}/lib
cp -v lib/*.a ${OPENBLAS_INSTALL_DIR}/lib/

# exit build directory
cd ${LIBRARIES_DIR}

