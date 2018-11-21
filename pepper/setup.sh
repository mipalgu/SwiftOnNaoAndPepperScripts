#!/usr/bin/env bash
set +h
umask 022

WD=`pwd`
SRC_DIR=$WD
LFS="/home/callum/src/swift-tc/ctc-linux64-atom-2.5.2.74/i686-aldebaran-linux-gnu/sysroot"
ARCH=i686
VENDOR=aldebaran
OS=linux
TRIPLE=$ARCH-$VENDOR-$OS-gnu
PLATFORM=$ARCH-$OS
SYSROOT_PATH="$INSTALL_PREFIX/bin:$LFS/usr/local/bin:$LFS/usr/bin:$LFS/bin"
SYSROOT_LIBRARY_PATH="$INSTALL_PREFIX/lib:$LFS/usr/local/lib:$LFS/usr/lib:$LFS/usr/lib32:$LFS/lib:$LFS/lib32:$LFS:$LFS/lib/gcc/${TRIPLE}/4.9.2"
SYSROOT_LD_LIBRARY_PATH="$LIBRARY_PATH"
SYSROOT_CPATH=":$LFS/include/c++/4.9.2/${TRIPLE}:$LFS/include/c++/4.9.2:$LFS/lib/gcc/${TRIPLE}/4.9.2/include-fixed:$INSTALL_PREFIX/include:$LFS/usr/local/include:$LFS/usr/include:$LFS/include:$LFS/include/${TRIPLE}:$LFS/usr/lib"
export PATH="$LFS/usr/local/bin:$LFS/usr/bin:/usr/local/bin:/usr/bin:/bin"
