#!/usr/bin/env bash
set -e

source build-config.sh
source cross.sh
source compile-swiftenv-tc.sh

swift_include_flags=`echo "$INCLUDE_FLAGS -I$INSTALL_PREFIX/lib/swift -I$INSTALL_PREFIX/lib/swift/clang/include" | sed 's/ /;/g'`
swift_link_flags=`echo "$LINK_FLAGS" | sed 's/^/-Xlinker;/g' | sed 's/  / /g' | sed 's/ /;-Xlinker;/g'`
swift_link_flags=

if [ ! -f $XCTEST_BUILD_DIR/.xctest-build-cross ]
then
    echo "Compiling XCTest."
    /usr/local/var/swiftenv/bin/swiftenv local $swiftenv_swift_version-pepper
    rm -rf $XCTEST_BUILD_DIR
    mkdir -p $XCTEST_BUILD_DIR
    cd $XCTEST_BUILD_DIR
    PATH="$CROSS_DIR/bin:$PATH" CC="$HOST_CLANG" CXX="$HOST_CLANGXX" CPATH="$CPATH" LIBRARY_PATH="$LIBRARY_PATH" LD="$CROSS_DIR/bin/$TRIPLE-ld.gold" cmake -G "Ninja" \
	    -DCMAKE_CROSSCOMPILING=TRUE \
	    -DCMAKE_SYSTEM_NAME="Linux" \
	    -DCMAKE_SYSROOT="$LFS" \
	    -DCMAKE_INSTALL_PREFIX="$INSTALL_PREFIX" \
	    -DCMAKE_RANLIB="$CROSS_DIR/bin/$TRIPLE-ranlib" \
	    -DCMAKE_AR="$CROSS_DIR/bin/$TRIPLE-ar" \
	    -DCMAKE_LINKER="$CROSS_DIR/bin/$TRIPLE-ld.gold" \
	    -DCMAKE_C_COMPILER="$HOST_CLANG" \
	    -DCMAKE_C_COMPILER_TARGET="$TRIPLE" \
	    -DCMAKE_CXX_COMPILER_TARGET="$TRIPLE" \
            -DCMAKE_C_FLAGS="-gcc-toolchain $CROSS_DIR -fno-stack-protector $INCLUDE_FLAGS $BINARY_FLAGS -I$INSTALL_PREFIX/lib/swift/Block -I$INSTALL_PREFIX/lib/swift" \
            -DCMAKE_EXE_LINKER_FLAGS="-gcc-toolchain $CROSS_DIR $LINK_FLAGS" \
            -DCMAKE_SHARED_LINKER_FLAGS="-gcc-toolchain $CROSS_DIR $LINK_FLAGS" \
	    -DCMAKE_SWIFT_COMPILER="/usr/local/var/swiftenv/shims/swiftc" \
	    -DCMAKE_SWIFT_FLAGS="-I$INSTALL_PREFIX/lib/swift/linux/i686;$swift_include_flags;-I$LFS/usr/include;-I$LFS/include;-I$CROSS_DIR/lib/gcc/$TRIPLE/$GCC_VERSION/include-fixed;-sdk;$LFS;$swift_link_flags;" \
	    -DAST_TARGET="$TRIPLE" \
	    -DCMAKE_SWIFT_LINK_FLAGS="-L$INSTALL_PREFIX/swift/linux;-L$INSTALL_PREFIX/lib/swift/linux;-L$INSTALL_PREFIX/lib;-L$LFS/usr/lib;-L$LFS/lib;-sdk;$LFS;-target;$TRIPLE" \
            -DCMAKE_BUILD_TYPE=$CMAKE_BUILD_TYPE \
	    -DBUILD_SHARED_LIBS=YES \
	    -DCMAKE_SYSTEM_PROCESSOR=$ARCH \
	    $SRC_DIR/swift-corelibs-xctest
    cd $SRC_DIR
    PATH="$CROSS_DIR/bin:$PATH" cmake --build $XCTEST_BUILD_DIR
    PATH="$CROSS_DIR/bin:$PATH" cd $XCTEST_BUILD_DIR && ninja install
    cd $WD
    /usr/local/var/swiftenv/bin/swiftenv local $swiftenv_swift_version
    touch $XCTEST_BUILD_DIR/.xctest-build-cross
fi

cd $WD
