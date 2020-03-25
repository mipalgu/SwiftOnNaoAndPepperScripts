#!/usr/bin/env bash
set -e

source setup.sh
source download.sh

mkdir -p $SRC_DIR/apple

if [ ! -d "$SRC_DIR/apple/swift" ]
then
    cd $SRC_DIR/apple
    git clone https://github.com/apple/swift.git
    cd swift
    git checkout $SWIFT_VERSION
    cd ..
    cd ..
fi

if [ ! -d "$SRC_DIR/apple/llvm" ]
then
    cd $SRC_DIR/apple
    /usr/local/bin/python swift/utils/update-checkout --clone --tag $SWIFT_VERSION
    cd ..
fi

if [ "$BUILD_LIBCXX" = true ]
then
    if [ ! -d "$SRC_DIR/apple/libcxxabi" ]
    then
    	cd $SRC_DIR
        download http://releases.llvm.org/9.0.0/libcxxabi-9.0.0.src.tar.xz
        cd "$SRC_DIR/apple"
	rm -rf libcxxabi
        tar -xvf $SRC_DIR/libcxxabi-9.0.0.src.tar.xz
	mv libcxxabi-9.0.0.src libcxxabi
        cd $SRC_DIR/apple
    fi
fi

cd $WD
