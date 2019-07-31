#!/tools/usr/bin/env bash
set -e

# Set up Variables
source setup.sh
source versions.sh

INSTALL_PREFIX=$LFS/usr

# Python
cd $LFS/build-python
../Python-$PYTHON_VERSION/configure --prefix=$INSTALL_PREFIX
make
make install
cd /

#Ninja
cd ninja-$NINJA_VERSION
./configure.py --bootstrap
install ninja $INSTALL_PREFIX/bin
cd /

# CMake
cd build-cmake
../cmake-$CMAKE_VERSION/configure --prefix=$INSTALL_PREFIX
make
make install
cd /
