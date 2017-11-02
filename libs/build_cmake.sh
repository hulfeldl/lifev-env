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
NAME=cmake-${CMAKE_VERSION}

# download package in temporary directory
PACKAGE=${NAME}.tar.gz
cd ${PACKAGES_DIR}
$WGET -c --no-check-certificate "http://www.cmake.org/files/v${CMAKE_VERSION_MAJOR}/${PACKAGE}"

# extract sources
cd ${SOURCES_DIR}
tar -xf ${PACKAGES_DIR}/${PACKAGE}

# enter build directory
BUILD_DIR=${BUILDS_DIR}/${NAME}_build${BUILD_TYPE}
mkdir -p ${BUILD_DIR}
cd ${BUILD_DIR}

# NOTE: install directory is specified in config.sh

# bootstrap
SOURCE_DIR=${SOURCES_DIR}/${NAME}
${SOURCE_DIR}/bootstrap --prefix=${CMAKE_INSTALL_DIR}

# build and install
make -j${NUM_PROC} install

# exit build directory
cd ${LIBRARIES_DIR}

