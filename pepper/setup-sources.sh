#!/usr/bin/env bash
set -e

source setup.sh

mkdir -p $SRC_DIR
mkdir -p $BUILD_DIR

if [ ! -d "binutils-$BINUTILS_VERSION" ]
then
    [ ! -f "binutils-$BINUTILS_VERSION.tar.gz" ] && wget https://ftp.gnu.org/gnu/binutils/binutils-$BINUTILS_VERSION.tar.gz
    tar -xzf binutils-$BINUTILS_VERSION.tar.gz
fi

if [ ! -d "libuuid-$UUID_VERSION" ]
then
    [ ! -f "libuuid-$UUID_VERSION.tar.gz" ] && wget http://sourceforge.net/projects/libuuid/files/libuuid-$UUID_VERSION.tar.gz/download
    mv download libuuid-$UUID_VERSION.tar.gz
    tar -xzf libuuid-$UUID_VERSION.tar.gz
fi


mkdir -p apple

if [ ! -d "apple/swift" ]
then
    cd apple
    git clone https://github.com/apple/swift.git
    cd swift
    git checkout $SWIFT_VERSION
    cd $WD
fi

if [ ! -d "apple/llvm" ]
then
    cd apple
    ./swift/utils/update-checkout --clone --tag $SWIFT_VERSION
    cd $WD
fi

if [ ! -d "apple/icu" ]
then
    cd apple
    git clone https://github.com/unicode-org/icu
    tag=`grep "\"icu\": \"" swift/utils/update_checkout/update-checkout-config.json | uniq | sed 's/.*"icu": "\(.*\)\([0-9]*\)-\([0-9]*\).*/\1\2-\3/'`
    cd icu
    git checkout "$tag"
    cd $WD
fi

if [ -d apple/llvm-project ]
then
    cd apple
    for f in llvm-project/*
    do
        if [ -d "$f" ]
        then
            if [[ ! -L "`basename $f`" && ! -d "`basename $f`" ]]
	    then
                echo "symlink: ln -s $f ."
                ln -s $f .
            fi
        fi
    done
    cd ..
fi

if [[ ! -L "apple/libcxxabi" && ! -d "apple/libcxxabi" ]]
then
    if [ "$BUILD_LIBCXX" = true ]
    then
        if [ ! -f "libcxxabi-9.0.0.src.tar.xz" ]
        then
            wget http://releases.llvm.org/9.0.0/libcxxabi-9.0.0.src.tar.xz
        fi
        cd "$SRC_DIR"
	rm -rf libcxxabi
        tar -xvf $WD/libcxxabi-9.0.0.src.tar.xz
	mv libcxxabi-9.0.0.src libcxxabi
        cd $WD
    fi
fi
