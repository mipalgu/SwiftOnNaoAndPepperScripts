#!/usr/bin/env bash
set -e

source setup.sh

if [ ! -f $INSTALL_PREFIX/lib/libicuuc.so ]
then
    if [ ! -f $WD/build-host-icu/.icu-build-host ]
    then
        rm -rf $WD/build-host-icu
        mkdir $WD/build-host-icu
        cd $WD/build-host-icu
	$SRC_DIR/icu/icu4c/source/runConfigureICU Linux
	make -j${PARALLEL}
	touch .icu-build-host
	cd $WD
    fi
    rm -rf $WD/build-target-icu
    mkdir $WD/build-target-icu
    cd $WD/build-target-icu
    PATH="$CROSS_TOOLCHAIN_DIR/bin:$PATH" $SRC_DIR/icu/icu4c/source/configure --prefix="$INSTALL_PREFIX" --host="$TRIPLE" --with-sysroot="$LFS" --with-cross-build="$WD/build-host-icu" --with-library-bits=32 --disable-layoutex
    PATH="$CROSS_TOOLCHAIN_DIR/bin:$PATH" make -j${PARALLEL}
    PATH="$CROSS_TOOLCHAIN_DIR/bin:$PATH" make install
    cd $WD
fi
