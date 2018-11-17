#!/usr/bin/env bash
set -e

source versions.sh

wget https://cmake.org/files/v$CMAKE_MAJOR_VERSION.$CMAKE_MINOR_VERSION/cmake-$CMAKE_VERSION.tar.gz

#wget -O ninja-$NINJA_VERSION.tar.gz http://github.com/ninja-build/ninja/archive/v$NINJA_VERSION.tar.gz
echo "You must manually download ninja from http://github.com/ninja-build/ninja/archive/v$NINJA_VERSION.tar.gz"
echo "This is because the nao has an old OpenSSL version and github will not allow the connection."
echo "Make sure you place the file into this directory and name it: ninja-$NINJA_VERSION.tar.gz"

