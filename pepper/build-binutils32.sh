#!/usr/bin/env bash
set -e

source setup.sh
#source setup-sysroot.sh

# Build a new set of binutils with the gold linker enabled.
#rm -rf $WD/build-binutils
#mkdir $WD/build-binutils
#cd $WD/build-binutils
#$WD/binutils-2.25/configure --prefix=$CROSS_TOOLCHAIN_DIR --target=${TRIPLE} --enable-gold=yes --with-sysroot=/
#PATH="$CROSS_TOOLCHAIN_DIR/bin:$PATH" make
#PATH="$CROSS_TOOLCHAIN_DIR/bin:$PATH" make install
#cd $WD

#source cross.sh

rm -rf $WD/build-binutils32
mkdir $WD/build-binutils32
cd $WD/build-binutils32
#CC="$CROSS_TOOLCHAIN_DIR/bin/$TRIPLE-gcc" AR="$CROSS_TOOLCHAIN_DIR/bin/$TRIPLE-ar" LD="$CROSS_TOOLCHAIN_DIR/bin/$TRIPLE-ld.gold"
PATH="$CROSS_TOOLCHAIN_DIR/bin:$PATH" $WD/binutils-2.25/configure --prefix="$INSTALL_PREFIX" --target=${TRIPLE} --host=${TRIPLE} --enable-gold=yes --with-sysroot="$LFS" --with-build-time-tools="$CROSS_TOOLCHAIN_DIR/bin"
PATH="$CROSS_TOOLCHAIN_DIR/bin:$PATH" make -j12
PATH="$CROSS_TOOLCHAIN_DIR/bin:$PATH" make install PREFIX="$INSTALL_PREFIX"
cd $WD
