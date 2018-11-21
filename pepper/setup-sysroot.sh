#!/usr/bin/env bash

set -e
source setup.sh

rm -rf $LFS
mkdir -p $LFS

cp -R $CROSS_TOOLCHAIN_DIR/i686-aldebaran-linux-gnu/sysroot/* $LFS/
cp -R $CROSS_TOOLCHAIN_DIR/i686-aldebaran-linux-gnu/include $LFS/
cp -R $CROSS_TOOLCHAIN_DIR/lib $LFS/

cd $LFS/usr/include
ln -s ../../lib/gcc/i686-aldebaran-linux-gnu/4.9.2/include/stddef.h .
cd $WD

# Copy icu
cp -R $CROSS_TOOLCHAIN_DIR/icu/include $LFS/usr/
cp -R $CROSS_TOOLCHAIN_DIR/icu/lib $LFS/usr/
cp -R $CROSS_TOOLCHAIN_DIR/icu/share $LFS/usr/

# Copy libxml2
cp -R $CROSS_TOOLCHAIN_DIR/xml2/include $LFS/usr/
cp -R $CROSS_TOOLCHAIN_DIR/xml2/lib $LFS/usr/
cp -R $CROSS_TOOLCHAIN_DIR/xml2/share $LFS/usr/

# Copy peppers libuuid files
cp $WD/pepper/lib/libuuid* $LFS/lib/
ln -s $LFS/lib/libuuid.so.1 $LFS/lib/libuuid.so

# Symlink crt.o files
ln -s $LFS/lib/gcc/i686-aldebaran-linux-gnu/4.9.2/*.o $LFS/lib/
