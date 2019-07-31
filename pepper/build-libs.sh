#!/usr/bin/env bash
set -e

source setup.sh

if [ ! -f $WD/build-icu-host/.build-icu-host ]
then
    cd $WD/apple/icu/icu4c/source
    [ -f Makefile ] && make distclean
    rm -rf $WD/build-icu-host
    mkdir $WD/build-icu-host
    cd $WD/build-icu-host
    if [[ "$OSTYPE" == "darwin"* ]]
    then
        CC="xcrun clang" CXX="xcrun clang++" $WD/apple/icu/icu4c/source/runConfigureICU MacOSX --prefix=$WD/icu
    else
        $WD/apple/icu/icu4c/source/runConfigureICU Linux
    fi
    make
    touch .build-icu-host
    cd $WD
fi

source cross.sh

cd $WD/apple/icu/icu4c/source
[ -f Makefile ] && make distclean
rm -rf $WD/build-icu
mkdir $WD/build-icu
cd $WD/build-icu
PATH="$CROSS_DIR/bin:$PATH" CFLAGS="$INCLUDE_FLAGS $BINARY_FLAGS" CXXFLAGS="$INCLUDE_FLAGS $BINARY_FLAGS" LDFLAGS="$LINK_FLAGS" $WD/apple/icu/icu4c/source/configure --prefix=$INSTALL_PREFIX --host=${TRIPLE} --with-cross-build="$WD/build-icu-host"
PATH="$CROSS_DIR/bin:$PATH" make
PATH="$CROSS_DIR/bin:$PATH" make install
cd $WD
