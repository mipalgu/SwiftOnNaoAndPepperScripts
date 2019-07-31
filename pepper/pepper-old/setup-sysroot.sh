#!/usr/bin/env bash

set -e
source setup.sh

rm -rf $LFS
mkdir -p $LFS
mkdir -p $LFS/include

# Copy icu
#cp -R $CROSS_TOOLCHAIN_DIR/icu/include $LFS/usr/
#cp -R $CROSS_TOOLCHAIN_DIR/icu/lib $LFS/usr/
#cp -R $CROSS_TOOLCHAIN_DIR/icu/share $LFS/usr/
#
# Copy libxml2
#cp -R $CROSS_TOOLCHAIN_DIR/xml2/include $LFS/usr/
#cp -R $CROSS_TOOLCHAIN_DIR/xml2/lib $LFS/usr/
#cp -R $CROSS_TOOLCHAIN_DIR/xml2/share $LFS/usr/

# Copy default sysroot into $LFS
cp -R $TOOLCHAIN/sysroot/* $LFS/
ln -s $LFS/usr/include $LFS/usr/include/i386-linux-gnu
cp -R $GCC_DIR $LFS/lib/
# Symlink crt.o files
ln -sf $GCC_TOOLCHAIN/*.o $LFS/lib/

# Setup the sysroot
#cp -R $TOOLCHAIN/include $LFS/
#cp -R $CROSS_TOOLCHAIN_DIR/lib $LFS/

mkdir -p $LFS/usr/lib
for prefix in `echo "$PREFIXES" | sed 's/:/ /g'`
do
    if [ -d "$prefix/include" ]
    then
        cp -fr $prefix/include/* $LFS/usr/include
    fi
    if [ -d "$prefix/lib" ]
    then
        cp -fr $prefix/lib/* $LFS/usr/lib
    fi
done
