#!/bin/bash
#
# Script to configure LifeV
#
# Custom settings are loaded from the provided 'lifev_config.sh' file, or from
# the configuration file passed by argument
#
# Andrea Bartezzaghi, 14-Nov-2017
#


# check arguments
CONFIG_FILE="lifev_config.sh"
if [ "$#" -ge "1" ]; then
    CONFIG_FILE="$1"
fi

LIBRARY_CONFIG_FILE=libs/config.sh
if [ "$#" -ge "1" ]; then
    LIBRARY_CONFIG_FILE="$2"
fi


# load config
source $LIBRARY_CONFIG_FILE

# stop on errors
set -e

# provide default values
POSTFIX=

BUILD_TYPE=Release
#BUILD_TYPE=Debug


# load parameters from custom config file
if [ ! -f "$CONFIG_FILE" ]; then
    echo "ERROR: could not find $CONFIG_FILE with custom configuration!"
    exit 1
fi
source $CONFIG_FILE

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

# NOTE: Trilinos packages "NOT found, some test might not compile properly":
# - NOX, thyra, teko, stratimikos, shylu (not really necessary)

# check config packages
PARAMS2=
if [ "$ENABLE_ETA" != "" ]; then
    PARAMS2="${PARAMS2} -D LifeV_ENABLE_ETA:BOOL=${ENABLE_ETA}"
fi
if [ "$ENABLE_ONEDFSI" != "" ]; then
    PARAMS2="${PARAMS2} -D LifeV_ENABLE_OneDFSI:BOOL=${ENABLE_ONEDFSI}"
fi
if [ "$ENABLE_LEVEL_SET" != "" ]; then
    PARAMS2="${PARAMS2} -D LifeV_ENABLE_LevelSet:BOOL=${ENABLE_LEVEL_SET}"
fi
if [ "$ENABLE_DARCY" != "" ]; then
    PARAMS2="${PARAMS2} -D LifeV_ENABLE_Darcy:BOOL=${ENABLE_DARCY}"
fi
if [ "$ENABLE_NAVIER_STOKES_BLOCKS" != "" ]; then
    PARAMS2="${PARAMS2} -D LifeV_ENABLE_NavierStokesBlocks:BOOL=${ENABLE_NAVIER_STOKES_BLOCKS}"
fi
if [ "$ENABLE_FSI_BLOCKS" != "" ]; then
    PARAMS2="${PARAMS2} -D LifeV_ENABLE_FSI_blocks:BOOL=${ENABLE_FSI_BLOCKS}"
fi
if [ "$ENABLE_BC_INTERFACE" != "" ]; then
    PARAMS2="${PARAMS2} -D LifeV_ENABLE_BCInterface:BOOL=${ENABLE_BC_INTERFACE}"
fi
if [ "$ENABLE_ZERO_DIMENSIONAL" != "" ]; then
    PARAMS2="${PARAMS2} -D LifeV_ENABLE_ZeroDimensional:BOOL=${ENABLE_ZERO_DIMENSIONAL}"
fi
if [ "$ENABLE_MULTISCALE" != "" ]; then
    PARAMS2="${PARAMS2} -D LifeV_ENABLE_Multiscale:BOOL=${ENABLE_MULTISCALE}"
fi
if [ "$ENABLE_INTEGRATED_HEART" != "" ]; then
    PARAMS2="${PARAMS2} -D LifeV_ENABLE_IntegratedHeart:BOOL=${ENABLE_INTEGRATED_HEART}"
fi
if [ "$ENABLE_LIFEVGUI" != "" ]; then
    PARAMS2="${PARAMS2} -D LifeV_ENABLE_LifeVGUI:BOOL=${ENABLE_LIFEVGUI}"
fi
if [ "$ENABLE_REDUCED_BASIS" != "" ]; then
    PARAMS2="${PARAMS2} -D LifeV_ENABLE_ReducedBasis:BOOL=${ENABLE_REDUCED_BASIS}"
fi
if [ "$ENABLE_IGA" != "" ]; then
    PARAMS2="${PARAMS2} -D LifeV_ENABLE_IGA:BOOL=${ENABLE_IGA}"
