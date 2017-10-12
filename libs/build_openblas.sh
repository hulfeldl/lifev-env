#!/bin/bash
#
# Script to build OpenBLAS
# Webpage: http://www.openblas.net/
#
# Andrea Bartezzaghi, 10-Oct-2017
#

# version to consider
VERSION=0.2.20  # 24-Jul-2017

# load config
source config.sh

# stop on errors
set -e

# download package in temporary directory
PACKAGE=v${VERSION}.tar.gz
mkdir -p temp
cd temp
wget -c "http://github.com/xianyi/OpenBLAS/archive/${PACKAGE}"
cd ..

# extract
tar -xf temp/$PACKAGE

# directory of the source files
SOURCE_DIR=OpenBLAS-${VERSION}

# directory of build
BUILD_DIR=openblas_build${BUILD_TYPE}

# directory of install
INSTALL_DIR=openblas_install${BUILD_TYPE}

# enter build directory
mkdir -p ${BUILD_DIR}
cd ${BUILD_DIR}

# configure
${CMAKE_BIN} -DCMAKE_BUILD_TYPE=${BUILD_TYPE} \
      -DCMAKE_INSTALL_PREFIX=${INSTALL_DIR} \
      -DCMAKE_C_COMPILER:STRING=${C_COMPILER} \
      -DCMAKE_CXX_COMPILER:STRING=${CXX_COMPILER} \
      -DCMAKE_Fortran_COMPILER:STRING=${FORTRAN_COMPILER} \
      ../${SOURCE_DIR}

# build
make -j${NUM_PROC}

# manual install
install -m 664 ${INSTALL_DIR}/lib
install -m 664 lib/*.a ${INSTALL_DIR}/lib

# exit build directory
cd ..

