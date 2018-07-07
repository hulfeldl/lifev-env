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
cd ${SOURCES_DIR}

echo 'MPI_FORTRAN_COMPILER =' ${MPI_FORTRAN_COMPILER} > makefile.in
echo 'MPI_C_COMPILER =' ${MPI_C_COMPILER} >> makefile.in
echo 'FEAP_FFOPTFLAG =' ${FEAP_FFOPTFLAG} >> makefile.in
echo 'FEAP_CCOPTFLAG =' ${FEAP_CCOPTFLAG} >> makefile.in
echo >> makefile.in

cat makefile.in.lifev-env >> makefile.in


# build inside sources


exit


# name to use
NAME=libfw

# download package in temporary directory
SOURCES_DIR=${NAME}
echo git clone git@bitbucket.org:codelartere/codelartere-libfw.git ${SOURCES_DIR}

# extract sources
cd ${SOURCES_DIR}


echo '# Location of FEAP-FW archive/
FEAP_FW_ARCHIVE=$(HOME)/workspace/feap-fw/libfeapfw_dbg.a/
FEAP_FW_ARCHIVE_DIR=$(dir $(FEAP_FW_ARCHIVE))
FEAP_FW_LIBRARY_NAME=feapfw_dbg ' > makefile.in
cat  makefile.in.lifev-env >> makefile.in

echo exiting
exit;

# enter build directory
BUILD_DIR=${BUILDS_DIR}/${NAME}_build${BUILD_TYPE}
mkdir -p ${BUILD_DIR}
cd ${BUILD_DIR}

# NOTE: install directory is specified in config.sh

# build and install
make -j${NUM_PROC} install


