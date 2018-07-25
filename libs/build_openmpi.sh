#!/bin/bash
#
# Script to build openMPI
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


# stop on errors
set -e

# NOTE: version is specified in config.sh

# name to use
NAME=openmpi-${OPENMPI_VERSION}

# download package in temporary directory
PACKAGE=${NAME}.tar.gz
cd ${PACKAGES_DIR}
if [ ! -f "$PACKAGE" ]; then
	$WGET -c --no-check-certificate "https://download.open-mpi.org/release/open-mpi/v${OPENMPI_VERSION_MAJOR}/${PACKAGE}"  
fi

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
${SOURCE_DIR}/configure --prefix=${OPENMPI_INSTALL_DIR} 

# build and install
make -j${NUM_PROC} install 

# exit build directory
cd ${LIBRARIES_DIR}

