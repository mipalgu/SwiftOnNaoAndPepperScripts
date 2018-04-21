#!/usr/bin/env bash
set -e

# Set up Variables
source setup.sh
source versions.sh

# Set Up Environment
set +h
umask 022
PATH="$LFS/bin:/bin:/usr/bin"
LIBRARY_PATH="$LFS/usr/local/lib:$LFS/usr/lib:$LFS/lib"
CPATH="$LFS/usr/local/include:$LFS/usr/include:$LFS/include:$LFS/usr/include/ncurses"
GCC="$LFS/bin/gcc"
GXX="$LFS/bin/g++"
export PATH LIBRARY_PATH CPATH

INSTALL_PREFIX=$LFS/usr

# Zlib
rm -rf zlib-$ZLIB_VERSION
tar -xzvf zlib-$ZLIB_VERSION.tar.gz
rm -rf $SRC_DIR/build-zlib
mkdir $SRC_DIR/build-zlib
cd $SRC_DIR/build-zlib
../zlib-$ZLIB_VERSION/configure --prefix=$INSTALL_PREFIX
make
make install
cd $SRC_DIR

# libiconv
rm -rf libiconv-$LIBICONV_VERSION
tar -xzvf libiconv-$LIBICONV_VERSION.tar.gz
rm -rf $SRC_DIR/build-libiconv
mkdir $SRC_DIR/build-libiconv
cd $SRC_DIR/build-libiconv
../libiconv-$LIBICONV_VERSION/configure --prefix=$INSTALL_PREFIX
make
make install
cd $SRC_DIR

# ncurses
rm -rf ncurses-$NCURSES_VERSION
tar -xzvf ncurses-$NCURSES_VERSION.tar.gz
rm -rf $SRC_DIR/build-ncurses
mkdir $SRC_DIR/build-ncurses
cd $SRC_DIR/build-ncurses
../ncurses-$NCURSES_VERSION/configure \
 --prefix=$INSTALL_PREFIX             \
 --with-shared                        \
 --enable-pc-files
make
make install
cd $SRC_DIR

# icu4c
rm -rf icu4c-$ICU4C_VERSION
tar -xzvf icu4c-$ICU4C_VERSION-src.tgz
cd icu/source
./configure --prefix=$INSTALL_PREFIX
make
make install
cd $SRC_DIR

# xz
rm -rf xz-$XZ_VERSION
tar -xvf xz-$XZ_VERSION.tar.xz
rm -rf $SRC_DIR/build-xz
mkdir $SRC_DIR/build-xz
cd $SRC_DIR/build-xz
../xz-$XZ_VERSION/configure --prefix=$INSTALL_PREFIX
make
make install
cd $SRC_DIR

# libxml2
rm -rf libxml2-$LIBXML2_VERSION
tar -xvf libxml2-$LIBXML2_VERSION.tar.xz
cd $SRC_DIR/libxml2-$LIBXML2_VERSION
./autogen.sh --prefix=$INSTALL_PREFIX
make
make install
cd $SRC_DIR

# libuuid
rm -rf libuuid-$LIBUUID_VERSION
tar -xzvf libuuid-$LIBUUID_VERSION.tar.gz
rm -rf $SRC_DIR/build-libuuid
mkdir $SRC_DIR/build-libuuid
cd $SRC_DIR/build-libuuid
../libuuid-$LIBUUID_VERSION/configure --prefix=$INSTALL_PREFIX
make
make install
cd $SRC_DIR

# bash
rm -rf bash-$BASH_VERSION
tar -xzvf bash-$BASH_VERSION.tar.gz
rm -rf $SRC_DIR/build-bash
mkdir $SRC_DIR/build-bash
cd $SRC_DIR/build-bash
../bash-$BASH_VERSION/configure --prefix=$INSTALL_PREFIX
make
make install
cd $SRC_DIR

# coreutils
rm -rf coreutils-$COREUTILS_VERSION
tar -xvf coreutils-$COREUTILS_VERSION.tar.xz
rm -rf $SRC_DIR/build-coreutils
mkdir $SRC_DIR/build-coreutils
cd $SRC_DIR/build-coreutils
FORCE_UNSAFE_CONFIGURE=1 ../coreutils-$COREUTILS_VERSION/configure --prefix=$INSTALL_PREFIX
make
make install
cd $SRC_DIR

# sed
rm -rf sed-$SED_VERSION
tar -xvf sed-$SED_VERSION.tar.bz2
rm -rf $SRC_DIR/build-sed
mkdir $SRC_DIR/build-sed
cd $SRC_DIR/build-sed
../sed-$SED_VERSION/configure --prefix=$INSTALL_PREFIX
make
make install
cd $SRC_DIR

# grep
rm -rf grep-$GREP_VERSION
tar -xvf grep-$GREP_VERSION.tar.xz
rm -rf $SRC_DIR/build-grep
mkdir $SRC_DIR/build-grep
cd $SRC_DIR/build-grep
../grep-$GREP_VERSION/configure --prefix=$INSTALL_PREFIX
make
make install
cd $SRC_DIR

# gawk
rm -rf gawk-$GAWK_VERSION
tar -xvf gawk-$GAWK_VERSION.tar.xz
rm -rf $SRC_DIR/build-gawk
mkdir $SRC_DIR/build-gawk
cd $SRC_DIR/build-gawk
../gawk-$GAWK_VERSION/configure --prefix=$INSTALL_PREFIX
make
make install
cd $SRC_DIR

# GNU make
rm -rf make-$MAKE_VERSION
tar -xvf make-$MAKE_VERSION.tar.bz2
rm -rf $SRC_DIR/build-make
mkdir $SRC_DIR/build-make
cd $SRC_DIR/build-make
../make-$MAKE_VERSION/configure --prefix=$INSTALL_PREFIX
make
make install
cd $SRC_DIR

# Python
rm -rf Python-$PYTHON_VERSION
tar -xvf Python-$PYTHON_VERSION.tar.xz
rm -rf $LFS/Python-$PYTHON_VERSION
mv Python-$PYTHON_VERSION $LFS/Python-$PYTHON_VERSION
rm -rf $LFS/build-python
mkdir $LFS/build-python

# ninja
rm -rf ninja-$NINJA_VERSION
tar -xvf ninja-$NINJA_VERSION.tar.gz
rm -rf $LFS/ninja-$NINJA_VERSION
mv ninja-$NINJA_VERSION $LFS/ninja-$NINJA_VERSION
rm -rf $LFS/build-ninja
mkdir $LFS/build-ninja

# CMake
rm -rf cmake-$CMAKE_VERSION
tar -xzvf cmake-$CMAKE_VERSION.tar.gz
rm -rf $LFS/cmake-$CMAKE_VERSION
mv cmake-$CMAKE_VERSION $LFS/cmake-$CMAKE_VERSION
rm -rf $LFS/build-cmake
mkdir $LFS/build-cmake

# Copy scripts into $LFS
cp setup.sh $LFS
cp versions.sh $LFS
cp build-chroot.sh $LFS
cp build-swift.sh $LFS

chroot $LFS $LFS/usr/bin/env -i HOME=/root TERM="$TERM" PS1='\u:\w\$ ' PATH="$LFS/usr/local/bin:$LFS/usr/bin:$LFS/bin" CPATH="$LFS/usr/local/include:$LFS/usr/include:/$LFS/include" LIBRARY_PATH="$LFS/usr/local/lib:$LFS/usr/lib:$LFS/lib" LD_LIBRARY_PATH="$LFS/usr/local/lib:$LFS/usr/lib:$LFS/lib" /build-chroot.sh
