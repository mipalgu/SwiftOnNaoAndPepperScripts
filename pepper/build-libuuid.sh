#!/usr/bin/env bash
set -e

source setup.sh

if [ ! -f $INSTALL_PREFIX/lib/libuuid.so ]
then
    rm -rf $WD/build-libuuid
    mkdir $WD/build-libuuid
    cd $WD/build-libuuid
    PATH="$CROSS_TOOLCHAIN_DIR/bin:$PATH" $WD/libuuid-$UUID_VERSION/configure --prefix="$INSTALL_PREFIX" --host="$TRIPLE" --with-sysroot="$LFS"
    PATH="$CROSS_TOOLCHAIN_DIR/bin:$PATH" make -j${PARALLEL}
    PATH="$CROSS_TOOLCHAIN_DIR/bin:$PATH" make install
    cd $WD
fi
