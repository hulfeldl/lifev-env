#!/bin/bash
#
# Script to configure LifeV
#
# Custom settings are loaded from the provided 'lifev_config.sh' file
#
# Andrea Bartezzaghi, 10-Oct-2017
#

# load config
source libs/config.sh

# stop on errors
set -e

# provide default values
LIFEV=lifev-release

POSTFIX=

BUILD_TYPE=Release
#BUILD_TYPE=Debug

# load parameters from custom config file
if [ ! -f "lifev_config.sh" ]; then
    echo "ERROR: could not find lifev_config.sh with custom configuration!"
    exit 1
fi

source lifev_config.sh

# directories
SCRIPT_PATH=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
SOURCE_DIR=${SCRIPT_PATH}/${LIFEV}
if [ "$BUILD_TYPE" = "Debug" ]; then
  BUILD_DIR=${SOURCE_DIR}${POSTFIX}-debug
  INSTALL_DIR=${SOURCE_DIR}${POSTFIX}-installDebug
else
  BUILD_DIR=${SOURCE_DIR}${POSTFIX}-build
  INSTALL_DIR=${SOURCE_DIR}${POSTFIX}-install
fi

#TPL_MPI_INCLUDE_DIRS:STRING=/usr/lib/openmpi/include \
#    -D TPL_MPI_LIBRARIES:STRING=/usr/lib/openmpi/lib

# Trilinos packages "NOT found, some test might not compile properly":
# - NOX, thyra, teko, stratimikos, shylu 

# check config packages
PARAMS2=
if [ "$ENABLE_NAVIER_STOKES" != "" ]; then
    PARAMS2="${PARAMS2} -D LifeV_ENABLE_NavierStokes:BOOL=${ENABLE_NAVIER_STOKES}"
fi

# enter build directory
mkdir -p ${BUILD_DIR}
cd ${BUILD_DIR}

# configure
${CMAKE_BIN} -D CMAKE_BUILD_TYPE=${BUILD_TYPE} \
      -D CMAKE_INSTALL_PREFIX=${INSTALL_DIR} \
      -D CMAKE_C_COMPILER:STRING=${MPI_C_COMPILER} \
      -D CMAKE_CXX_COMPILER:STRING=${MPI_CXX_COMPILER} \
      -D CMAKE_Fortran_COMPILER:STRING=${MPI_FORTRAN_COMPILER} \
      -D MPI_EXEC=$MPI_EXEC \
      -D LifeV_ENABLE_CPP11:BOOL=ON \
      -D LifeV_ENABLE_STRONG_CXX_COMPILE_WARNINGS:BOOL=OFF \
      -D LifeV_ENABLE_ALL_PACKAGES:BOOL=OFF \
      -D LifeV_ENABLE_Core:BOOL=ON \
      -D LifeV_ENABLE_BCInterface:BOOL=OFF \
      -D LifeV_ENABLE_OneDFSI:BOOL=OFF \
      -D LifeV_ENABLE_LevelSet:BOOL=OFF \
      -D LifeV_ENABLE_Darcy:BOOL=OFF \
      -D LifeV_ENABLE_ZeroDimensional:BOOL=OFF \
      -D LifeV_ENABLE_Multiscale:BOOL=OFF \
      -D LifeV_ENABLE_IntegratedHeart:BOOL=OFF \
      -D LifeV_ENABLE_ETA:BOOL=${ENABLE_ETA} \
      -D LifeV_ENABLE_Structure:BOOL=OFF \
      -D LifeV_ENABLE_NavierStokesBlocks:BOOL=${ENABLE_NAVIER_STOKES_BLOCKS} \
      -D LifeV_ENABLE_FSI_blocks:BOOL=OFF \
      -D LifeV_ENABLE_Electrophysiology:BOOL=OFF \
      -D LifeV_ENABLE_FSI:BOOL=OFF \
      -D LifeV_ENABLE_Hearth:BOOL=OFF \
      -D LifeV_ENABLE_ReducedBasis:BOOL=${ENABLE_REDUCED_BASIS} \
      -D LifeV_ENABLE_IGA:BOOL=${ENABLE_IGA} \
      -D LifeV_ENABLE_TESTS:BOOL=${ENABLE_TESTS} \
      -D LifeV_ENABLE_EXAMPLES:BOOL=${ENABLE_EXAMPLES} \
      ${PARAMS2} \
      ${PARAMS} \
      -D TPL_ENABLE_MPI:BOOL=ON \
      -D TPL_ENABLE_HDF5:BOOL=ON \
      -D TPL_ENABLE_Boost:BOOL=ON \
      -D TPL_Boost_INCLUDE_DIRS:PATH=${BOOST_INCLUDE_DIR} \
      -D TPL_BLAS_LIBRARIES:PATH="${BLAS_LIBRARIES};gfortran" \
      -D TPL_LAPACK_LIBRARIES:PATH=${LAPACK_LIBRARIES} \
      -D TPL_METIS_INCLUDE_DIRS:PATH=${METIS_INCLUDE_DIR} \
      -D TPL_METIS_LIBRARY_DIRS:PATH=${METIS_LIB_DIR} \
      -D ParMETIS_INCLUDE_DIRS:PATH=${PARMETIS_INCLUDE_DIR} \
      -D ParMETIS_LIBRARY_DIRS:PATH=${PARMETIS_LIB_DIR} \
      -D HDF5_INCLUDE_DIRS:PATH=${HDF5_INCLUDE_DIR} \
      -D HDF5_LIBRARY_DIRS:PATH=${HDF5_LIB_DIR} \
      -D Trilinos_INCLUDE_DIRS:PATH=${TRILINOS_INCLUDE_DIR} \
      -D Trilinos_LIBRARY_DIRS:PATH=${TRILINOS_LIB_DIR} \
      ${SOURCE_DIR}

# build
#make -j${NUM_PROC}

