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

if [ ! -d "gcc-$GCC_VERSION-patched/cloog" ]
then
    if [ ! -d "gcc-$GCC_VERSION" ]
    then
        [ ! -f "gcc-${GCC_VERSION}.tar.gz" ] && wget https://ftp.gnu.org/gnu/gcc/gcc-${GCC_VERSION}/gcc-${GCC_VERSION}.tar.gz
        tar -xzf gcc-${GCC_VERSION}.tar.gz
    fi
    if [ ! -d "gcc-$GCC_VERSION/cloog" ]
    then
        cd gcc-$GCC_VERSION && ./contrib/download_prerequisites
        cd $WD
    fi
    cp -R gcc-$GCC_VERSION gcc-$GCC_VERSION-patched
    for file in \
     $(find gcc-$GCC_VERSION-patched/config -name linux64.h -o -name linux.h -o -name sysv4.h)
    do
      cp -uv $file{,.orig}
      sed -e "s@/lib\(64\)\?\(32\)\?/ld@/$CROSS_DIR/bin&@g" \
          -e "s@/usr@/$CROSS_DIR@g" $file.orig > $file
      echo '
#undef STANDARD_STARTFILE_PREFIX_1
#undef STANDARD_STARTFILE_PREFIX_2
#define STANDARD_STARTFILE_PREFIX_1 "/tools/lib/"
#define STANDARD_STARTFILE_PREFIX_2 ""' >> $file
      touch $file.orig
    done
    sed -i '/k prot/agcc_cv_libc_provides_ssp=yes' gcc-$GCC_VERSION-patched/configure
    cd $WD
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
    for f in apple/llvm-project/*
    do
        if [ -d "$f" ]
        then
            if [[ ! -L "apple/`basename $f`" && ! -d "apple/`basename $f`" ]]
	    then
                echo "symlink: ln -s $f apple/"
                ln -s $f apple/
            fi
        fi
    done
    mkdir -p apple/llvm/tools
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
