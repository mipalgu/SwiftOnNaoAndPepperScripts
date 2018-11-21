#!/usr/bin/env bash
set -e

source setup.sh
source setup-sysroot.sh

VERSION=swift-4.0.2-RELEASE
CMAKE_BUILD_TYPE=Release
CMARK_HOST_BUILD_DIR=$BUILD_DIR/cmark-host
CMARK_BUILD_DIR=$BUILD_DIR/cmark-$PLATFORM
LLVM_HOST_BUILD_DIR=$BUILD_DIR/llvm-host
LLVM_BUILD_DIR=$BUILD_DIR/llvm-$PLATFORM
SWIFT_HOST_BUILD_DIR=$BUILD_DIR/swift-host/ninja
SWIFT_BUILD_DIR=$BUILD_DIR/swift-$PLATFORM/ninja
LLBUILD_BUILD_DIR=$BUILD_DIR/llbuild-$PLATFORM
FOUNDATION_BUILD_DIR=$BUILD_DIR/foundation-$PLATFORM
DISPATCH_BUILD_DIR=$BUILD_DIR/libdispatch-$PLATFORM
PYTHONPATH="$SRC_DIR/swift/utils"
PYTHON="/usr/bin/python"
BUILD_CLANG=$LLVM_BUILD_DIR/bin/clang
BUILD_CLANGXX=$LLVM_BUILD_DIR/bin/clang++
HOST_CLANG=$LLVM_HOST_BUILD_DIR/bin/clang
HOST_CLANGXX=$LLVM_HOST_BUILD_DIR/bin/clang++

#rm -rf $SRC_DIR
#mkdir -p $SRC_DIR
cd $SRC_DIR
#tar -xzvf $WD/apple.tar.gz
cd llvm/tools
rm -f clang
rm -f compiler-rt
ln -s $SRC_DIR/clang .
ln -s $SRC_DIR/compiler-rt .

echo "Compiling cmark."
rm -rf $CMARK_HOST_BUILD_DIR
mkdir -p $CMARK_HOST_BUILD_DIR
cd $CMARK_HOST_BUILD_DIR && cmake -G "Ninja" $SRC_DIR/cmark
cd $SRC_DIR
cmake --build $CMARK_HOST_BUILD_DIR

echo "Compiling Host LLVM with clang and compiler-rt."
rm -rf $LLVM_HOST_BUILD_DIR
mkdir -p $LLVM_HOST_BUILD_DIR
cd $LLVM_HOST_BUILD_DIR
cmake -G "Ninja" \
  -DLLVM_ENABLE_ASSERTIONS=TRUE \
  -DCMAKE_C_FLAGS="-fno-stack-protector" \
  -DCMAKE_CXX_FLAGS="-fpermissive" \
  -DCMAKE_BUILD_TYPE=$CMAKE_BUILD_TYPE \
  -DLLVM_INCLUDE_DOCS=TRUE \
  -DLLVM_TOOL_COMPILER_RT_BUILD=TRUE \
  -DLLVM_BUILD_EXTERNAL_COMPILER_RT=TRUE \
  -DCLANG_DEFAULT_RTLIB="compiler-rt" \
  -DLLVM_LIT_ARGS=-sv \
  $SRC_DIR/llvm
cd $SRC_DIR
cmake --build $LLVM_HOST_BUILD_DIR

source cross.sh

echo "Compiling cmark."
rm -rf $CMARK_BUILD_DIR
mkdir -p $CMARK_BUILD_DIR
cd $CMARK_BUILD_DIR && cmake -G "Ninja" \
  -DCMAKE_CROSSCOMPILING=TRUE \
  -DCMAKE_SYSROOT="$LFS" \
  -DCMAKE_INSTALL_PREFIX="$INSTALL_PREFIX" \
  -DCMAKE_C_COMPILER="/usr/bin/clang" \
  -DCMAKE_CXX_COMPILER="/usr/bin/clang++" \
  -DCMAKE_C_FLAGS="-target ${TRIPLE}" \
  -DCMAKE_CXX_FLAGS="-target ${TRIPLE}" \
  $SRC_DIR/cmark
cd $SRC_DIR
cmake --build $CMARK_BUILD_DIR

