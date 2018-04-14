#!/usr/bin/env bash
set -e

source setup.sh
source versions.sh

rm -rf cmake-$CMAKE_VERSION
tar -xzvf cmake-$CMAKE_VERSION.tar.gz
rm -rf build-cmake
mkdir build-cmake
cd build-cmake
../cmake-$CMAKE_VERSION/configure
make
make install
cd $SRC_DIR

rm -rf ninja-$NINJA_VERSION
tar -xzvf ninja-$NINJA_VERSION.tar.gz
cd ninja-$NINJA_VERSION
./configure.py --bootstrap
install ninja /usr/local/bin
cd $SRC_DIR
