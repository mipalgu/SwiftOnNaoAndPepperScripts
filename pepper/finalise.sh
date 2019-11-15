#!/usr/bin/env bash
set -e
source setup.sh

MIPAL_CROSS=$CROSS_DIR-mipal
MIPAL_CROSSTOOLCHAIN=$WD/crosstoolchain

# Create ctc.tar.gz
if [ ! -f $WD/ctc.tar.gz ]
then
    tar -czf pepper.tar.gz $INSTALL_PREFIX/lib
    rm -rf $CROSS_TOOLCHAIN_DIR/$TRIPLE/sysroot/home
    mkdir -p $CROSS_TOOLCHAIN_DIR/$TRIPLE/sysroot/home/nao/swift-tc
    cp -r $INSTALL_PREFIX/* $CROSS_TOOLCHAIN_DIR/$TRIPLE/sysroot/home/nao/swift-tc/
    tar -czvf ctc.tar.gz $CROSS_DIR
fi

# Create MiPal ctc.
if [ ! -f $WD/ctc-mipal.tar.gz ]
then
    rm -rf $MIPAL_CROSS
    cp -r $CROSS_DIR $MIPAL_CROSS
    mkdir -p $MIPAL_CROSS/cross
    mv $MIPAL_CROSS/bin $MIPAL_CROSS/cross/
    mv $MIPAL_CROSS/lib $MIPAL_CROSS/cross/
    mv $MIPAL_CROSS/libexec $MIPAL_CROSS/cross/
    mv $MIPAL_CROSS/share $MIPAL_CROSS/cross/
    mv $MIPAL_CROSS/$TRIPLE $MIPAL_CROSS/cross/
    ln -s libgcc_s.so $MIPAL_CROSS/cross/$TRIPLE/sysroot/lib/libgcc.so
    rm -f $MIPAL_CROSS/cross/$TRIPLE/sysroot/usr/lib/crtbeginS.o
    rm -f $MIPAL_CROSS/cross/$TRIPLE/sysroot/usr/lib/crtbegin.o
    rm -f $MIPAL_CROSS/cross/$TRIPLE/sysroot/usr/lib/crtend.o
    rm -f $MIPAL_CROSS/cross/$TRIPLE/sysroot/usr/lib/crtendS.o
    ln -s ../../../../lib/gcc/$TRIPLE/$GCC_VERSION/crtbeginS.o $MIPAL_CROSS/cross/$TRIPLE/sysroot/usr/lib/
    ln -s ../../../../lib/gcc/$TRIPLE/$GCC_VERSION/crtbegin.o $MIPAL_CROSS/cross/$TRIPLE/sysroot/usr/lib/
    ln -s ../../../../lib/gcc/$TRIPLE/$GCC_VERSION/crtend.o $MIPAL_CROSS/cross/$TRIPLE/sysroot/usr/lib/
    ln -s ../../../../lib/gcc/$TRIPLE/$GCC_VERSION/crtendS.o $MIPAL_CROSS/cross/$TRIPLE/sysroot/usr/lib/
    tar -czf ctc-mipal.tar.gz $MIPAL_CROSS
fi

# Create crosstoolchain directory.
if [ ! -f $WD/crosstoolchain.tar.gz ]
then
    rm -rf $MIPAL_CROSSTOOLCHAIN
    mkdir -p $MIPAL_CROSSTOOLCHAIN/cross/atom
    mkdir -p $MIPAL_CROSSTOOLCHAIN/staging/atom
    cp -r $CROSS_DIR/bin $MIPAL_CROSSTOOLCHAIN/cross/atom/
    cp -r $CROSS_DIR/include $MIPAL_CROSSTOOLCHAIN/cross/atom/
    cp -r $CROSS_DIR/lib $MIPAL_CROSSTOOLCHAIN/cross/atom/
    cp -r $CROSS_DIR/libexec $MIPAL_CROSSTOOLCHAIN/cross/atom/
    cp -r $CROSS_DIR/share $MIPAL_CROSSTOOLCHAIN/cross/atom/
    cp -r $CROSS_DIR/$TRIPLE $MIPAL_CROSSTOOLCHAIN/cross/atom/
    cp -r $CROSS_DIR/* $MIPAL_CROSSTOOLCHAIN/staging/atom/
    rm -rf $MIPAL_CROSSTOOLCHAIN/staging/atom/bin
    rm -rf $MIPAL_CROSSTOOLCHAIN/staging/atom/include
    rm -rf $MIPAL_CROSSTOOLCHAIN/staging/atom/lib
    rm -rf $MIPAL_CROSSTOOLCHAIN/staging/atom/libexec
    rm -rf $MIPAL_CROSSTOOLCHAIN/staging/atom/share
    rm -rf $MIPAL_CROSSTOOLCHAIN/staging/atom/$TRIPLE
    ln -s ../../cross/atom $MIPAL_CROSSTOOLCHAIN/staging/atom/cross
    ln -s ../../cross/atom/$TRIPLE/sysroot $MIPAL_CROSSTOOLCHAIN/staging/atom/sysroot
    ln -s atom/cross/$TRIPLE/sysroot $MIPAL_CROSSTOOLCHAIN/staging/atom-linux
    ln -s atom-linux $MIPAL_CROSSTOOLCHAIN/staging/$TRIPLE
    ln -s atom-linux $MIPAL_CROSSTOOLCHAIN/staging/$ARCH-$OS
    tar -czf crosstoolchain.tar.gz $MIPAL_CROSSTOOLCHAIN
fi
