#!/usr/bin/env bash
set -e

source setup.sh
source download.sh

cd $SRC_DIR

download https://ftp.gnu.org/gnu/binutils/binutils-$BINUTILS_VERSION.tar.gz
download https://ftp.gnu.org/gnu/gcc/gcc-$GCC_VERSION/gcc-$GCC_VERSION.tar.gz

cd $WD
