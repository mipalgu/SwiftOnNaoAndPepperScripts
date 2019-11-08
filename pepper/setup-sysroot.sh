#!/usr/bin/env bash

set -e
source setup.sh

if [ ! -d $LFS ]
then
	mkdir -p $LFS
	mkdir -p $LFS/include
	mkdir -p $INSTALL_PREFIX
	# Copy default sysroot into $LFS
	cp -R $TOOLCHAIN/sysroot/* $LFS/
	ln -s $LFS/usr/include $LFS/usr/include/i386-linux-gnu
fi
