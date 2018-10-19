#!/bin/bash
#
# Script to build VTK
#
# Marco Fedele, Ivan Fumagalli, 19-Oct-2018

# load config
configFilename="config.sh"
if [ $# -eq 1 ]; then
    configFilename=$1
fi
#Check the file is present
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
NAME=vtk-${VTK_VERSION}
TAG=${VTK_VERSION}

# extract sources
cd ${SOURCES_DIR}
if [ ! -d "${NAME}" ]; then
    git clone https://github.com/Kitware/VTK.git ${NAME}
    cd ${NAME}
    git fetch --all --tags
    git checkout tags/${TAG}
fi

# enter build directory
BUILD_DIR=${BUILDS_DIR}/${NAME}_build${BUILD_TYPE}
mkdir -p ${BUILD_DIR}
cd ${BUILD_DIR}

# NOTE: install directory is specified in config.sh

# configure
# VTK_Group_Rendering:BOOL=OFF and VTK_RENDERING_BACKEND:STRING=None
# the other options are the default
SOURCE_DIR=${SOURCES_DIR}/${NAME}
${CMAKE_BIN} \
      -D CMAKE_BUILD_TYPE=${BUILD_TYPE} \
      -D CMAKE_INSTALL_PREFIX=${VTK_INSTALL_DIR} \
      -D CMAKE_C_COMPILER:STRING=${MPI_C_COMPILER} \
      -D CMAKE_CXX_COMPILER:STRING=${MPI_CXX_COMPILER} \
      -D CMAKE_Fortran_COMPILER:STRING=${MPI_FORTRAN_COMPILER} \
      -D MPI_EXEC:STRING=${MPI_EXEC} \
      -D BUILD_SHARED_LIBS:BOOL=ON \
      -D BUILD_DOCUMENTATION:BOOL=OFF \
      -D BUILD_EXAMPLES:BOOL=OFF \
      -D BUILD_TESTING:BOOL=OFF \
      -D VTK_ANDROID_BUILD:BOOL=OFF \
      -D VTK_EXTRA_COMPILER_WARNINGS:BOOL=OFF \
      -D VTK_Group_Imaging:BOOL=OFF \
      -D VTK_Group_MPI:BOOL=OFF \
      -D VTK_Group_Qt:BOOL=OFF \
      -D VTK_Group_Rendering:BOOL=OFF \
      -D VTK_Group_StandAlone:BOOL=ON \
      -D VTK_Group_Tk:BOOL=OFF \
      -D VTK_Group_Views:BOOL=OFF \
      -D VTK_Group_Web:BOOL=OFF \
      -D VTK_IOS_BUILD:BOOL=OFF \
      -D VTK_RENDERING_BACKEND:STRING=None \
      -D VTK_USE_LARGE_DATA:BOOL=OFF \
      -D VTK_WRAP_JAVA:BOOL=OFF \
      -D VTK_WRAP_PYTHON:BOOL=OFF \
      -D VTK_WRAP_TCL:BOOL=OFF \
      ${SOURCE_DIR}

# build and install
make -j${NUM_PROC} install

# exit build directory
cd ${LIBRARIES_DIR}

