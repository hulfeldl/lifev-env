#!/bin/bash
#
# Script to build HDF5
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
NAME=hdf5-${HDF5_VERSION}

# download package in temporary directory
PACKAGE=${NAME}.tar.gz
cd ${PACKAGES_DIR}
if [ ! -f "$PACKAGE" ]; then
    $WGET -c "https://support.hdfgroup.org/ftp/HDF5/releases/hdf5-${HDF5_VERSION_MAJOR}/hdf5-${HDF5_VERSION}/src/${PACKAGE}"  || exit 1
fi

# extract sources
cd ${SOURCES_DIR}
tar -xf ${PACKAGES_DIR}/${PACKAGE}  || exit 1

# enter build directory
BUILD_DIR=${BUILDS_DIR}/${NAME}_build${BUILD_TYPE}
mkdir -p ${BUILD_DIR}
cd ${BUILD_DIR}

# NOTE: install directory is specified in config.sh

# configure
SOURCE_DIR=${SOURCES_DIR}/${NAME}
${CMAKE_BIN} -DCMAKE_BUILD_TYPE=${BUILD_TYPE} \
      -DCMAKE_INSTALL_PREFIX=${HDF5_INSTALL_DIR} \
      -DCMAKE_C_COMPILER:STRING=${MPI_C_COMPILER} \
      -DCMAKE_CXX_COMPILER:STRING=${MPI_CXX_COMPILER} \
      -DHDF5_ENABLE_PARALLEL=ON \
      -DHDF5_BUILD_CPP_LIB=OFF \
      ${SOURCE_DIR}  || exit 1

# build and install
make -j${NUM_PROC} install  || exit 1

# exit build directory
cd ${LIBRARIES_DIR}

