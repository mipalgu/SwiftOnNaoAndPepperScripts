#!/usr/bin/env bash
set -e

source build-config.sh
source cross.sh
source compile-swiftenv-tc.sh

swift_include_flags=`echo "$INCLUDE_FLAGS -I$INSTALL_PREFIX/lib/swift -I$INSTALL_PREFIX/lib/swift/clang/include" | sed 's/ /;/g'`

if [ ! -f $FOUNDATION_BUILD_DIR/.foundation-build-cross ]
then
    echo "Compiling Foundation."
    /usr/local/var/swiftenv/bin/swiftenv local $swiftenv_swift_version-pepper
    rm -rf $FOUNDATION_BUILD_DIR
    mkdir -p $FOUNDATION_BUILD_DIR
    cd $FOUNDATION_BUILD_DIR
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
	    -DINSTALL_LIBDIR="$INSTALL_PREFIX/lib" \
            -DCMAKE_C_FLAGS="-gcc-toolchain $CROSS_DIR -fno-stack-protector $INCLUDE_FLAGS $BINARY_FLAGS -I$INSTALL_PREFIX/lib/swift/Block -I$INSTALL_PREFIX/lib/swift" \
            -DCMAKE_CXX_FLAGS="-gcc-toolchain $CROSS_DIR -fpermissive $INCLUDE_FLAGS $BINARY_FLAGS -I$INSTALL_PREFIX/lib/swift/Block -I$INSTALL_PREFIX/lib/swift" \
            -DCMAKE_EXE_LINKER_FLAGS="-gcc-toolchain $CROSS_DIR $LINK_FLAGS" \
            -DCMAKE_SHARED_LINKER_FLAGS="-gcc-toolchain $CROSS_DIR $LINK_FLAGS" \
	    -DCURL_INCLUDE_DIR="$CROSS_TOOLCHAIN_DIR/curl/include" \
	    -DICU_INCLUDE_DIR="$INSTALL_PREFIX/include" \
	    -DCMAKE_LIBRARY_PATH="$CROSS_TOOLCHAIN_DIR/curl/lib;$INSTALL_PREFIX/lib" \
	    -DENABLE_SWIFT=YES \
	    -DCMAKE_SWIFT_COMPILER="/usr/local/var/swiftenv/shims/swiftc" \
	    -DCMAKE_SWIFT_FLAGS="-I$INSTALL_PREFIX/lib/swift/linux/i686;$swift_include_flags;-I$LFS/usr/include;-I$LFS/include;-I$CROSS_DIR/lib/gcc/$TRIPLE/$GCC_VERSION/include-fixed;-sdk;$LFS;" \
	    -DAST_TARGET="$TRIPLE" \
	    -DCMAKE_SWIFT_LINK_FLAGS="-L$INSTALL_PREFIX/swift/linux;-L$INSTALL_PREFIX/lib/swift/linux;-L$INSTALL_PREFIX/lib;-L$LFS/usr/lib;-L$LFS/lib;-sdk;$LFS;-target;$TRIPLE" \
            -DCMAKE_BUILD_TYPE=$CMAKE_BUILD_TYPE \
	    -DCMAKE_SYSTEM_PROCESSOR=$ARCH \
	    $SRC_DIR/swift-corelibs-foundation
    cd $SRC_DIR
    PATH="$CROSS_DIR/bin:$PATH" cmake --build $FOUNDATION_BUILD_DIR
    PATH="$CROSS_DIR/bin:$PATH" cd $FOUNDATION_BUILD_DIR && ninja install
    cd $WD
    /usr/local/var/swiftenv/bin/swiftenv local $swiftenv_swift_version
    touch $FOUNDATION_BUILD_DIR/.foundation-build-cross
fi

cd $WD