fi

if [ "$ENABLE_TESTS" != "" ]; then
    PARAMS2="${PARAMS2} -D LifeV_ENABLE_TESTS:BOOL=${ENABLE_TESTS}"
fi
if [ "$ENABLE_EXAMPLES" != "" ]; then
    PARAMS2="${PARAMS2} -D LifeV_ENABLE_EXAMPLES:BOOL=${ENABLE_EXAMPLES}"
fi



# concatenate blas libraries
BLAS_LIBRARIES_2=$BLAS_LIBRARIES
if [ "$BLAS_LIBRARIES_ADDITIONAL" != "" ]; then
    BLAS_LIBRARIES_2="$BLAS_LIBRARIES_2;$BLAS_LIBRARIES_ADDITIONAL"
fi

# NOTE: this option is useful when compiling LifeV with shared objects; it
# includes into the rpath of the generated shared libraries the path of the
# shared object of the linked TPLs. This simplify the use of LifeV as an
# external library, since when a new executable is linked against the
# libraries of LifeV, all the shared objects, from the TPLs, are correctly
# linked too (with the right paths, coming from lifev-env)
PARAMS2="$PARAMS2 -DCMAKE_INSTALL_RPATH_USE_LINK_PATH:BOOL=ON"

# enter build directory
mkdir -p ${BUILD_DIR}
cd ${BUILD_DIR}
# configure
${CMAKE_BIN} \
      -D CMAKE_BUILD_TYPE:STRING=${BUILD_TYPE} \
      -D CMAKE_INSTALL_PREFIX:PATH=${INSTALL_DIR} \
      -D CMAKE_C_COMPILER:PATH=${MPI_C_COMPILER} \
      -D CMAKE_CXX_COMPILER:PATH=${MPI_CXX_COMPILER} \
      -D CMAKE_Fortran_COMPILER:PATH=${MPI_FORTRAN_COMPILER} \
      -D MPI_EXEC:PATH=$MPI_EXEC \
      -D BUILD_SHARED_LIBS:BOOL=ON \
      -D LifeV_ENABLE_ALL_PACKAGES:BOOL=OFF \
      -D LifeV_ENABLE_CPP11:BOOL=ON \
      -D LifeV_ENABLE_STRONG_CXX_COMPILE_WARNINGS:BOOL=OFF \
      -D LifeV_ENABLE_Core:BOOL=ON \
      -D TPL_ENABLE_MPI:BOOL=ON \
      -D TPL_ENABLE_HDF5:BOOL=ON \
      -D TPL_ENABLE_Boost:BOOL=ON \
      -D TPL_Boost_INCLUDE_DIRS:PATH=${BOOST_INCLUDE_DIR} \
      -D TPL_BLAS_LIBRARIES:PATH="${BLAS_LIBRARIES_2}" \
      -D TPL_LAPACK_LIBRARIES:PATH=${LAPACK_LIBRARIES} \
      -D TPL_METIS_INCLUDE_DIRS:PATH=${METIS_INCLUDE_DIR} \
      -D TPL_METIS_LIBRARY_DIRS:PATH=${METIS_LIB_DIR} \
      -D TPL_ParMETIS_LIBRARIES:PATH="${PARMETIS_LIBRARIES}" \
      -D ParMETIS_INCLUDE_DIRS:PATH=${PARMETIS_INCLUDE_DIR} \
      -D ParMETIS_LIBRARY_DIRS:PATH=${PARMETIS_LIB_DIR} \
      -D HDF5_INCLUDE_DIRS:PATH=${HDF5_INCLUDE_DIR} \
      -D HDF5_LIBRARY_DIRS:PATH=${HDF5_LIB_DIR} \
      -D Trilinos_INCLUDE_DIRS:PATH=${TRILINOS_INCLUDE_DIR} \
      -D Trilinos_LIBRARY_DIRS:PATH=${TRILINOS_LIB_DIR} \
      ${PARAMS2} \
      ${PARAMS} \
      ${SOURCE_DIR}

# build
#make -j${NUM_PROC}

