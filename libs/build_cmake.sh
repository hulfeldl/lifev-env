#!/bin/bash
#
# Script to build cmake
#
# Andrea Bartezzaghi, 10-Oct-2017
#

# load config
if [ ! -f "config.sh" ]; then
    echo "config.sh not found! Please copy config_example.sh to config.sh and customize it to your needs."
    exit 1
fi
source config.sh

# stop on errors
set -e

# NOTE: version is specified in config.sh

# name to use
NAME=cmake-${CMAKE_VERSION}

# download package in temporary directory
PACKAGE=${NAME}.tar.gz
cd ${PACKAGES_DIR}
if [ ! -f "$PACKAGE" ]; then
    $WGET -c --no-check-certificate "http://www.cmake.org/files/v${CMAKE_VERSION_MAJOR}/${PACKAGE}"   || exit 1
fi

# extract sources
cd ${SOURCES_DIR}
tar -xf ${PACKAGES_DIR}/${PACKAGE}  || exit 1

# enter build directory
BUILD_DIR=${BUILDS_DIR}/${NAME}_build${BUILD_TYPE}
mkdir -p ${BUILD_DIR}  || exit 1
cd ${BUILD_DIR}

# NOTE: install directory is specified in config.sh

# bootstrap
SOURCE_DIR=${SOURCES_DIR}/${NAME}
${SOURCE_DIR}/bootstrap --prefix=${CMAKE_INSTALL_DIR}  || exit 1

# build and install
make -j${NUM_PROC} install  || exit 1

# exit build directory
cd ${LIBRARIES_DIR}

