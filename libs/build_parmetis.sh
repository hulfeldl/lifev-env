#!/bin/bash
#
# Script to build ParMETIS
#
# Andrea Bartezzaghi, 10-Oct-2017
#
# Modified: 
# Matthias Lange, 27-Jun-2017
# Added comand line interface argument for config file.

# load config
configFilename="config.sh"
if [ $# -eq 1 ]; then
	configFilename=$1
fi
#Check the file is presend
if [ ! -f "${configFilename}" ]; then
	echo "${configFilename} not found! Please copy config_example.sh to config.sh and customize it to your needs, or provide the full path to your config file." 
	exit 1
fi
# actually load source
source $configFilename


# NOTE: version is specified in config.sh

# name to use
NAME=parmetis-${PARMETIS_VERSION}

# download package in temporary directory
PACKAGE=${NAME}.tar.gz
cd ${PACKAGES_DIR}
if [ ! -f "$PACKAGE" ]; then
    $WGET -c "http://glaros.dtc.umn.edu/gkhome/fetch/sw/parmetis/${PACKAGE}" 
fi

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
      -DCMAKE_INSTALL_PREFIX=${PARMETIS_INSTALL_DIR} \
      -DCMAKE_C_COMPILER:STRING=${MPI_C_COMPILER} \
      -DCMAKE_CXX_COMPILER:STRING=${MPI_CXX_COMPILER} \
      -DGKLIB_PATH=${SOURCE_DIR}/metis/GKlib \
      -DMETIS_PATH=${SOURCE_DIR}/metis \
      -DOPENMP=ON \
      ${SOURCE_DIR} 

# build and install
make -j${NUM_PROC} install 

# exit build directory
cd ${LIBRARIES_DIR}

