#!/usr/bin/env bash
set +h
umask 022

source versions.sh

PARALLEL=${PARALLEL-1}
WD=`pwd`
ARCH=i686
VENDOR=aldebaran
OS=linux
TRIPLE=$ARCH-$VENDOR-$OS-gnu
CROSS_TOOLCHAIN_DIR="$WD/ctc-mac64-atom-2.5.5.5"
CROSS_DIR="$CROSS_TOOLCHAIN_DIR/cross"
GCC_DIR="$CROSS_DIR/lib/gcc"
GCC_TOOLCHAIN="$GCC_DIR/${TRIPLE}/$GCC_VERSION"
TOOLCHAIN="$CROSS_DIR/${TRIPLE}"
# List of cmake prefixes - directories which contains projects which cmake may look for.
PREFIXES="$CROSS_TOOLCHAIN_DIR/pthread:$CROSS_TOOLCHAIN_DIR/zlib:$CROSS_TOOLCHAIN_DIR/xz_utils:$CROSS_TOOLCHAIN_DIR/xml2:$CROSS_TOOLCHAIN_DIR/icu"
PLATFORM=$ARCH-$OS
LFS="$WD/sysroot"
SRC_DIR=$WD/src
BUILD_DIR=$SRC_DIR/build
INSTALL_PREFIX=$LFS/home/nao/swift-tc
mkdir -p $SRC_DIR
mkdir -p $BUILD_DIR
mkdir -p $INSTALL_PREFIX
export LANG=/usr/lib/locale/en_US
