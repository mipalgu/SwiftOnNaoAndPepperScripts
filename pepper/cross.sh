#!/usr/bin/env bash
set -e

# For each PREFIX, we add the bin, lib, and include directories to the appropriate paths.
PREFIX_PATHS=`echo "$PREFIXES" | sed 's/\$\|:/\/bin:/g'`
PREFIX_LIBRARY_PATHS=`echo "$PREFIXES" | sed 's/\$\|:/\/lib:/g'`
PREFIX_INCLUDE_PATHS=`echo "$PREFIXES" | sed 's/\$\|:/\/include:/g'`

# Paths that cmake should use. 
export PREFIX_PATH="$PREFIXES"
export PATH="$SYSROOT_PATH:/usr/local/bin:/usr/bin:/bin"
export LIBRARY_PATH="$SYSROOT_LIBRARY_PATH:$LFS/usr/local/lib:$LFS/usr/lib:$LFS/lib:$LFS:$LFS/lib/gcc/${TRIPLE}/$GCC_VERSION"
export LD_LIBRARY_PATH="$LIBRARY_PATH"
export CPATH="$SYSROOT_CPATH"
export LANG=/usr/lib/locale/C.UTF-8

# For each path in the toolchain, we create the -L -I and -B flags.
export BINARY_FLAGS=`echo "$GCC_TOOLCHAIN" | sed 's/^/ -B/g' | sed 's/:/ -B/g'`
export INCLUDE_FLAGS=`echo "$PREFIX_INCLUDE_PATHS" | sed 's/^/ -I/g' | sed 's/:/ -I/g'`
L_FLAGS=`echo "$PREFIX_LIBRARY_PATHS:$GCC_TOOLCHAIN" | sed 's/^/ -L/g' | sed 's/:/ -L/g'`
export LINK_FLAGS="-R$INSTALL_PREFIX/usr/local/lib -R$INSTALL_PREFIX/usr/lib -R$INSTALL_PREFIX/lib -R/usr/lib $L_FLAGS"
