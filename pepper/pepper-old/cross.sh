#!/usr/bin/env bash
set -e

# For each PREFIX, we add the bin, lib, and include directories to the appropriate paths.
PREFIX_PATHS=`echo "$PREFIXES" | sed 's/\$\|:/\/bin:/g'`
PREFIX_LIBRARY_PATHS=`echo "$PREFIXES" | sed 's/\$\|:/\/lib:/g'`
PREFIX_INCLUDE_PATHS=`echo "$PREFIXES" | sed 's/\$\|:/\/include:/g'`

# Paths that exist in the toolchain.
#SYSROOT_PATH=`echo "$PREFIX_PATHS:${SYSROOT_PATH}:$TOOLCHAIN/bin:$INSTALL_PREFIX/bin:" | sed 's/::/:/g'`
SYSROOT_PATH=`echo "$PREFIX_PATHS:${SYSROOT_PATH}:$INSTALL_PREFIX/bin:" | sed 's/::/:/g'`
#SYSROOT_LIBRARY_PATH=`echo "$PREFIX_LIBRARY_PATHS:$INSTALL_PREFIX/usr/local/lib:$INSTALL_PREFIX/usr/lib:$INSTALL_PREFIX/lib:$GCC_TOOLCHAIN:$TOOLCHAIN/lib" | sed 's/::/:/g'`
SYSROOT_LIBRARY_PATH=`echo "$PREFIX_LIBRARY_PATHS:$INSTALL_PREFIX/usr/local/lib:$INSTALL_PREFIX/usr/lib:$INSTALL_PREFIX/lib:$GCC_TOOLCHAIN" | sed 's/::/:/g'`
SYSROOT_LD_LIBRARY_PATH="$SYSROOT_LIBRARY_PATH"
SYSROOT_CPATH=`echo "$PREFIX_INCLUDE_PATHS:$SYSROOT_CPATH:$TOOLCHAIN/include/c++/4.9.2/${TRIPLE}:$TOOLCHAIN/include/c++/4.9.2:$INSTALL_PREFIX/usr/local/include:$INSTALL_PREFIX/usr/include:$INSTALL_PREFIX/include:$LFS/usr/include:$LFS/include" | sed 's/::/:/g'`

# Paths that cmake should use. 
export PREFIX_PATH="$PREFIXES"
export PATH="$SYSROOT_PATH:/usr/local/bin:/usr/bin:/bin"
export LIBRARY_PATH="$SYSROOT_LIBRARY_PATH:$LFS/usr/local/lib:$LFS/usr/lib:$LFS/lib:$LFS:$LFS/lib/gcc/${TRIPLE}/4.9.2"
export LD_LIBRARY_PATH="$LIBRARY_PATH"
export CPATH="$SYSROOT_CPATH"
export LANG=/usr/lib/locale/en_US

# For each path in the toolchain, we create the -L -I and -B flags.
export BINARY_FLAGS=`echo "$SYSROOT_PATH:$SYSROOT_LIBRARY_PATH:$SYSROOT_CPATH" | sed 's/^\|:/ -B/g'`
export INCLUDE_FLAGS=`echo $SYSROOT_CPATH | sed 's/^\|:/ -I/g'`
L_FLAGS=`echo $SYSROOT_LIBRARY_PATH | sed 's/^\|:/ -L/g'`
export LINK_FLAGS="-rpath $INSTALL_PREFIX/usr/local/lib -rpath $INSTALL_PREFIX/usr/lib -rpath $INSTALL_PREFIX/lib $L_FLAGS"
