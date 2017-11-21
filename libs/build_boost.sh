#!/bin/bash
#
# Script to build BOOST
#
# Andrea Bartezzaghi, 21-Nov-2017
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
NAME=boost_${BOOST_VERSION_1}

# download package in temporary directory
PACKAGE=${NAME}.tar.gz
cd ${PACKAGES_DIR}
if [ ! -f "$PACKAGE" ]; then
    $WGET -c "https://dl.bintray.com/boostorg/release/${BOOST_VERSION_2}/source/${PACKAGE}"
fi

# extract sources
cd ${SOURCES_DIR}
tar -xf ${PACKAGES_DIR}/${PACKAGE}

# enter build directory
BUILD_DIR=${BUILDS_DIR}/${NAME}_build${BUILD_TYPE}
mkdir -p ${BUILD_DIR}
cd ${BUILD_DIR}

# copy the sources here
SOURCE_DIR=${SOURCES_DIR}/${NAME}
cp -r ${SOURCE_DIR}/* .

# NOTE: install directory is specified in config.sh

# bootstrap
./bootstrap.sh #--with-toolset=gcc

# stage
BOOST_PARAMS="--prefix=${BOOST_INSTALL_DIR} \
    --without-chrono --without-date_time --without-exception --without-filesystem \
    --without-iostreams --without-locale \
    --without-math --without-mpi --without-program_options --without-python --without-random \
    --without-regex --without-serialization --without-signals --without-system --without-test \
    --without-thread --without-timer --without-wave \
    --without-atomic --without-context --without-coroutine --without-fiber \
    --without-metaparse --without-stacktrace \
    --without-log"
./b2 ${BOOST_PARAMS} stage

# install
./b2 ${BOOST_PARAMS} install

# exit build directory
cd ${LIBRARIES_DIR}

