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

if [ ! -d "cmake-$CMAKE_VERSION" ]
then
    [ ! -f "cmake-$CMAKE_VERSION.tar.gz" ] && wget https://github.com/Kitware/CMake/releases/download/v$CMAKE_VERSION/cmake-$CMAKE_VERSION.tar.gz
    tar -xzvf cmake-$CMAKE_VERSION.tar.gz
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

if [ ! -d "apple/cmark" ]
then
    cd apple
    git clone https://github.com/apple/swift-cmark.git cmark
    cd cmark
    git checkout $SWIFT_VERSION
    cd $WD
fi

if [ ! -d "apple/llvm-project" ]
then
    cd apple
    git clone https://github.com/apple/llvm-project.git llvm-project
    cd llvm-project
    git checkout $SWIFT_VERSION
    cd $WD
fi

if [ ! -d "apple/swift-corelibs-foundation" ]
then
    cd apple
    git clone https://github.com/apple/swift-corelibs-foundation.git
    cd swift-corelibs-foundation
    git checkout $SWIFT_VERSION
    cd $WD
fi

if [ ! -d "apple/swift-corelibs-libdispatch" ]
then
    cd apple
    git clone https://github.com/apple/swift-corelibs-libdispatch.git
    cd swift-corelibs-libdispatch
    git checkout $SWIFT_VERSION
    cd $WD
fi

if [ ! -d "apple/swiftpm" ]
then
    cd apple
    git clone https://github.com/apple/swift-package-manager.git swiftpm
    cd swiftpm
    git checkout $SWIFT_VERSION
    cd $WD
fi

if [ ! -d "apple/icu" ]
then
    cd apple
    git clone https://github.com/unicode-org/icu
    tag=`grep "\"icu\": \"" swift/utils/update_checkout/update-checkout-config.json | uniq | sed 's/.*"icu": "\(.*\)\([0-9]*\)-\([0-9]*\).*/\1\2-\3/'`
    cd icu
    git checkout "$tag" || git checkout "release-65-1"
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
