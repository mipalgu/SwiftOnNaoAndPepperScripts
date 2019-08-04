#!/usr/bin/env bash
set -e

source setup.sh

if [ ! -d "binutils-$BINUTILS_VERSION" ]
then
    [ ! -f "binutils-$BINUTILS_VERSION.tar.gz" ] && wget https://ftp.gnu.org/gnu/binutils/binutils-$BINUTILS_VERSION.tar.gz
    tar -xzf binutils-$BINUTILS_VERSION.tar.gz
fi

if [ ! -d "gcc-$GCC_VERSION/cloog" ]
then
    if [ ! -d "gcc-$GCC_VERSION" ]
    then
        [ ! -f "gcc-${GCC_VERSION}.tar.gz" ] && wget https://ftp.gnu.org/gnu/gcc/gcc-${GCC_VERSION}/gcc-${GCC_VERSION}.tar.gz
        tar -xzf gcc-${GCC_VERSION}.tar.gz
    fi
    cd gcc-$GCC_VERSION && ./contrib/download_prerequisites
    cd $WD
fi

if [ ! -d "icu-$ICU4C_VERSION" ]
then
    [ ! -f "icu4c-$ICU4C_VERSION.tar.gz" ] && wget http://download.icu-project.org/files/icu4c/$ICU4C_MAJOR_VERSION.$ICU4C_MINOR_VERSION/icu4c-$ICU4C_VERSION-src.tgz
    mv icu4c-$ICU4C_VERSION-src.tgz icu4c-$ICU4C_VERSION.tar.gz
    tar -xzf icu4c-$ICU4C_VERSION.tar.gz
    mv icu icu-$ICU4C_VERSION
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

if [ ! -d "apple/icu" ]
then
    cd apple
    git clone https://github.com/unicode-org/icu
    tag=`grep "\"icu\": \"" swift/utils/update_checkout/update-checkout-config.json | uniq | sed 's/.*"icu": "\(.*\)\([0-9]*\)-\([0-9]*\).*/\1\2-\3/'`
    cd icu
    git checkout "$tag"
    cd ../..
fi
