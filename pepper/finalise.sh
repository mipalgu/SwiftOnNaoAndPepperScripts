#!/usr/bin/env bash
set -e
source setup.sh

tar -czf pepper.tar.gz $INSTALL_PREFIX/lib
rm -rf $CROSS_TOOLCHAIN_DIR/$TRIPLE/sysroot/home
mkdir -p $CROSS_TOOLCHAIN_DIR/$TRIPLE/sysroot/home/nao/swift-tc
cp -r $INSTALL_PREFIX/* $CROSS_TOOLCHAIN_DIR/$TRIPLE/sysroot/home/nao/swift-tc/
tar -czvf ctc.tar.gz $CROSS_DIR
