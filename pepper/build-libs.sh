#!/usr/bin/env bash
set -e

source setup.sh

if [ ! -f $WD/build-icu-host/.build-icu-host ]
then
    cd $WD/icu-$ICU4C_VERSION/source
    [ -f Makefile ] && make distclean
    rm -rf $WD/build-icu-host
    mkdir $WD/build-icu-host
    cd $WD/build-icu-host
    if [[ "$OSTYPE" == "darwin"* ]]
    then
        CC="xcrun clang" CXX="xcrun clang++" $WD/icu-$ICU4C_VERSION/source/runConfigureICU MacOSX --prefix=$WD/icu
    else
        $WD/icu-$ICU4C_VERSION/source/runConfigureICU Linux
    fi
    make
    touch .build-icu-host
    cd $WD
fi

cd $WD/icu-$ICU4C_VERSION/source
[ -f Makefile ] && make distclean
rm -rf $WD/build-icu
mkdir $WD/build-icu
cd $WD/build-icu
PATH="$CROSS_DIR/bin:$CROSS_DIR/$TRIPLE/bin:$PATH" CC="$CROSS_DIR/bin/$TRIPLE-gcc" CXX="$CROSS_DIR/bin/$TRIPLE-g++" AR="$CROSS_DIR/bin/$TRIPLE-ar" LD="$CROSS_DIR/bin/$TRIPLE-ld" $WD/icu-$ICU4C_VERSION/source/configure --prefix=$INSTALL_PREFIX --host=${TRIPLE} --with-cross-build="$WD/build-icu-host"
make
make install
cd $WD
