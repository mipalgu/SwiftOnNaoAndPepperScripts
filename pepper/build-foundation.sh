#!/usr/bin/env bash
set -e

source build-config.sh
source cross.sh
source compile-swiftenv-tc.sh

swift_include_flags=`echo "$INCLUDE_FLAGS" | sed 's/ /;/g'`

#COMMAND="/usr/local/var/swiftenv/versions/5.0/usr/bin/clang -o hello main.o ${LINK_FLAGS} -L$INSTALL_PREFIX/lib/swift/linux -lswiftCore -lswiftSwiftOnoneSupport -target $TRIPLE"
#echo "$COMMAND"
#$COMMAND
#rm -r $WD/main
#mkdir -p $WD/main
#cd $WD/main
#echo "print(\"Hello World\")" > main.swift
#$HOST_SWIFT package init --type executable
#SWIFT_INCLUDE_FLAGS=`echo "$INCLUDE_FLAGS" | sed 's/^\|\s/ -Xcc /g'`
#SWIFT_LD_FLAGS=`echo "$LINK_FLAGS" | sed 's/^\|\s+/ -Xlinker /g'`
#COMMAND="swiftc -o main.o -c main.swift -target $TRIPLE -sdk $INSTALL_PREFIX $SWIFT_LD_FLAGS $SWIFT_INCLUDE_FLAGS"
#echo "$COMMAND"
#$COMMAND

#ln -s $SWIFT_BUILD_DIR/lib/swift/linux/i686 $SWIFT_HOST_BUILD_DIR/lib/swift/linux/

#echo "Compiling llbuild."
#rm -rf $LLBUILD_BUILD_DIR
#mkdir -p $LLBUILD_BUILD_DIR
#cd $LLBUILD_BUILD_DIR
#cmake -G "Ninja" \
#  -DCMAKE_CROSSCOMPILING=TRUE \
#  -DCMAKE_SYSROOT="$LFS" \
#  -DCMAKE_INSTALL_PREFIX="$INSTALL_PREFIX" \
#  -DCMAKE_C_COMPILER="/usr/bin/clang" \
#  -DCMAKE_CXX_COMPILER="/usr/bin/clang++" \
#  -DCMAKE_ASM_COMPILER="/usr/bin/clang" \
#  -DPYTHON_EXECUTABLE="${PYTHON}" \
#  -DCMAKE_BUILD_TYPE=$CMAKE_BUILD_TYPE \
#  -DSWIFT_PATH_TO_CMARK_SOURCE="$SRC_DIR/cmark" \
#  -DSWIFT_PATH_TO_CMARK_BUILD="$CMARK_BUILD_DIR" \
#  -DSWIFT_CMARK_LIBRARY_DIR="$CMARK_BUILD_DIR/src" \
#  -DSWIFT_PATH_TO_LLVM_SOURCE="$SRC_DIR/llvm" \
#  -DSWIFT_PATH_TO_LLVM_BUILD="$LLVM_BUILD_DIR" \
#  -DSWIFT_PATH_TO_CLANG_SOURCE="$SRC_DIR/clang" \
#  -DSWIFT_PATH_TO_CLANG_BUILD="$LLVM_BUILD_DIR" \
#  -DSWIFT_INCLUDE_DOCS=FALSE \
#  -DSWIFT_INCLUDE_TESTS=FALSE \
#  -DSWIFT_BUILD_PERF_TESTSUITE=FALSE \
#  -DSWIFT_BUILD_DYNAMIC_SDK_OVERLAY=TRUE \
#  -DSWIFT_BUILD_RUNTIME_WITH_HOST_COMPILER=TRUE \
#  -DSWIFT_STDLIB_BUILD_TYPE=$CMAKE_BUILD_TYPE \
#  -DSWIFT_SOURCE_DIR="$SRC_DIR/swift" \
#  -DSWIFT_HOST_VARIANT="linux" \
#  -DSWIFT_HOST_VARIANT_SDK="LINUX" \
#  -DSWIFT_HOST_VARIANT_ARCH="$ARCH" \
#  -DSWIFT_HOST_TRIPLE="$TRIPLE" \
#  -DSWIFT_PRIMARY_VARIANT="linux" \
#  -DSWIFT_PRIMARY_VARIANT_SDK="LINUX" \
#  -DSWIFT_PRIMARY_VARIANT_ARCH="$ARCH" \
#  -DSWIFT_PRIMARY_VARIANT_TRIPLE="$TRIPLE" \
#  -DCMAKE_C_FLAGS="-nostdinc -Wno-c++11-narrowing -target ${TRIPLE} $INCLUDE_FLAGS" \
#  -DCMAKE_CXX_FLAGS="-nostdinc -Wno-c++11-narrowing -target ${TRIPLE} $INCLUDE_FLAGS" \
#  -DCMAKE_EXE_LINKER_FLAGS="$LINK_FLAGS -latomic" \
#  -DCMAKE_SHARED_LINKER_FLAGS="$LINK_FLAGS -latomic" \
#  -DSWIFT_NATIVE_SWIFT_TOOLS_PATH="/usr/local/var/swiftenv/shims" \
#  -DLLVM_TABLEGEN_EXE=$LLVM_TABLEGEN \
#  -DSWIFT_STDLIB_BUILD_TYPE="MinSizeRel" \
#  -DSWIFT_SDK_LINUX_ARCH_${ARCH}_PATH="$LFS" \
#  $SRC_DIR/llbuild
#cd $SRC_DIR
#cmake --build $LLBUILD_BUILD_DIR
#cd $LLBUILD_BUILD_DIR && ninja install

