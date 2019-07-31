#!/usr/bin/env bash
set -e

source setup.sh
source versions.sh

#LFS=$CROSS_TOOLCHAIN_DIR/$TRIPLE/sysroot

if [ ! -f gcc-${GCC_VERSION}.tar.gz ]; then
    wget https://ftp.gnu.org/gnu/gcc/gcc-${GCC_VERSION}/gcc-${GCC_VERSION}.tar.gz
    mv gcc-${GCC_VERSION}.tar.gz ${SRC_DIR}/
fi

#source cross-gcc-headers.sh

cd ${SRC_DIR}
if [ ! -d gcc-${GCC_VERSION} ]; then
    rm -rf gcc-${GCC_VERSION}
    tar -xzvf gcc-${GCC_VERSION}.tar.gz
    cd gcc-${GCC_VERSION}
    ./contrib/download_prerequisites
    #cd libdecnumber
    #ln -s bid/decimal*.h .
    #ln -s dpd no
fi
cd ${BUILD_DIR}
rm -rf build-gcc
mkdir -p build-gcc
cd build-gcc
export PATH="$LFS/usr/local/bin:$LFS/usr/bin:/usr/local/bin:/usr/bin:/bin"
export LANG=/usr/lib/locale/en_US
CC="$CROSS_TOOLCHAIN_DIR/bin/${TRIPLE}-gcc" \
 CXX="$CROSS_TOOLCHAIN_DIR/bin/${TRIPLE}-g++" \
 LD="${CROSS_TOOLCHAIN_DIR}/bin/${TRIPLE}-ld" \
 AR="${CROSS_TOOLCHAIN_DIR}/bin/${TRIPLE}-ar" \
 RANLIB="${CROSS_TOOLCHAIN_DIR}/bin/${TRIPLE}-ranlib" \
 CFLAGS="-I$LFS/include/c++/4.9.2 -I$LFS/include/c++/4.9.2/i686-aldebaran-linux-gnu -I$LFS/usr/include" \
 CXXFLAGS="-I$LFS/include/c++/4.9.2 -I$LFS/include/c++/4.9.2/i686-aldebaran-linux-gnu -I$LFS/usr/include" \
 LD_FOR_BUILD="${CROSS_TOOLCHAIN_DIR}/bin/${TRIPLE}-ld" \
 LD_FOR_TARGET="${CROSS_TOOLCHAIN_DIR}/bin/${TRIPLE}-ld" \
 ${SRC_DIR}/gcc-${GCC_VERSION}/configure \
    --prefix=$INSTALL_PREFIX \
    --with-newlib \
    --with-sysroot="$LFS" \
    --with-local-prefix=$LFS \
    --with-native-system-header-dir=$LFS/include \
    --disable-shared \
    --enable-static \
    --host="${TRIPLE}" \
    --enable-languages=c,c++ \
    --with-build-time-tools="$CROSS_TOOLCHAIN_DIR/bin"
make
