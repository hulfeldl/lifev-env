#!/bin/bash

# path or command for cmake
CMAKE_BIN=cmake

# build type, can be "Release" or "Debug"
BUILD_TYPE=Release

# compilers to use
C_COMPILER=gcc
CXX_COMPILER=g++
FORTRAN_COMPILER=gfortran

MPI_C_COMPILER=mpicc
MPI_CXX_COMPILER=mpic++
MPI_FORTRAN_COMPILER=mpif90

# main directory with all the libraries
LIBRARIES_DIR=$(pwd)

# set number of parallel builds to use
NUM_PROC=$(grep processor /proc/cpuinfo | wc -l)
if [ $NUM_PROC -gt 8 ]; then NUM_PROC=8; fi