#echo "Compiling libdispatch"
#rm -rf $DISPATCH_BUILD_DIR
#mkdir -p $DISPATCH_BUILD_DIR
#cd $DISPATCH_BUILD_DIR
#cmake -G "Ninja" \
#  -DCMAKE_CROSSCOMPILING=TRUE \
#  -DCMAKE_SYSROOT="$LFS" \
#  -DCMAKE_INSTALL_PREFIX="$INSTALL_PREFIX" \
#  -DCMAKE_C_COMPILER="/usr/bin/clang" \
#  -DCMAKE_CXX_COMPILER="/usr/bin/clang++" \
#  -DCMAKE_ASM_COMPILER="/usr/bin/clang" \
#  -DPYTHON_EXECUTABLE="${PYTHON}" \
#  -DCMAKE_BUILD_TYPE=$CMAKE_BUILD_TYPE \
#  -DSWIFT_PATH_TO_CMARK_SOURCE="$SRC_DIR/cmark" \
#  -DSWIFT_PATH_TO_CMARK_BUILD="$CMARK_BUILD_DIR" \
#  -DSWIFT_CMARK_LIBRARY_DIR="$CMARK_BUILD_DIR/src" \
#  -DSWIFT_PATH_TO_LLVM_SOURCE="$SRC_DIR/llvm" \
#  -DSWIFT_PATH_TO_LLVM_BUILD="$LLVM_BUILD_DIR" \
#  -DSWIFT_PATH_TO_CLANG_SOURCE="$SRC_DIR/clang" \
#  -DSWIFT_PATH_TO_CLANG_BUILD="$LLVM_BUILD_DIR" \
#  -DSWIFT_INCLUDE_DOCS=FALSE \
#  -DSWIFT_INCLUDE_TESTS=FALSE \
#  -DSWIFT_BUILD_PERF_TESTSUITE=FALSE \
#  -DSWIFT_BUILD_DYNAMIC_SDK_OVERLAY=TRUE \
#  -DSWIFT_BUILD_RUNTIME_WITH_HOST_COMPILER=TRUE \
#  -DSWIFT_STDLIB_BUILD_TYPE=$CMAKE_BUILD_TYPE \
#  -DSWIFT_SOURCE_DIR="$SRC_DIR/swift" \
#  -DSWIFT_HOST_VARIANT="linux" \
#  -DSWIFT_HOST_VARIANT_SDK="LINUX" \
#  -DSWIFT_HOST_VARIANT_ARCH="$ARCH" \
#  -DSWIFT_HOST_TRIPLE="$TRIPLE" \
#  -DSWIFT_PRIMARY_VARIANT="linux" \
#  -DSWIFT_PRIMARY_VARIANT_SDK="LINUX" \
#  -DSWIFT_PRIMARY_VARIANT_ARCH="$ARCH" \
#  -DSWIFT_PRIMARY_VARIANT_TRIPLE="$TRIPLE" \
#  -DCMAKE_C_FLAGS="-nostdinc -Wno-c++11-narrowing -Wno-conversion -Wno-sign-conversion -Wno-builtin-requires-header -ferror-limit=100 -target ${TRIPLE} $INCLUDE_FLAGS" \
#  -DCMAKE_CXX_FLAGS="-nostdinc -Wno-c++11-narrowing -Wno-conversion -Wno-sign-conversion -Wno-builtin-requires-header -ferror-limit=100 -target ${TRIPLE} $INCLUDE_FLAGS" \
#  -DCMAKE_EXE_LINKER_FLAGS="$LINK_FLAGS -latomic" \
#  -DCMAKE_SHARED_LINKER_FLAGS="$LINK_FLAGS -latomic" \
#  -DSWIFT_NATIVE_SWIFT_TOOLS_PATH="/usr/local/var/swiftenv/shims" \
#  -DLLVM_TABLEGEN_EXE=$LLVM_TABLEGEN \
#  -DSWIFT_STDLIB_BUILD_TYPE="MinSizeRel" \
#  -DSWIFT_SDK_LINUX_ARCH_${ARCH}_PATH="$LFS" \
#  $SRC_DIR/swift-corelibs-libdispatch
#cp -p $DISPATCH_BUILD_DIR/build.ninja $DISPATCH_BUILD_DIR/build.ninja.orig
#sed < $DISPATCH_BUILD_DIR/build.ninja.orig > $DISPATCH_BUILD_DIR/build.ninja					\
#    -e "s|-Werror |-Wno-implicit-function-declaration |g"		\
#    -e "s|-Wdeprecated-dynamic-exception-spec ||g"			\
#    -e "s|-Wconversion |-Wno-macro-redefined |g"			\
#    -e "s|-Wimplicit-function-declaration ||g"			\
#    -e "s|-Wbuiltin-requires-header ||g"				\
#    -e "s|-Wmacro-redefined ||g"					\
#    -e "s|-Wsign-conversion ||g"
#cd $SRC_DIR
#cmake --build $DISPATCH_BUILD_DIR
#cd $DISPATCH_BUILD_DIR && ninja install

