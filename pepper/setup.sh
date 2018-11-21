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
#LFS="$WD/sysroot"
LFS=$CROSS_TOOLCHAIN_DIR/$TRIPLE/sysroot
#SYSROOT_PATH="$INSTALL_PREFIX/bin:$LFS/usr/local/bin:$LFS/usr/bin:$LFS/bin"
SYSROOT_LIBRARY_PATH="$INSTALL_PREFIX/lib:$LFS/usr/local/lib:$LFS/usr/lib:$LFS/usr/lib32:$LFS/lib:$LFS/lib32:$LFS:$LFS/lib/gcc/${TRIPLE}/4.9.2"
SYSROOT_LD_LIBRARY_PATH="$LIBRARY_PATH"
SYSROOT_CPATH=":$LFS/include/c++/4.9.2/${TRIPLE}:$LFS/include/c++/4.9.2:$LFS/lib/gcc/${TRIPLE}/4.9.2/include-fixed:$INSTALL_PREFIX/include:$LFS/usr/local/include:$LFS/usr/include:$LFS/include:$LFS/include/${TRIPLE}:$LFS/usr/lib:$LFS/usr/include/linux"
export PATH="$LFS/usr/local/bin:$LFS/usr/bin:/usr/local/bin:/usr/bin:/bin"

SRC_DIR=$WD/src
BUILD_DIR=$SRC_DIR/build
INSTALL_PREFIX=$LFS/home/nao/swift-tc
mkdir -p $SRC_DIR
mkdir -p $BUILD_DIR
