#!/usr/bin/env bash
set -e

export PATH="$LFS/usr/local/bin:$LFS/usr/bin:/usr/local/bin:/usr/bin:/bin"
export LIBRARY_PATH="$SYSROOT_LIBRARY_PATH"
export LD_LIBRARY_PATH="$LIBRARY_PATH"
export CPATH=$SYSROOT_CPATH
export LANG=/usr/lib/locale/en_US
BINARY_FLAGS=`echo "$SYSROOT_PATH:$SYSROOT_LIBRARY_PATH:$SYSROOT_CPATH" | sed 's/^\|:/ -B/g'`
INCLUDE_FLAGS=`echo $SYSROOT_CPATH | sed 's/^\|:/ -I/g'`
LINK_FLAGS=`echo $SYSROOT_LIBRARY_PATH | sed 's/^\|:/ -L/g'`