#echo "Compiling Foundation"
#rm -rf $FOUNDATION_BUILD_DIR
#mkdir -p $FOUNDATION_BUILD_DIR
#cd $FOUNDATION_BUILD_DIR
#cmake -G "Ninja" \
#  -DCMAKE_CROSSCOMPILING=TRUE \
#  -DCMAKE_SYSROOT="$LFS" \
#  -DCMAKE_INSTALL_PREFIX="$INSTALL_PREFIX" \
#  -DCMAKE_C_COMPILER="/usr/bin/clang" \
#  -DCMAKE_CXX_COMPILER="/usr/bin/clang++" \
#  -DCMAKE_ASM_COMPILER="/usr/bin/clang" \
#  -DPYTHON_EXECUTABLE="${PYTHON}" \
#  -DCMAKE_BUILD_TYPE=$CMAKE_BUILD_TYPE \
#  -DSWIFT_PATH_TO_CMARK_SOURCE="$SRC_DIR/cmark" \
#  -DSWIFT_PATH_TO_CMARK_BUILD="$CMARK_BUILD_DIR" \
#  -DSWIFT_CMARK_LIBRARY_DIR="$CMARK_BUILD_DIR/src" \
#  -DSWIFT_PATH_TO_LLVM_SOURCE="$SRC_DIR/llvm" \
#  -DSWIFT_PATH_TO_LLVM_BUILD="$LLVM_BUILD_DIR" \
#  -DSWIFT_PATH_TO_CLANG_SOURCE="$SRC_DIR/clang" \
#  -DSWIFT_PATH_TO_CLANG_BUILD="$LLVM_BUILD_DIR" \
#  -DSWIFT_INCLUDE_DOCS=FALSE \
#  -DSWIFT_INCLUDE_TESTS=FALSE \
#  -DSWIFT_BUILD_PERF_TESTSUITE=FALSE \
#  -DSWIFT_BUILD_DYNAMIC_SDK_OVERLAY=TRUE \
#  -DSWIFT_BUILD_RUNTIME_WITH_HOST_COMPILER=TRUE \
#  -DSWIFT_STDLIB_BUILD_TYPE=$CMAKE_BUILD_TYPE \
#  -DSWIFT_SOURCE_DIR="$SRC_DIR/swift" \
#  -DSWIFT_HOST_VARIANT="linux" \
#  -DSWIFT_HOST_VARIANT_SDK="LINUX" \
#  -DSWIFT_HOST_VARIANT_ARCH="$ARCH" \
#  -DSWIFT_HOST_TRIPLE="$TRIPLE" \
#  -DSWIFT_PRIMARY_VARIANT="linux" \
#  -DSWIFT_PRIMARY_VARIANT_SDK="LINUX" \
#  -DSWIFT_PRIMARY_VARIANT_ARCH="$ARCH" \
#  -DSWIFT_PRIMARY_VARIANT_TRIPLE="$TRIPLE" \
#  -DCMAKE_C_FLAGS="-nostdinc -Wno-c++11-narrowing -target ${TRIPLE} $INCLUDE_FLAGS" \
#  -DCMAKE_CXX_FLAGS="-nostdinc -Wno-c++11-narrowing -target ${TRIPLE} $INCLUDE_FLAGS" \
#  -DCMAKE_EXE_LINKER_FLAGS="$LINK_FLAGS -latomic" \
#  -DCMAKE_SHARED_LINKER_FLAGS="$LINK_FLAGS -latomic" \
#  -DSWIFT_NATIVE_SWIFT_TOOLS_PATH="/usr/local/var/swiftenv/shims" \
#  -DLLVM_TABLEGEN_EXE=$LLVM_TABLEGEN \
#  -DSWIFT_STDLIB_BUILD_TYPE="MinSizeRel" \
#  -DSWIFT_SDK_LINUX_ARCH_${ARCH}_PATH="$LFS" \
#  $SRC_DIR/swift-corelibs-foundation
#cd $SRC_DIR
#cmake --build $FOUNDATION_BUILD_DIR
#cd $FOUNDATION_BUILD_DIR && ninja install

cd $WD
