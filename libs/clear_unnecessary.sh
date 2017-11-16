#!/bin/bash
#
# Clear files that are not necessary for the usage of LifeV, i.e. all the
# temporary files used for building the third-part libraries
#
# Andrea Bartezzaghi, 15-Nov-2017
#

rm -rf packages/*
rm -rf sources/*
rm -rf builds/*

