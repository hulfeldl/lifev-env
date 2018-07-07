#!/bin/bash
#
# Script to build codelartere-libfw
#
# Andrea Bartezzaghi, 07-07-2018
#

# main directory with all the libraries
SCRIPT_PATH=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
export LIBRARIES_DIR=$SCRIPT_PATH

# detect the operating system
source ${SCRIPT_PATH}/detect_os.sh

# load config
if [ ! -f "config.sh" ]; then
    echo "config.sh not found! Please copy config_example.sh to config.sh and customize it to your needs."
    exit 1
fi
source config.sh

# explicitly link to gfortran library on OSX (gfortran must be installed in the
# default directory)
if [ "$OSNAME" == "OSX" ]; then
    PARAMS="$PARAMS -D CMAKE_EXE_LINKER_FLAGS:STRING=${GFORTRAN_LIBRARIES}"
fi

# stop on errors
set -e

# NOTE: version is specified in config.sh


# name to use
NAME=feapfw

# download package in temporary directory
SOURCES_DIR=${NAME}
echo git clone git@bitbucket.org:codelartere/codelartere-feap-fw.git ${SOURCES_DIR}

# extract sources
pushd ${SOURCES_DIR}

echo 'MPI_FORTRAN_COMPILER =' ${MPI_FORTRAN_COMPILER} > makefile.in
echo 'MPI_C_COMPILER =' ${MPI_C_COMPILER} >> makefile.in
echo 'FEAP_FFOPTFLAG =' ${FEAP_FFOPTFLAG} >> makefile.in
echo 'FEAP_CCOPTFLAG =' ${FEAP_CCOPTFLAG} >> makefile.in
echo >> makefile.in

cat makefile.in.lifev-env >> makefile.in

# build inside sources
make -j${NUM_PROC}

FEAP_FW_ARCHIVE_DIR=$(pwd)

popd

# name to use
NAME=libfw

# download package in temporary directory
SOURCES_DIR=${NAME}
git clone git@bitbucket.org:codelartere/codelartere-libfw.git ${SOURCES_DIR}

# extract sources
pushd ${SOURCES_DIR}


echo 'MPI_FORTRAN_COMPILER =' ${MPI_FORTRAN_COMPILER} > makefile.in
echo 'MPI_C_COMPILER =' ${MPI_C_COMPILER} >> makefile.in
echo 'FEAP_FFOPTFLAG =' ${FEAP_FFOPTFLAG} >> makefile.in
echo 'FEAP_CCOPTFLAG =' ${FEAP_CCOPTFLAG} >> makefile.in

echo "# Location of FEAP-FW archive/
FEAP_FW_ARCHIVE=${FEAP_FW_ARCHIVE_DIR}/libfeapfw_dbg.a
FEAP_FW_ARCHIVE_DIR=${FEAP_FW_ARCHIVE_DIR}
FEAP_FW_LIBRARY_NAME=feapfw_dbg " >> makefile.in
cat  makefile.in.lifev-env >> makefile.in

make -j${NUM_PROC}


