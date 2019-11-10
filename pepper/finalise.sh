#!/usr/bin/env bash
set -e
source setup.sh

MIPAL_CROSS=$CROSS_DIR-mipal

tar -czf pepper.tar.gz $INSTALL_PREFIX/lib
rm -rf $CROSS_TOOLCHAIN_DIR/$TRIPLE/sysroot/home
mkdir -p $CROSS_TOOLCHAIN_DIR/$TRIPLE/sysroot/home/nao/swift-tc
cp -r $INSTALL_PREFIX/* $CROSS_TOOLCHAIN_DIR/$TRIPLE/sysroot/home/nao/swift-tc/
tar -czvf ctc.tar.gz $CROSS_DIR
cp -r $CROSS_DIR $MIPAL_CROSS
mkdir -p $MIPAL_CROSS/cross
mv $MIPAL_CROSS/bin $MIPAL_CROSS/cross/
mv $MIPAL_CROSS/include $MIPAL_CROSS/cross/
mv $MIPAL_CROSS/lib $MIPAL_CROSS/cross/
mv $MIPAL_CROSS/libexec $MIPAL_CROSS/cross/
mv $MIPAL_CROSS/share $MIPAL_CROSS/cross/
mv $MIPAL_CROSS/$TRIPLE $MIPAL_CROSS/cross/
tar -czf ctc-mipal.tar.gz $MIPAL_CROSS
