#!/usr/bin/env bash
set -e

source setup.sh

if [ ! -f $CROSS_DIR/bin/$TRIPLE-ld.gold ]
then
    rm -rf $WD/build-binutils
    mkdir $WD/build-binutils
    cd $WD/build-binutils
    PATH="$CROSS_TOOLCHAIN_DIR/bin:$PATH" $WD/binutils-$BINUTILS_VERSION/configure --prefix="$CROSS_DIR" --target=${TRIPLE} --enable-gold=yes --with-sysroot="$LFS"
    PATH="$CROSS_TOOLCHAIN_DIR/bin:$PATH" make -j12
    PATH="$CROSS_TOOLCHAIN_DIR/bin:$PATH" make install
    cd $WD
fi
