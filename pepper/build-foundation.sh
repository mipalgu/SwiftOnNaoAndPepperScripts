#!/usr/bin/env bash
set -e

source build-config.sh
source cross.sh
source compile-swiftenv-tc.sh

swift_include_flags=`echo "$INCLUDE_FLAGS -I$INSTALL_PREFIX/lib/swift -I$INSTALL_PREFIX/lib/swift/clang/include" | sed 's/ /;/g'`
swift_link_flags=`echo "$LINK_FLAGS" | sed 's/^/-Xlinker;/g' | sed 's/  / /g' | sed 's/ /;-Xlinker;/g' | sed 's/;/ /g'`

if [ ! -f $FOUNDATION_BUILD_DIR/.foundation-build-cross ]
then
    echo "Compiling Foundation."
    /usr/local/var/swiftenv/bin/swiftenv local $swiftenv_swift_version-pepper
    if [ -f $SRC_DIR/swift-corelibs-libdispatch/dispatch/module.modulemap ]
    then
	    mv $SRC_DIR/swift-corelibs-libdispatch/dispatch/module.modulemap $SRC_DIR/swift-corelibs-libdispatch/dispatch/module.modulemap.orig
    fi
    rm -rf $FOUNDATION_BUILD_DIR
    mkdir -p $FOUNDATION_BUILD_DIR
    cd $FOUNDATION_BUILD_DIR
    if [ -f $CROSS_TOOLCHAIN_DIR/curl/share/cmake/curl/curl-config.cmake ]
    then
        mv $CROSS_TOOLCHAIN_DIR/curl/share/cmake/curl/curl-config.cmake $CROSS_TOOLCHAIN_DIR/curl/share/cmake/curl/curl-config.cmake.orig
    fi
    PATH="$CROSS_DIR/bin:$PATH" CC="$HOST_CLANG" CXX="$HOST_CLANGXX" CPATH="$CPATH" LIBRARY_PATH="$LIBRARY_PATH" LD="$CROSS_DIR/bin/$TRIPLE-ld.gold" cmake -G "Ninja" \
	    -DCMAKE_CROSSCOMPILING=TRUE \
	    -DCMAKE_SYSTEM_NAME="Linux" \
	    -DCMAKE_SYSROOT="$LFS" \
	    -DCMAKE_INSTALL_PREFIX="$INSTALL_PREFIX" \
	    -DCMAKE_ASM_COMPILER="$HOST_CLANG" \
	    -DCMAKE_RANLIB="$CROSS_DIR/bin/$TRIPLE-ranlib" \
	    -DCMAKE_AR="$CROSS_DIR/bin/$TRIPLE-ar" \
	    -DCMAKE_LINKER="$CROSS_DIR/bin/$TRIPLE-ld.gold" \
	    -DCMAKE_C_COMPILER="$HOST_CLANG" \
	    -DCMAKE_C_COMPILER_TARGET="$TRIPLE" \
	    -DCMAKE_CXX_COMPILER="$HOST_CLANGXX" \
	    -DCMAKE_CXX_COMPILER_TARGET="$TRIPLE" \
            -DCMAKE_ASM_FLAGS="-gcc-toolchain $CROSS_DIR -target $TRIPLE" \
            -DCMAKE_C_FLAGS="-gcc-toolchain $CROSS_DIR -fno-stack-protector $INCLUDE_FLAGS $BINARY_FLAGS -I$INSTALL_PREFIX/lib/swift/Block -I$INSTALL_PREFIX/lib/swift" \
            -DCMAKE_CXX_FLAGS="-gcc-toolchain $CROSS_DIR -fpermissive $INCLUDE_FLAGS $BINARY_FLAGS -I$INSTALL_PREFIX/lib/swift/Block -I$INSTALL_PREFIX/lib/swift" \
            -DCMAKE_EXE_LINKER_FLAGS="-gcc-toolchain $CROSS_DIR $LINK_FLAGS" \
            -DCMAKE_SHARED_LINKER_FLAGS="-gcc-toolchain $CROSS_DIR $LINK_FLAGS" \
	    -Ddispatch_DIR="$DISPATCH_BUILD_DIR/cmake/modules" \
	    -DCURL_INCLUDE_DIR="$CROSS_TOOLCHAIN_DIR/curl/include" \
	    -DICU_INCLUDE_DIR="$INSTALL_PREFIX/include" \
	    -DCURL_FOUND=TRUE \
	    -DCURL_DIR="$CROSS_TOOLCHAIN_DIR/curl" \
	    -DCURL_INCLUDE_DIRS="$CROSS_TOOLCHAIN_DIR/curl/include" \
	    -DCURL_LIBRARIES="$CROSS_TOOLCHAIN_DIR/curl/lib/libcurl.so" \
	    -DCMAKE_LIBRARY_PATH="$CROSS_TOOLCHAIN_DIR/curl/lib;$INSTALL_PREFIX/lib;$CROSS_TOOLCHAIN_DIR/xml2/lib" \
	    -DCMAKE_Swift_COMPILER="/usr/local/var/swiftenv/shims/swiftc" \
	    -DCMAKE_Swift_FLAGS="-nostdimport -I$INSTALL_PREFIX/lib/swift/linux/i686 -I$LFS/usr/include -I$LFS/include -I$CROSS_DIR/lib/gcc/$TRIPLE/$GCC_VERSION/include-fixed -sdk $LFS $swift_link_flags -target $TRIPLE" \
	    -DAST_TARGET="$TRIPLE" \
	    -DCMAKE_Swift_LINK_FLAGS="-L$INSTALL_PREFIX/swift/linux -L$INSTALL_PREFIX/lib/swift/linux -L$INSTALL_PREFIX/lib -L$LFS/usr/lib -L$LFS/lib -sdk $LFS -target;$TRIPLE" \
            -DCMAKE_BUILD_TYPE=$CMAKE_BUILD_TYPE \
	    -DBUILD_SHARED_LIBS=YES \
	    -DCMAKE_SYSTEM_PROCESSOR=$ARCH \
	    $SRC_DIR/swift-corelibs-foundation
    if [ -f $CROSS_TOOLCHAIN_DIR/curl/share/cmake/curl/curl-config.cmake.orig ]
    then
        mv $CROSS_TOOLCHAIN_DIR/curl/share/cmake/curl/curl-config.cmake.orig $CROSS_TOOLCHAIN_DIR/curl/share/cmake/curl/curl-config.cmake
    fi
    cd $SRC_DIR
    PATH="$CROSS_DIR/bin:$PATH" cmake --build $FOUNDATION_BUILD_DIR
    PATH="$CROSS_DIR/bin:$PATH" cd $FOUNDATION_BUILD_DIR && ninja install
    cd $WD
    /usr/local/var/swiftenv/bin/swiftenv local $swiftenv_swift_version
    touch $FOUNDATION_BUILD_DIR/.foundation-build-cross
fi

cd $WD
