#!/usr/bin/env bash
set -e

source setup.sh

if [ ! -f "binutils-$BINUTILS_VERSION.tar.gz" ]
then
    wget https://ftp.gnu.org/gnu/binutils/binutils-$BINUTILS_VERSION.tar.gz
    tar -xzf binutils-$BINUTILS_VERSION.tar.gz
fi

mkdir -p apple

if [ ! -d "apple/swift" ]
then
    cd apple
    git clone https://github.com/apple/swift.git
    cd swift
    git checkout $SWIFT_VERSION
    cd ..
    cd ..
fi

if [ ! -d "apple/llvm" ]
then
    cd apple
    ./swift/utils/update-checkout --clone --tag $SWIFT_VERSION
    cd ..
fi
