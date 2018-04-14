#!/usr/bin/env bash
set -e

LFS=/tools
VERSION=swift-4.0.2-RELEASE
CMAKE_BUILD_TYPE=Release
WD=`pwd`
SRC_DIR=$WD/src
INSTALL_PREFIX=$LFS/usr/local
ARCH=i686
OS=linux
TRIPLE=$ARCH-pc-$OS-gnu
PLATFORM=$ARCH-$OS
BUILD_DIR=$SRC_DIR/build
CMARK_BUILD_DIR=$BUILD_DIR/cmark-$PLATFORM
LLVM_BUILD_DIR=$BUILD_DIR/llvm-$PLATFORM
SWIFT_BUILD_DIR=$BUILD_DIR/swift-$PLATFORM/ninja
PYTHONPATH="$SRC_DIR/swift/utils"
GCC=$LFS/bin/gcc
GXX=$LFS/bin/g++
CLANG=$LLVM_BUILD_DIR/bin/clang
CLANGXX=$LLVM_BUILD_DIR/bin/clang++

rm -rf $SRC_DIR
mkdir -p $SRC_DIR
cd $SRC_DIR
tar -xzvf $WD/apple.tar.gz
cd llvm/tools
rm clang
rm compiler-rt
ln -s $SRC_DIR/clang .
ln -s $SRC_DIR/compiler-rt .

rm -rf $BUILD_DIR

echo "Compiling cmark."
mkdir -p $CMARK_BUILD_DIR
cd $CMARK_BUILD_DIR && cmake -G "Ninja" \
  -DCMAKE_INSTALL_PREFIX="$INSTALL_PREFIX" \
  -DCMAKE_C_COMPILER="$GCC" \
  -DCMAKE_CXX_COMPILER="$GXX" \
  $SRC_DIR/cmark
cd $SRC_DIR
cmake --build $CMARK_BUILD_DIR

echo "Compiling LLVM with clang and compiler-rt."
mkdir -p $LLVM_BUILD_DIR
cd $LLVM_BUILD_DIR
cmake -G "Ninja" \
  -DCMAKE_INSTALL_PREFIX="$INSTALL_PREFIX" \
  -DLLVM_ENABLE_ASSERTIONS=TRUE \
  -DCMAKE_C_COMPILER="$GCC" \
  -DCMAKE_CXX_COMPILER="$GXX" \
  -DCMAKE_ASM_COMPILER="$GCC" \
  -DCMAKE_C_FLAGS="-fno-stack-protector" \
  -DCMAKE_CXX_FLAGS="-fpermissive" \
  -DCMAKE_BUILD_TYPE=$CMAKE_BUILD_TYPE \
  -DLLVM_TOOL_SWIFT_BUILD=NO \
  -DLLVM_INCLUDE_DOCS=TRUE \
  -DLLVM_TOOL_COMPILER_RT_BUILD=TRUE \
  -DLLVM_BUILD_EXTERNAL_COMPILER_RT=TRUE \
  -DLLVM_LIT_ARGS=-sv \
  $SRC_DIR/llvm
cd $SRC_DIR
cmake --build $LLVM_BUILD_DIR

echo "Patching swift files so that they work with 32 bit."
sed -i 's/#if defined(__linux__) \&\& defined (__arm__)/#if defined(__linux__) \&\& (defined (__arm__) \|\| defined(__i386__))/' $SRC_DIR/swift/stdlib/public/SwiftShims/LibcShims.h
#sed -i 's/return RetTy{ llvm::Type::getX86_FP80Ty(ctx), Size(16), Alignment(16) };/return RetTy{ llvm::Type::getX86_FP80Ty(ctx), Size(12), Alignment(16) };/' $SRC_DIR/swift/lib/IRGen/GenType.cpp

echo "Compiling swift."
mkdir -p $SWIFT_BUILD_DIR
cd $SWIFT_BUILD_DIR
cmake -G "Ninja" \
  -DCMAKE_INSTALL_PREFIX="$INSTALL_PREFIX" \
  -DCMAKE_C_COMPILER="$CLANG" \
  -DCMAKE_CXX_COMPILER="$CLANGXX" \
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
  -DSWIFT_BUILD_PERF_TESTSUITE=TRUE \
  -DSWIFT_BUILD_DYNAMIC_SDK_OVERLAY=TRUE \
  -DSWIFT_BUILD_RUNTIME_WITH_HOST_COMPILER=FALSE \
  -DSWIFT_STDLIB_BUILD_TYPE=$CMAKE_BUILD_TYPE \
  -DSWIFT_SOURCE_DIR="$SRC_DIR/swift" \
  -DSWIFT_HOST_VARIANT="linux" \
  -DSWIFT_HOST_VARIANT_SDK="LINUX" \
  -DSWIFT_HOST_VARIANT_ARCH="$ARCH" \
  -DSWIFT_HOST_TRIPLE="$TRIPLE" \
  $SRC_DIR/swift
cd $SRC_DIR
cmake --build $SWIFT_BUILD_DIR

cd $WD
echo "Installing..."
mkdir -p $INSTALL_PREFIX
cd $CMARK_BUILD_DIR && ninja install
cd $LLVM_BUILD_DIR && ninja install
cd $SWIFT_BUILD_DIR && ninja install

echo "Compiling LLVM with clang and compiler-rt."
mkdir -p $LLVM_BUILD_DIR
cd $LLVM_BUILD_DIR
cmake -G "Ninja" \
  -DCMAKE_INSTALL_PREFIX="$INSTALL_PREFIX" \
  -DLLVM_ENABLE_ASSERTIONS=TRUE \
  -DCMAKE_C_COMPILER="$GCC" \
  -DCMAKE_CXX_COMPILER="$GXX" \
  -DCMAKE_ASM_COMPILER="$GCC" \
  -DCMAKE_C_FLAGS="-fno-stack-protector" \
  -DCMAKE_CXX_FLAGS="-fpermissive" \
  -DCMAKE_BUILD_TYPE=$CMAKE_BUILD_TYPE \
  -DLLVM_TOOL_SWIFT_BUILD=NO \
  -DLLVM_INCLUDE_DOCS=TRUE \
  -DLLVM_TOOL_COMPILER_RT_BUILD=TRUE \
  -DLLVM_BUILD_EXTERNAL_COMPILER_RT=TRUE \
  -DCLANG_DEFAULT_RTLIB="compiler-rt" \
  -DLLVM_LIT_ARGS=-sv \
  $SRC_DIR/llvm
cd $SRC_DIR
cmake --build $LLVM_BUILD_DIR
cd $LLVM_BUILD_DIR && ninja install
cd $WD
