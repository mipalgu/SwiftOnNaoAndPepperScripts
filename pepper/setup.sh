#!/usr/bin/env bash
set +h
umask 022

WD=`pwd`
CROSS_TOOLCHAIN_DIR="$WD/ctc-linux64-atom-2.5.2.74"
ARCH=i686
VENDOR=aldebaran
OS=linux
TRIPLE=$ARCH-$VENDOR-$OS-gnu
PLATFORM=$ARCH-$OS
LFS="$WD/sysroot"
SRC_DIR=$WD/src
BUILD_DIR=$SRC_DIR/build
INSTALL_PREFIX=$LFS/home/nao/swift-tc
mkdir -p $SRC_DIR
mkdir -p $BUILD_DIR
export LANG=/usr/lib/locale/en_US
