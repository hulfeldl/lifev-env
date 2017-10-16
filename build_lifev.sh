#!/bin/bash
#
# Script to build OpenBLAS
# Webpage: http://www.openblas.net/
#
# Andrea Bartezzaghi, 10-Oct-2017
#

# load config
source libs/config.sh

# stop on errors
set -e

LIFEV=lifev-cmcs

BUILD_TYPE=Release
#BUILD_TYPE=Debug

# directories
SCRIPT_PATH=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
SOURCE_DIR=${SCRIPT_PATH}/${LIFEV}
if [ "$BUILD_TYPE" = "Debug" ]; then
  BUILD_DIR=${SOURCE_DIR}-debug
  INSTALL_DIR=${SOURCE_DIR}-installDebug
else
  BUILD_DIR=${SOURCE_DIR}-build
  INSTALL_DIR=${SOURCE_DIR}-install
fi

# enter build directory
mkdir -p ${BUILD_DIR}
cd ${BUILD_DIR}

#TPL_MPI_INCLUDE_DIRS:STRING=/usr/lib/openmpi/include \
#    -D TPL_MPI_LIBRARIES:STRING=/usr/lib/openmpi/lib

# Trilinos packages "NOT found, some test might not compile properly":
# - NOX, thyra, teko, stratimikos, shylu 

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
      -D LifeV_ENABLE_NavierStokes:BOOL=OFF \
      -D LifeV_ENABLE_ZeroDimensional:BOOL=OFF \
      -D LifeV_ENABLE_Multiscale:BOOL=OFF \
      -D LifeV_ENABLE_IntegratedHeart:BOOL=OFF \
      -D LifeV_ENABLE_ETA:BOOL=OFF \
      -D LifeV_ENABLE_Structure:BOOL=OFF \
      -D LifeV_ENABLE_NavierStokesBlocks:BOOL=OFF \
      -D LifeV_ENABLE_FSI_blocks:BOOL=OFF \
      -D LifeV_ENABLE_Electrophysiology:BOOL=OFF \
      -D LifeV_ENABLE_FSI:BOOL=OFF \
      -D LifeV_ENABLE_Hearth:BOOL=OFF \
      -D LifeV_ENABLE_TESTS:BOOL=ON \
      -D LifeV_ENABLE_EXAMPLES:BOOL=OFF \
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
make -j${NUM_PROC}

