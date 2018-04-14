#!/usr/bin/env bash
set -e

# Set up Variables
WD=`pwd`
SRC_DIR=$WD
NCURSES_VERSION=5.9
ZLIB_VERSION=1.2.11
LIBICONV_VERSION=1.15
LIBXML2_VERSION=2.9.2
LIBUUID_VERSION=1.0.3
ICU4C_VERSION=61_1
XZ_VERSION=5.0.5

# Set Up Environment
set +h
umask 022
LFS=/tools
PATH="$LFS/bin:/bin:/usr/bin"
LIBRARY_PATH="$LFS/usr/local/lib:$LFS/usr/lib:$LFS/lib"
CPATH="$LFS/usr/local/include:$LFS/usr/include:$LFS/include"
GCC="$LFS/bin/gcc"
GXX="$LFS/bin/g++"
export PATH LIBRARY_PATH

# Zlib
rm -rf zlib-$ZLIB_VERSION
tar -xzvf zlib-$ZLIB_VERSION.tar.gz
rm -rf $SRC_DIR/build-zlib
mkdir $SRC_DIR/build-zlib
cd $SRC_DIR/build-zlib
../zlib-$ZLIB_VERSION/configure --prefix=$LFS/usr/local
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
 --prefix=$LFS/usr/local \
 --with-shared           \
 --without-debug         \
 --enable-pc-files       \
 --enable-widec
make
make install
cd $SRC_DIR

# icu4c
rm -rf icu4c-$ICU4C_VERSION
tar -xzvf icu4c-$ICU4C_VERSION-src.tgz
cd icu/source
./configure --prefix=$LFS/usr/local
make
make install
cd $SRC_DIR

# libiconv
rm -rf libiconv-$LIBICONV_VERSION
tar -xzvf libiconv-$LIBICONV_VERSION.tar.gz
rm -rf $SRC_DIR/build-libiconv
mkdir $SRC_DIR/build-libiconv
cd $SRC_DIR/build-libiconv
../libiconv-$LIBICONV_VERSION/configure --prefix=$LFS/usr/local
make
make install
cd $SRC_DIR

# xz
rm -rf xz-$XZ_VERSION
tar -xvf xz-$XZ_VERSION.tar.xz
rm -rf $SRC_DIR/build-xz
mkdir $SRC_DIR/build-xz
cd $SRC_DIR/build-xz
../xz-$XZ_VERSION/configure --prefix=$LFS/usr/local
make
make install
cd $SRC_DIR

# libxml2
rm -rf libxml2-$LIBXML2_VERSION
tar -xvf libxml2-$LIBXML2_VERSION.tar.xz
cd $SRC_DIR/libxml2-$LIBXML2_VERSION
./autogen.sh --prefix=$LFS/usr/local
make
make install
cd $SRC_DIR

# libuuid
rm -rf libuuid-$LIBUUID_VERSION
tar -xzvf libuuid-$LIBUUID_VERSION.tar.gz
rm -rf $SRC_DIR/build-libuuid
mkdir $SRC_DIR/build-libuuid
cd $SRC_DIR/build-libuuid
../libuuid-$LIBUUID_VERSION/configure --prefix=$LFS/usr/local
make
make install
cd $SRC_DIR