echo "Compiling LLVM with clang and compiler-rt."
rm -rf $LLVM_BUILD_DIR
mkdir -p $LLVM_BUILD_DIR
cd $LLVM_BUILD_DIR
CC="$HOST_CLANG" CXX="$HOST_CLANGXX" cmake -G "Ninja" \
  -DCMAKE_CROSSCOMPILING=TRUE \
  -DCMAKE_SYSROOT="$LFS" \
  -DLLVM_TABLEGEN=$LLVM_HOST_BUILD_DIR/bin/llvm-tblgen \
  -DCLANG_TABLEGEN=$LLVM_HOST_BUILD_DIR/bin/clang-tblgen \
  -DLLVM_DEFAULT_TARGET_TRIPLE="${TRIPLE}" \
  -DLLVM_TARGET_ARCH="${ARCH}" \
  -DLLVM_TARGETS_TO_BUILD="X86" \
  -DCMAKE_INSTALL_PREFIX="$INSTALL_PREFIX" \
  -DLLVM_ENABLE_ASSERTIONS=TRUE \
  -DCMAKE_C_COMPILER="/usr/bin/clang" \
  -DCMAKE_CXX_COMPILER="/usr/bin/clang++" \
  -DCMAKE_ASM_COMPILER="/usr/bin/clang" \
  -DPYTHON_EXECUTABLE="${PYTHON}" \
  -DCMAKE_C_FLAGS="-fno-stack-protector -target ${TRIPLE}" \
  -DCMAKE_CXX_FLAGS=" -fpermissive -target ${TRIPLE}" \
  -DCMAKE_BUILD_TYPE=$CMAKE_BUILD_TYPE \
  -DLLVM_TOOL_SWIFT_BUILD=NO \
  -DLLVM_INCLUDE_DOCS=TRUE \
  -DLLVM_TOOL_COMPILER_RT_BUILD=TRUE \
  -DLLVM_BUILD_EXTERNAL_COMPILER_RT=TRUE \
  -DLLVM_LIT_ARGS=-sv \
  $SRC_DIR/llvm
cd $SRC_DIR
cmake --build $LLVM_BUILD_DIR

source cross-gcc-headers.sh

echo "Compiling swift."
rm -rf $SWIFT_BUILD_DIR
mkdir -p $SWIFT_BUILD_DIR
cd $SWIFT_BUILD_DIR
cmake -G "Ninja" \
  -DCMAKE_CROSSCOMPILING=TRUE \
  -DCMAKE_SYSROOT="$LFS" \
  -DCMAKE_INSTALL_PREFIX="$INSTALL_PREFIX" \
  -DCMAKE_C_COMPILER="/usr/bin/clang" \
  -DCMAKE_CXX_COMPILER="/usr/bin/clang++" \
  -DCMAKE_ASM_COMPILER="/usr/bin/clang" \
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
  -DSWIFT_INCLUDE_TESTS=FALSE \
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
  -DCMAKE_C_FLAGS="-nostdinc -Wno-c++11-narrowing -target ${TRIPLE} $INCLUDE_FLAGS -fno-use-cxa-atexit -fPIC" \
  -DCMAKE_CXX_FLAGS="-nostdinc -Wno-c++11-narrowing -target ${TRIPLE} $INCLUDE_FLAGS -fno-use-cxa-atexit -fPIC" \
  -DCMAKE_EXE_LINKER_FLAGS="$LINK_FLAGS -fno-use-cxa-atexit" \
  -DCMAKE_SHARED_LINKER_FLAGS="$LINK_FLAGS -fno-use-cxa-atexit" \
  -DSWIFT_NATIVE_SWIFT_TOOLS_PATH="/usr/local/var/swiftenv/shims" \
  -DLLVM_TABLEGEN_EXE=$LLVM_HOST_BUILD_DIR/bin/llvm-tblgen \
  -DSWIFT_STDLIB_BUILD_TYPE="MinSizeRel" \
  -DSWIFT_SDK_LINUX_ARCH_${ARCH}_PATH="$LFS" \
  $SRC_DIR/swift
cd $SRC_DIR
cmake --build $SWIFT_BUILD_DIR
touch $SWIFT_BUILD_DIR/lib/swift/linux/i686/StdlibUnicodeUnittest.swiftmodule
touch $SWIFT_BUILD_DIR/lib/swift/linux/i686/StdlibUnicodeUnittest.swiftdoc
touch $SWIFT_BUILD_DIR/lib/swift/linux/i686/StdlibUnicodeUnittest.swiftinterface
touch $SWIFT_BUILD_DIR/lib/swift/linux/libswiftStdlibUnicodeUnittest.so
touch $SWIFT_BUILD_DIR/lib/swift/linux/i686/StdlibCollectionUnittest.swiftmodule
touch $SWIFT_BUILD_DIR/lib/swift/linux/i686/StdlibCollectionUnittest.swiftdoc
touch $SWIFT_BUILD_DIR/lib/swift/linux/i686/StdlibCollectionUnittest.swiftinterface
touch $SWIFT_BUILD_DIR/lib/swift/linux/libswiftStdlibCollectionUnittest.so

cd $WD
echo "Installing..."
mkdir -p $INSTALL_PREFIX
cd $CMARK_BUILD_DIR && ninja install
cd $LLVM_BUILD_DIR && ninja install
cd $SWIFT_BUILD_DIR && ninja install

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
#  -DLLVM_TABLEGEN_EXE=$LLVM_HOST_BUILD_DIR/bin/llvm-tblgen \
#  -DSWIFT_STDLIB_BUILD_TYPE="MinSizeRel" \
#  -DSWIFT_SDK_LINUX_ARCH_${ARCH}_PATH="$LFS" \
#  $SRC_DIR/llbuild
#cd $SRC_DIR
#cmake --build $LLBUILD_BUILD_DIR
#cd $LLBUILD_BUILD_DIR && ninja install

