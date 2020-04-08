#!/usr/bin/env bash
set -e

source setup.sh

if [ ! -f "/usr/local/bin/cmake" ]
then
	rm -rf $WD/build-cmake
	mkdir $WD/build-cmake
	cd $WD/build-cmake
	CC=/usr/bin/clang CXX=/usr/bin/clang++ $WD/cmake-$CMAKE_VERSION/configure --prefix=/usr/local
	make -j${PARALLEL}
	make install
fi
