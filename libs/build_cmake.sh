#!/bin/bash
#
# Script to build OpenBLAS
# Webpage: http://www.openblas.net/
#
# Andrea Bartezzaghi, 10-Oct-2017
#

# version to consider
VERSION=3.9.4  # 12-Oct-2017
VERSION_MAJOR=3.9

# load config
source config.sh

# stop on errors
set -e

# download package in temporary directory
PACKAGE="cmake-${VERSION}.tar.gz"
mkdir -p temp
cd temp
wget -c --no-check-certificate "http://www.cmake.org/files/v${VERSION_MAJOR}/${PACKAGE}"
cd ..

# extract
tar -xf temp/$PACKAGE

# get current directory
CUR_DIR=$(pwd)

# directory of the source files
SOURCE_DIR=${CUR_DIR}/cmake-${VERSION}

# directory of build
BUILD_DIR=${CUR_DIR}/cmake_build${BUILD_TYPE}

# directory of install
INSTALL_DIR=${CUR_DIR}/cmake_install${BUILD_TYPE}

# enter build directory
mkdir -p ${BUILD_DIR}
cd ${BUILD_DIR}

# bootstrap
${SOURCE_DIR}/bootstrap --prefix=${INSTALL_DIR}

# build and install
make -j${NUM_PROCS} install

# exit build directory
cd ${CUR_DIR}

