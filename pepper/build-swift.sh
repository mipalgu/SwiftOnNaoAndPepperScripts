#!/usr/bin/env bash
set -e

source build-config.sh

cd $WD
source cross.sh
cd $SRC_DIR

if [ ! -f $SWIFT_BUILD_DIR/.swift-build-cross ]
then
    echo "Compiling swift."
    rm -rf $SWIFT_BUILD_DIR
    mkdir -p $SWIFT_BUILD_DIR
    cd $SWIFT_BUILD_DIR
    PATH="$CROSS_DIR/bin:$PATH" CC="$HOST_CLANG" CXX="$HOST_CLANGXX" CPATH="$CPATH" LIBRARY_PATH="$LIBRARY_PATH" cmake -G "Ninja" \
      -DCMAKE_PREFIX_PATH="$PREFIX_PATH" \
      -DCMAKE_CROSSCOMPILING=TRUE \
      -DCMAKE_SYSROOT="$LFS" \
      -DCMAKE_INSTALL_PREFIX="$INSTALL_PREFIX" \
      -DCMAKE_C_COMPILER="$HOST_CLANG" \
      -DCMAKE_CXX_COMPILER="$HOST_CLANGXX" \
      -DCMAKE_ASM_COMPILER="$HOST_CLANG" \
      -DPYTHON_EXECUTABLE="${PYTHON}" \
      -DCMAKE_BUILD_TYPE=$CMAKE_BUILD_TYPE \
      -DSWIFT_PATH_TO_CMARK_SOURCE="$SRC_DIR/cmark" \
      -DSWIFT_PATH_TO_CMARK_BUILD="$CMARK_BUILD_DIR" \
      -DSWIFT_CMARK_LIBRARY_DIR="$CMARK_BUILD_DIR/src" \
      -DSWIFT_PATH_TO_LLVM_SOURCE="$SRC_DIR/llvm" \
      -DSWIFT_PATH_TO_LLVM_BUILD="$LLVM_BUILD_DIR" \
      -DSWIFT_PATH_TO_CLANG_SOURCE="$SRC_DIR/clang" \
      -DSWIFT_PATH_TO_CLANG_BUILD="$LLVM_BUILD_DIR" \
      -DSWIFT_INCLUDE_DOCS=FALSE \
      -DSWIFT_INCLUDE_TESTS=TRUE \
      -DSWIFT_BUILD_PERF_TESTSUITE=FALSE \
      -DSWIFT_BUILD_DYNAMIC_SDK_OVERLAY=TRUE \
      -DSWIFT_BUILD_RUNTIME_WITH_HOST_COMPILER=TRUE \
      -DSWIFT_STDLIB_BUILD_TYPE=$CMAKE_BUILD_TYPE \
      -DSWIFT_SOURCE_DIR="$SRC_DIR/swift" \
      -DSWIFT_HOST_VARIANT="linux" \
      -DSWIFT_HOST_VARIANT_SDK="LINUX" \
      -DSWIFT_HOST_VARIANT_ARCH="$ARCH" \
      -DSWIFT_HOST_TRIPLE="$TRIPLE" \
      -DSWIFT_PRIMARY_VARIANT="linux" \
      -DSWIFT_PRIMARY_VARIANT_SDK="LINUX" \
      -DSWIFT_PRIMARY_VARIANT_ARCH="$ARCH" \
      -DSWIFT_PRIMARY_VARIANT_TRIPLE="$TRIPLE" \
      -DCMAKE_C_FLAGS="-gcc-toolchain $CROSS_DIR -Wno-c++11-narrowing -target ${TRIPLE} $INCLUDE_FLAGS -fno-use-cxa-atexit -fPIC $BINARY_FLAGS -I$CROSS_DIR/$TRIPLE/include/c++/$GCC_VERSION -I$CROSS_DIR/$TRIPLE/include/c++/$GCC_VERSION/$TRIPLE" \
      -DCMAKE_CXX_FLAGS="-gcc-toolchain $CROSS_DIR -Wno-c++11-narrowing -target ${TRIPLE} $INCLUDE_FLAGS -fno-use-cxa-atexit -fPIC $BINARY_FLAGS -I$CROSS_DIR/$TRIPLE/include/c++/$GCC_VERSION -I$CROSS_DIR/$TRIPLE/include/c++/$GCC_VERSION/$TRIPLE" \
      -DCMAKE_EXE_LINKER_FLAGS="$LINK_FLAGS -gcc-toolchain $CROSS_DIR -fno-use-cxa-atexit -luuid -lpthread -fvisibility=protected -Bsymbolic" \
      -DCMAKE_SHARED_LINKER_FLAGS="$LINK_FLAGS -gcc-toolchain $CROSS_DIR -fno-use-cxa-atexit -luuid -lpthread -fvisibility=protected -Bsymbolic" \
      -DSWIFT_ENABLE_GOLD_LINKER=TRUE \
      -DSWIFT_ENABLE_LLD_LINKER=FALSE \
      -DSWIFT_NATIVE_SWIFT_TOOLS_PATH="/usr/local/var/swiftenv/shims" \
      -DLLVM_TABLEGEN_EXE=$LLVM_TABLEGEN \
      -DSWIFT_STDLIB_BUILD_TYPE="MinSizeRel" \
      -DSWIFT_SDK_LINUX_ARCH_${ARCH}_PATH="$LFS" \
      -DSWIFT_LINUX_${ARCH}_ICU_UC="$INSTALL_PREFIX/lib/libicuuc.so" \
      -DSWIFT_LINUX_${ARCH}_ICU_UC_INCLUDE="$INSTALL_PREFIX/include" \
      -DSWIFT_LINUX_${ARCH}_ICU_I18N="$INSTALL_PREFIX/lib/libicui18n.so" \
      -DSWIFT_LINUX_${ARCH}_ICU_I18N_INCLUDE="$INSTALL_PREFIX/include" \
      -DLIBXML2_INCLUDE_DIR="$CROSS_DIR/xml2/include/libxml2" \
      -DLIBXML2_LIBRARY="$CROSS_DIR/xml2/lib/libxml2.so" \
      -DLLVM_DIR="$LLVM_BUILD_DIR/lib/cmake/llvm" \
      -DClang_DIR="$LLVM_BUILD_DIR/lib/cmake/clang" \
      -DSWIFT_INCLUDE_TOOLS=FALSE \
      $SRC_DIR/swift
    cd $SRC_DIR
    cmake --build $SWIFT_BUILD_DIR -- -j${PARALLEL}
    touch $SWIFT_BUILD_DIR/lib/swift/linux/i686/StdlibUnicodeUnittest.swiftmodule
    touch $SWIFT_BUILD_DIR/lib/swift/linux/i686/StdlibUnicodeUnittest.swiftdoc
    touch $SWIFT_BUILD_DIR/lib/swift/linux/i686/StdlibUnicodeUnittest.swiftinterface
    touch $SWIFT_BUILD_DIR/lib/swift/linux/libswiftStdlibUnicodeUnittest.so
    touch $SWIFT_BUILD_DIR/lib/swift/linux/i686/StdlibCollectionUnittest.swiftmodule
    touch $SWIFT_BUILD_DIR/lib/swift/linux/i686/StdlibCollectionUnittest.swiftdoc
    touch $SWIFT_BUILD_DIR/lib/swift/linux/i686/StdlibCollectionUnittest.swiftinterface
    touch $SWIFT_BUILD_DIR/lib/swift/linux/libswiftStdlibCollectionUnittest.so
    cd $SWIFT_BUILD_DIR && ninja install
    touch $SWIFT_BUILD_DIR/.swift-build-cross
fi

cd $WD
