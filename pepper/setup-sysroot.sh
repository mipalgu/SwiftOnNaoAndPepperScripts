#!/usr/bin/env bash

set -e
source setup.sh

rm -rf $LFS
mkdir -p $LFS

cp -R $CROSS_TOOLCHAIN_DIR/i686-aldebaran-linux-gnu/sysroot/* $LFS/
cp -R $CROSS_TOOLCHAIN_DIR/i686-aldebaran-linux-gnu/bin $LFS/
cp -R $CROSS_TOOLCHAIN_DIR/i686-aldebaran-linux-gnu/include $LFS/
cp -R $CROSS_TOOLCHAIN_DIR/lib $LFS/

# Copy icu
cp -R $CROSS_TOOLCHAIN_DIR/icu/include $LFS/usr/
cp -R $CROSS_TOOLCHAIN_DIR/icu/lib $LFS/usr/
cp -R $CROSS_TOOLCHAIN_DIR/icu/share $LFS/usr/

# Copy libxml2
cp -R $CROSS_TOOLCHAIN_DIR/xml2/include $LFS/usr/
cp -R $CROSS_TOOLCHAIN_DIR/xml2/lib $LFS/usr/
cp -R $CROSS_TOOLCHAIN_DIR/xml2/share $LFS/usr/
