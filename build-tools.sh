#!/usr/bin/env bash
set -e

source setup.sh
source versions.sh

rm -rf cmake-$CMAKE_VERSION
tar -xzvf cmake-$CMAKE_VERSION.tar.gz
mkdir build-cmake
cd build-cmake
../cmake-$CMAKE_VERSION/configure
make
make install

rm -rf ninja