echo "Compiling libdispatch"
rm -rf $DISPATCH_BUILD_DIR
mkdir -p $DISPATCH_BUILD_DIR
cd $DISPATCH_BUILD_DIR
cmake -G "Ninja" \
  -DCMAKE_CROSSCOMPILING=TRUE \
  -DCMAKE_SYSROOT="$LFS" \
  -DCMAKE_INSTALL_PREFIX="$INSTALL_PREFIX" \
  -DCMAKE_C_COMPILER="/usr/bin/clang" \
  -DCMAKE_CXX_COMPILER="/usr/bin/clang++" \
  -DCMAKE_ASM_COMPILER="/usr/bin/clang" \
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
  -DSWIFT_INCLUDE_TESTS=FALSE \
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
  -DCMAKE_C_FLAGS="-nostdinc -Wno-c++11-narrowing -Wno-conversion -Wno-sign-conversion -Wno-builtin-requires-header -ferror-limit=100 -target ${TRIPLE} $INCLUDE_FLAGS" \
  -DCMAKE_CXX_FLAGS="-nostdinc -Wno-c++11-narrowing -Wno-conversion -Wno-sign-conversion -Wno-builtin-requires-header -ferror-limit=100 -target ${TRIPLE} $INCLUDE_FLAGS" \
  -DCMAKE_EXE_LINKER_FLAGS="$LINK_FLAGS -latomic" \
  -DCMAKE_SHARED_LINKER_FLAGS="$LINK_FLAGS -latomic" \
  -DSWIFT_NATIVE_SWIFT_TOOLS_PATH="/usr/local/var/swiftenv/shims" \
  -DLLVM_TABLEGEN_EXE=$LLVM_HOST_BUILD_DIR/bin/llvm-tblgen \
  -DSWIFT_STDLIB_BUILD_TYPE="MinSizeRel" \
  -DSWIFT_SDK_LINUX_ARCH_${ARCH}_PATH="$LFS" \
  $SRC_DIR/swift-corelibs-libdispatch
cp -p $DISPATCH_BUILD_DIR/build.ninja $DISPATCH_BUILD_DIR/build.ninja.orig
sed < $DISPATCH_BUILD_DIR/build.ninja.orig > $DISPATCH_BUILD_DIR/build.ninja					\
    -e "s|-Werror |-Wno-implicit-function-declaration |g"		\
    -e "s|-Wdeprecated-dynamic-exception-spec ||g"			\
    -e "s|-Wconversion |-Wno-macro-redefined |g"			\
    -e "s|-Wimplicit-function-declaration ||g"			\
    -e "s|-Wbuiltin-requires-header ||g"				\
    -e "s|-Wmacro-redefined ||g"					\
    -e "s|-Wsign-conversion ||g"
cd $SRC_DIR
cmake --build $DISPATCH_BUILD_DIR
cd $DISPATCH_BUILD_DIR && ninja install

echo "Compiling Foundation"
rm -rf $FOUNDATION_BUILD_DIR
mkdir -p $FOUNDATION_BUILD_DIR
cd $FOUNDATION_BUILD_DIR
cmake -G "Ninja" \
  -DCMAKE_CROSSCOMPILING=TRUE \
  -DCMAKE_SYSROOT="$LFS" \
  -DCMAKE_INSTALL_PREFIX="$INSTALL_PREFIX" \
  -DCMAKE_C_COMPILER="/usr/bin/clang" \
  -DCMAKE_CXX_COMPILER="/usr/bin/clang++" \
  -DCMAKE_ASM_COMPILER="/usr/bin/clang" \
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
  -DSWIFT_INCLUDE_TESTS=FALSE \
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
  -DCMAKE_C_FLAGS="-nostdinc -Wno-c++11-narrowing -target ${TRIPLE} $INCLUDE_FLAGS" \
  -DCMAKE_CXX_FLAGS="-nostdinc -Wno-c++11-narrowing -target ${TRIPLE} $INCLUDE_FLAGS" \
  -DCMAKE_EXE_LINKER_FLAGS="$LINK_FLAGS -latomic" \
  -DCMAKE_SHARED_LINKER_FLAGS="$LINK_FLAGS -latomic" \
  -DSWIFT_NATIVE_SWIFT_TOOLS_PATH="/usr/local/var/swiftenv/shims" \
  -DLLVM_TABLEGEN_EXE=$LLVM_HOST_BUILD_DIR/bin/llvm-tblgen \
  -DSWIFT_STDLIB_BUILD_TYPE="MinSizeRel" \
  -DSWIFT_SDK_LINUX_ARCH_${ARCH}_PATH="$LFS" \
  $SRC_DIR/swift-corelibs-foundation
cd $SRC_DIR
cmake --build $FOUNDATION_BUILD_DIR
cd $FOUNDATION_BUILD_DIR && ninja install
