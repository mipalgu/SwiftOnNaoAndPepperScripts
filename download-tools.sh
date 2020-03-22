#!/usr/bin/env bash
set -e

source versions.sh
source download.sh

cd $SRC_DIR

download https://cmake.org/files/v$CMAKE_MAJOR_VERSION.$CMAKE_MINOR_VERSION/cmake-$CMAKE_VERSION.tar.gz
download http://github.com/ninja-build/ninja/archive/v$NINJA_VERSION.tar.gz ninja-$NINJA_VERSION.tar.gz

cd $WD
