#!/usr/bin/env bash
set -e

source build-config.sh
source cross.sh
source compile-swiftenv-tc.sh

ln -sf $LFS/home/nao/swift-tc/lib/swift $LFS/usr/lib/
ln -sf libgcc_s.so $LFS/lib/libgcc.so
cp -f $CROSS_DIR/lib/gcc/$TRIPLE/$GCC_VERSION/crtbeginS.o $LFS/usr/lib
cp -f $CROSS_DIR/lib/gcc/$TRIPLE/$GCC_VERSION/crtbegin.o $LFS/usr/lib
cp -f $CROSS_DIR/lib/gcc/$TRIPLE/$GCC_VERSION/crtend.o $LFS/usr/lib
cp -f $CROSS_DIR/lib/gcc/$TRIPLE/$GCC_VERSION/crtendS.o $LFS/usr/lib

swift_include_flags=`echo "$INCLUDE_FLAGS" | sed 's/ /;/g'`

if [ ! -f $LIBDISPATCH_BUILD_DIR/.libdispatch-build-cross ]
then
    echo "Compiling libdispatch."
    /usr/local/var/swiftenv/bin/swiftenv local $swiftenv_swift_version-pepper
    rm -rf $LIBDISPATCH_BUILD_DIR
    mkdir -p $LIBDISPATCH_BUILD_DIR
    echo "$SRC_DIR/swift-corelibs-libdispatch/dispatch/module.modulemap"
    cd $LIBDISPATCH_BUILD_DIR
    PATH="$CROSS_DIR/bin:$PATH" CC="$HOST_CLANG" CXX="$HOST_CLANGXX" CPATH="$CPATH" LIBRARY_PATH="$LIBRARY_PATH" LD="$CROSS_DIR/bin/$TRIPLE-ld.gold" cmake -G "Ninja" \
	    -DCMAKE_CROSSCOMPILING=TRUE \
	    -DCMAKE_SYSTEM_NAME="Linux" \
	    -DCMAKE_SYSROOT="$LFS" \
	    -DCMAKE_AR="$CROSS_DIR/bin/$TRIPLE-ar" \
	    -DCMAKE_LINKER="$CROSS_DIR/bin/$TRIPLE-ld.gold" \
	    -DCMAKE_C_COMPILER="$HOST_CLANG" \
	    -DCMAKE_C_COMPILER_TARGET="$TRIPLE" \
	    -DCMAKE_CXX_COMPILER="$HOST_CLANGXX" \
	    -DCMAKE_CXX_COMPILER_TARGET="$TRIPLE" \
	    -DCMAKE_Swift_COMPILER="/usr/local/var/swiftenv/shims/swiftc" \
	    -DCMAKE_Swift_COMPILER_TARGET="$TRIPLE" \
	    -DCMAKE_INSTALL_LIBDIR="$INSTALL_PREFIX/lib" \
            -DCMAKE_C_FLAGS="-gcc-toolchain $CROSS_DIR -fno-stack-protector $INCLUDE_FLAGS $BINARY_FLAGS" \
            -DCMAKE_CXX_FLAGS="-gcc-toolchain $CROSS_DIR -fpermissive $INCLUDE_FLAGS $BINARY_FLAGS" \
            -DCMAKE_EXE_LINKER_FLAGS="-gcc-toolchain $CROSS_DIR $LINK_FLAGS" \
            -DCMAKE_SHARED_LINKER_FLAGS="-gcc-toolchain $CROSS_DIR $LINK_FLAGS" \
	    -DENABLE_SWIFT=YES \
	    -DCMAKE_Swift_FLAGS="-target $TRIPLE -I$INSTALL_PREFIX/lib/swift/linux/i686 -Xcc -I$INSTALL_PREFIX/lib/swift/linux/i686 -Xcc -I$LFS/usr/include -Xcc -I$LFS/include -Xcc -I$CROSS_DIR/lib/gcc/$TRIPLE/$GCC_VERSION/include-fixed -sdk $LFS" \
	    -DAST_TARGET="$TRIPLE" \
	    -DCMAKE_Swift_LINK_FLAGS="-L$INSTALL_PREFIX/swift/linux;-L$INSTALL_PREFIX/lib/swift/linux;-L$INSTALL_PREFIX/lib;-L$LFS/usr/lib;-L$LFS/lib;-sdk;$LFS;-target;$TRIPLE" \
            -DCMAKE_BUILD_TYPE=$CMAKE_BUILD_TYPE \
	    -DCMAKE_SYSTEM_PROCESSOR=$ARCH \
	    $SRC_DIR/swift-corelibs-libdispatch
    cd $SRC_DIR
    PATH="$CROSS_DIR/bin:$PATH" cmake --build $LIBDISPATCH_BUILD_DIR
    PATH="$CROSS_DIR/bin:$PATH" cd $LIBDISPATCH_BUILD_DIR && ninja install
    cd $WD
    /usr/local/var/swiftenv/bin/swiftenv local $swiftenv_swift_version
    touch $LIBDISPATCH_BUILD_DIR/.libdispatch-build-cross
fi

cd $WD
