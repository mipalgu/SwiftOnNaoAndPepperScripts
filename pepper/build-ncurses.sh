#!/usr/bin/env bash
set -e

source build-config.sh


if [ ! -f $NCURSES_BUILD_DIR/.ncurses-build-cross ]
then
    echo "Compiling ncurses."
    rm -rf $NCURSES_BUILD_DIR
    mkdir -p $NCURSES_BUILD_DIR
    cd $NCURSES_BUILD_DIR
    PATH="$CROSS_DIR/bin:$PATH" $WD/ncurses/configure --host="$TRIPLE" --prefix="$INSTALL_PREFIX" --with-shared --without-debug --with-build-cc="/usr/bin/gcc" --with-build-cpp="/usr/bin/g++"
    PATH="$CROSS_DIR/bin:$PATH" make -j${PARALLEL}
    PATH="$CROSS_DIR/bin:$PATH" make install
    cd $WD
    touch $NCURSES_BUILD_DIR/.ncurses-build-cross
fi

cd $WD
