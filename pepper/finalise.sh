#!/usr/bin/env bash
set -e
source setup.sh

prefix_folder=`basename $INSTALL_PREFIX`
cross_toolchain=`basename $CROSS_TOOLCHAIN_DIR`

FINALISE_DIR=$BUILD_DIR/finalise
mkdir -p $FINALISE_DIR

MIPAL_CROSS=$FINALISE_DIR/$cross_toolchain
MIPAL_CROSSTOOLCHAIN=$FINALISE_DIR/crosstoolchain
mipal_cross_toolchain=`basename "$MIPAL_CROSSTOOLCHAIN"`

# Create pepper.tar.gz
if [ ! -f $WD/pepper.tar.gz ]
then
	tar -czvf pepper.tar.gz -C $INSTALL_PREFIX/.. $prefix_folder/lib
fi

# Create ctc.tar.gz
if [ ! -f $WD/ctc.tar.gz ]
then
    rm -rf $CROSS_TOOLCHAIN_DIR/$TRIPLE/sysroot/home
    mkdir -p $CROSS_TOOLCHAIN_DIR/$TRIPLE/sysroot/home/nao/swift-tc
    cp -r $INSTALL_PREFIX/* $CROSS_TOOLCHAIN_DIR/$TRIPLE/sysroot/home/nao/swift-tc/
    tar -czvf ctc.tar.gz -C $CROSS_TOOLCHAIN_DIR/.. $cross_toolchain
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
    tar -czvf ctc-mipal.tar.gz -C $FINALISE_DIR $cross_toolchain
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
    tar -czvf crosstoolchain.tar.gz -C $FINALISE_DIR $mipal_cross_toolchain
fi
