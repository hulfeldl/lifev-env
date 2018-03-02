#!/bin/bash
#
# Script to build SuiteSparse
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
NAME=SuiteSparse-${SUITESPARSE_VERSION}

# download package in temporary directory
PACKAGE=${NAME}.tar.gz
cd ${PACKAGES_DIR}
if [ ! -f "$PACKAGE" ]; then
    $WGET -c "http://faculty.cse.tamu.edu/davis/SuiteSparse/${PACKAGE}" 
fi

# extract sources
cd ${SOURCES_DIR}
tar -xf ${PACKAGES_DIR}/${PACKAGE}
mv ${NAME} Trash
mv SuiteSparse/ ${NAME}

# enter build directory
BUILD_DIR=${BUILDS_DIR}/${NAME}_build${BUILD_TYPE}
mkdir -p ${BUILD_DIR}
cd ${BUILD_DIR}

# NOTE: install directory is specified in config.sh

# copy from source dir to build dir
SOURCE_DIR=${SOURCES_DIR}/${NAME}
cp -r ${SOURCE_DIR}/* .  

# build
export CUDA=no
export BLAS="${BLAS_LIBRARIES} -lpthread"
export LAPACK=$LAPACK_LIBRARIES
export MY_METIS_INC=$METIS_INCLUDE_DIR
export MY_METIS_LIB=$METIS_LIBRARIES

make -j${NUM_PROC} library    # for shared objects
#make -j${NUM_PROC} static  # for static libraries

# manual install
mkdir -p $SUITESPARSE_INSTALL_DIR
mkdir -p $SUITESPARSE_INSTALL_DIR/include
mkdir -p $SUITESPARSE_INSTALL_DIR/lib
export INSTALL_INCLUDE=${SUITESPARSE_INSTALL_DIR}/include
export INSTALL_LIB=${SUITESPARSE_INSTALL_DIR}/lib
make library install

# exit build directory
cd ${LIBRARIES_DIR}

