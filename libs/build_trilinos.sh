#!/bin/bash
#
# Script to build Trilinos
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
NAME=trilinos-${TRILINOS_VERSION}

# download package in temporary directory
PACKAGE="${NAME}-Source.tar.gz"
cd ${PACKAGES_DIR}
if [ ! -f "$PACKAGE" ]; then
    $WGET -c "http://trilinos.csbsju.edu/download/files/${PACKAGE}" || exit 1
fi

# extract sources
cd ${SOURCES_DIR}
tar -xf ${PACKAGES_DIR}/${PACKAGE} || exit 1

# enter build directory
BUILD_DIR=${BUILDS_DIR}/${NAME}_build${BUILD_TYPE}
mkdir -p ${BUILD_DIR}
cd ${BUILD_DIR}

# NOTE: install directory is specified in config.sh

# configure
SOURCE_DIR=${SOURCES_DIR}/${NAME}-Source
${CMAKE_BIN} -D CMAKE_BUILD_TYPE=${BUILD_TYPE} \
      -D CMAKE_INSTALL_PREFIX=${TRILINOS_INSTALL_DIR} \
      -D CMAKE_C_COMPILER:STRING=${MPI_C_COMPILER} \
      -D CMAKE_CXX_COMPILER:STRING=${MPI_CXX_COMPILER} \
      -D CMAKE_Fortran_COMPILER:STRING=${MPI_FORTRAN_COMPILER} \
      -D MPI_EXEC:STRING=$MPI_EXEC \
      -D TPL_ENABLE_MPI:BOOL=ON \
      -D TPL_ENABLE_BLAS:BOOL=ON \
      -D TPL_ENABLE_LAPACK:BOOL=ON \
      -D TPL_ENABLE_HDF5:BOOL=ON \
      -D TPL_ENABLE_ParMETIS:BOOL=ON \
      -D TPL_ENABLE_METIS:BOOL=ON \
      -D TPL_ENABLE_Boost:BOOL=ON \
      -D TPL_ENABLE_Zlib:BOOL=ON \
      -D TPL_ENABLE_Pthread:BOOL=ON \
      -D TPL_ENABLE_UMFPACK:BOOL=ON \
      -D TPL_ENABLE_AMD:BOOL=ON \
      -D Trilinos_ENABLE_Teuchos:BOOL=ON \
      -D Trilinos_ENABLE_Epetra:BOOL=ON \
      -D Trilinos_ENABLE_EpetraExt:BOOL=ON \
      -D Trilinos_ENABLE_AztecOO:BOOL=ON \
      -D Trilinos_ENABLE_Amesos:BOOL=ON \
      -D Trilinos_ENABLE_Ifpack:BOOL=ON \
      -D Trilinos_ENABLE_Belos:BOOL=ON \
      -D Trilinos_ENABLE_Tpetra:BOOL=OFF \
      -D Trilinos_ENABLE_Xpetra:BOOL=OFF \
      -D Trilinos_ENABLE_Anasazi:BOOL=ON \
      -D Boost_INCLUDE_DIRS:PATH=${BOOST_INCLUDE_DIR} \
      -D TPL_BLAS_LIBRARIES:PATH=${BLAS_LIBRARIES} \
      -D TPL_LAPACK_LIBRARIES:PATH=${LAPACK_LIBRARIES} \
      -D METIS_INCLUDE_DIRS:PATH=${METIS_INCLUDE_DIR} \
      -D METIS_LIBRARY_DIRS:PATH=${METIS_LIB_DIR} \
      -D TPL_ParMETIS_LIBRARIES:PATH="$PARMETIS_LIB_DIR/libparmetis.a;$METIS_LIB_DIR/libmetis.a" \
      -D ParMETIS_INCLUDE_DIRS:PATH=${PARMETIS_INCLUDE_DIR} \
      -D ParMETIS_LIBRARY_DIRS:PATH=${PARMETIS_LIB_DIR} \
      -D HDF5_INCLUDE_DIRS:PATH=${HDF5_INCLUDE_DIR} \
      -D HDF5_LIBRARY_DIRS:PATH=${HDF5_LIB_DIR} \
      -D AMD_INCLUDE_DIRS:PATH=${SUITESPARSE_INCLUDE_DIR} \
      -D AMD_LIBRARY_DIRS:PATH=${SUITESPARSE_LIB_DIR} \
      -D UMFPACK_INCLUDE_DIRS:PATH=${SUITESPARSE_INCLUDE_DIR} \
      -D UMFPACK_LIBRARY_DIRS:PATH=${SUITESPARSE_LIB_DIR} \
      ${SOURCE_DIR}  || exit 1

#      -DMPI_C_COMPILER:STRING=$MPI_C_COMPILER
#      -DMPI_CXX_COMPILER:STRING=$MPI_CXX_COMPILER
#      -DMPI_Fortran_COMPILER:STRING=$MPI_FORTRAN_COMPILER

# build and install
make -j${NUM_PROC} install  || exit 1

# exit build directory
cd ${LIBRARIES_DIR}

