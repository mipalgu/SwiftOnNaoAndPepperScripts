#!/usr/bin/env bash
set -e

SYSROOT_PATH="${SYSROOT_PATH}:$INSTALL_PREFIX/bin:$LFS/usr/local/bin:$LFS/usr/bin:$LFS/bin"
SYSROOT_LIBRARY_PATH="${SYSROOT_LIBRARY_PATH}:$INSTALL_PREFIX/lib:$LFS/usr/local/lib:$LFS/usr/lib:$LFS/usr/lib32:$LFS/lib:$LFS/lib32:$LFS:$LFS/lib/gcc/${TRIPLE}/4.9.2"
SYSROOT_LD_LIBRARY_PATH="$LIBRARY_PATH"
SYSROOT_CPATH="$SYSROOT_CPATH:$LFS/lib/gcc/${TRIPLE}/4.9.2/include-fixed:$INSTALL_PREFIX/include:$LFS/usr/local/include:$LFS/usr/include:$LFS/include:$LFS/include/${TRIPLE}:$LFS/usr/lib:$LFS/include/c++/4.9.2/${TRIPLE}:$LFS/include/c++/4.9.2"

export PATH="$LFS/usr/local/bin:$LFS/usr/bin:/usr/local/bin:/usr/bin:/bin"
export LIBRARY_PATH="$SYSROOT_LIBRARY_PATH"
export LD_LIBRARY_PATH="$LIBRARY_PATH"
export CPATH=$SYSROOT_CPATH
export LANG=/usr/lib/locale/en_US
BINARY_FLAGS=`echo "$SYSROOT_PATH:$SYSROOT_LIBRARY_PATH:$SYSROOT_CPATH" | sed 's/^\|:/ -B/g'`
INCLUDE_FLAGS=`echo $SYSROOT_CPATH | sed 's/^\|:/ -I/g'`
LINK_FLAGS=`echo $SYSROOT_LIBRARY_PATH | sed 's/^\|:/ -L/g'`

