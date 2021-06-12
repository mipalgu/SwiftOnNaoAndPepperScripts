#!/usr/bin/env bash
set -e

source setup.sh
source versions.sh
source download.sh

cd $SRC_DIR

download https://cmake.org/files/v$CMAKE_MAJOR_VERSION.$CMAKE_MINOR_VERSION/cmake-$CMAKE_VERSION.tar.gz
download http://github.com/ninja-build/ninja/archive/v$NINJA_VERSION.tar.gz ninja-$NINJA_VERSION.tar.gz

download https://ftp.gnu.org/gnu/binutils/binutils-$BINUTILS_VERSION.tar.gz
download https://ftp.gnu.org/gnu/gcc/gcc-$GCC_VERSION/gcc-$GCC_VERSION.tar.gz
download https://ftp.gnu.org/gnu/glibc/glibc-$GLIBC_VERSION.tar.gz
download https://www.kernel.org/pub/linux/kernel/v$LINUX_MAJOR_VERSION.x/linux-$LINUX_VERSION.tar.xz

download https://zlib.net/zlib-$ZLIB_VERSION.tar.gz
download https://ftp.gnu.org/gnu/ncurses/ncurses-$NCURSES_VERSION.tar.gz
download https://github.com/unicode-org/icu/releases/download/release-$ICU4C_MAJOR_VERSION-$ICU4C_MINOR_VERSION/icu4c-$ICU4C_VERSION-src.tgz
download https://ftp.gnu.org/gnu/libiconv/libiconv-$LIBICONV_VERSION.tar.gz

download https://tukaani.org/xz/xz-$XZ_VERSION.tar.xz
download ftp://xmlsoft.org/libxml2/libxml2-$LIBXML2_VERSION.tar.gz
download https://sourceforge.net/projects/libuuid/files/libuuid-$LIBUUID_VERSION.tar.gz/download libuuid-$LIBUUID_VERSION.tar.gz

download https://ftp.gnu.org/gnu/bash/bash-${BASH_VERSION}.tar.gz
download https://ftp.gnu.org/gnu/coreutils/coreutils-${COREUTILS_VERSION}.tar.xz
download http://ftp.gnu.org/gnu/make/make-$MAKE_VERSION.tar.bz2
download http://ftp.gnu.org/gnu/sed/sed-$SED_VERSION.tar.bz2
download https://ftp.gnu.org/gnu/grep/grep-$GREP_VERSION.tar.xz
download http://ftp.gnu.org/gnu/gawk/gawk-$GAWK_VERSION.tar.xz
download https://curl.haxx.se/download/curl-$CURL_VERSION.tar.gz
download https://mirrors.edge.kernel.org/pub/software/scm/git/git-$GIT_VERSION.tar.xz
download https://github.com/python/cpython/archive/v$PYTHON2_VERSION.tar.gz python-$PYTHON2_VERSION.tar.gz

mkdir -p $SRC_DIR/apple

if [ ! -d "apple/swift" ]
then
    cd "$SRC_DIR/apple"
    git clone https://github.com/apple/swift.git
    cd swift
    git checkout $SWIFT_VERSION
    cd $SRC_DIR
fi

if [ ! -d "apple/cmark" ]
then
    cd $SRC_DIR/apple
    git clone https://github.com/apple/swift-cmark.git cmark
    cd cmark
    git checkout $SWIFT_VERSION
    cd $SRC_DIR
fi

if [ ! -d "apple/llvm-project" ]
then
    cd $SRC_DIR/apple
    git clone https://github.com/apple/llvm-project.git llvm-project
    cd llvm-project
    if [ "$SWIFT_VERSION" = "5.1" ]
    then
    git checkout swift-5.1-DEVELOPMENT-SNAPSHOT-2020-01-28-a
    else
    git checkout $SWIFT_VERSION
    fi
    cd $SRC_DIR
fi

if [ ! -d "apple/swift-corelibs-foundation" ]
then
    cd $SRC_DIR/apple
    git clone https://github.com/apple/swift-corelibs-foundation.git
    cd swift-corelibs-foundation
    git checkout $SWIFT_VERSION
    cd $SRC_DIR
fi

if [ ! -d "apple/swift-corelibs-libdispatch" ]
then
    cd $SRC_DIR/apple
    git clone https://github.com/apple/swift-corelibs-libdispatch.git
    cd swift-corelibs-libdispatch
    git checkout $SWIFT_VERSION
    cd $SRC_DIR
fi

if [ ! -d "apple/swift-corelibs-xctest" ]
then
    cd $SRC_DIR/apple
    git clone https://github.com/apple/swift-corelibs-xctest.git
    cd swift-corelibs-xctest
    git checkout $SWIFT_VERSION
    cd $SRC_DIR
fi

if [ ! -d "apple/tsc" ]
then
    cd $SRC_DIR/apple
    git clone https://github.com/apple/swift-tools-support-core.git tsc
    cd tsc
    cd $SRC_DIR
fi

if [ ! -d "apple/llbuild" ]
then
    cd "$SRC_DIR/apple"
    git clone https://github.com/apple/swift-llbuild.git llbuild
    cd llbuild
    git checkout $SWIFT_VERSION
    cd $SRC_DIR
fi

if [ ! -d "apple/swiftpm" ]
then
    cd $SRC_DIR/apple
    git clone https://github.com/apple/swift-package-manager.git swiftpm
    cd swiftpm
    git checkout $SWIFT_VERSION
    cd $SRC_DIR
fi

if [ ! -d "apple/icu" ]
then
    cd $SRC_DIR/apple
    git clone https://github.com/unicode-org/icu
    tag=`grep "\"icu\": \"" swift/utils/update_checkout/update-checkout-config.json | uniq | sed 's/.*"icu": "\(.*\)\([0-9]*\)-\([0-9]*\).*/\1\2-\3/'`
    cd icu
    git checkout "$tag" || git checkout "release-65-1"
    cd $SRC_DIR
fi

if [ -d apple/llvm-project ]
then
    cd "$SRC_DIR/apple"
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
    cd $SRC_DIR
fi

if [[ ! -L "apple/libcxxabi" && ! -d "apple/libcxxabi" ]]
then
    if [ "$BUILD_LIBCXX" = true ]
    then
        if [ ! -f "libcxxabi-9.0.0.src.tar.xz" ]
        then
            wget http://releases.llvm.org/9.0.0/libcxxabi-9.0.0.src.tar.xz
        fi
        cd "$SRC_DIR/apple"
	rm -rf libcxxabi
        tar -xvf $SRC_DIR/libcxxabi-9.0.0.src.tar.xz
	mv libcxxabi-9.0.0.src libcxxabi
    	cd $SRC_DIR
    fi
fi

cd $WD
