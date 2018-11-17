#!/usr/bin/env bash
set -e

source setup.sh

VERSION=swift-4.0.2-RELEASE
CMAKE_BUILD_TYPE=Release
SRC_DIR=$WD/src
INSTALL_PREFIX=$LFS/home/nao/swift-tc
ARCH=i686
VENDOR=aldebaran
OS=linux
TRIPLE=$ARCH-$VENDOR-$OS-gnu
PLATFORM=$ARCH-$OS
BUILD_DIR=$SRC_DIR/build
CMARK_HOST_BUILD_DIR=$BUILD_DIR/cmark-host
CMARK_BUILD_DIR=$BUILD_DIR/cmark-$PLATFORM
LLVM_HOST_BUILD_DIR=$BUILD_DIR/llvm-host
LLVM_BUILD_DIR=$BUILD_DIR/llvm-$PLATFORM
SWIFT_HOST_BUILD_DIR=$BUILD_DIR/swift-host/ninja
SWIFT_BUILD_DIR=$BUILD_DIR/swift-$PLATFORM/ninja
PYTHONPATH="$SRC_DIR/swift/utils"
PYTHON="/usr/bin/python"
BUILD_CLANG=$LLVM_BUILD_DIR/bin/clang
BUILD_CLANGXX=$LLVM_BUILD_DIR/bin/clang++
HOST_CLANG=$LLVM_HOST_BUILD_DIR/bin/clang
HOST_CLANGXX=$LLVM_HOST_BUILD_DIR/bin/clang++
SYSROOT_PATH="$INSTALL_PREFIX/bin:$LFS/usr/local/bin:$LFS/usr/bin:$LFS/bin"
SYSROOT_LIBRARY_PATH="$INSTALL_PREFIX/lib:$LFS/usr/local/lib:$LFS/usr/lib:$LFS/usr/lib32:$LFS/lib:$LFS/lib32:$LFS:$LFS/lib/gcc/${TRIPLE}/4.9.2"
SYSROOT_LD_LIBRARY_PATH="$LIBRARY_PATH"
SYSROOT_CPATH="$LFS/lib/gcc/i686-aldebaran-linux-gnu/4.9.2/include-fixed:$INSTALL_PREFIX/include:$LFS/usr/local/include:$LFS/usr/include:$LFS/include:$LFS/include/${TRIPLE}:$LFS/usr/lib"

#rm -rf $SRC_DIR
#mkdir -p $SRC_DIR
cd $SRC_DIR
#tar -xzvf $WD/apple.tar.gz
cd llvm/tools
rm -f clang
rm -f compiler-rt
ln -s $SRC_DIR/clang .
ln -s $SRC_DIR/compiler-rt .

#rm -rf $BUILD_DIR

#echo "Compiling cmark."
#mkdir -p $CMARK_HOST_BUILD_DIR
#cd $CMARK_HOST_BUILD_DIR && cmake -G "Ninja" $SRC_DIR/cmark
#cd $SRC_DIR
#cmake --build $CMARK_HOST_BUILD_DIR

#echo "Compiling Host LLVM with clang and compiler-rt."
#mkdir -p $LLVM_HOST_BUILD_DIR
#cd $LLVM_HOST_BUILD_DIR
#cmake -G "Ninja" \
#  -DLLVM_ENABLE_ASSERTIONS=TRUE \
#  -DCMAKE_C_FLAGS="-fno-stack-protector" \
#  -DCMAKE_CXX_FLAGS="-fpermissive" \
#  -DCMAKE_BUILD_TYPE=$CMAKE_BUILD_TYPE \
#  -DLLVM_TOOL_SWIFT_BUILD=NO \
#  -DLLVM_INCLUDE_DOCS=TRUE \
#  -DLLVM_TOOL_COMPILER_RT_BUILD=TRUE \
#  -DLLVM_BUILD_EXTERNAL_COMPILER_RT=TRUE \
#  -DCLANG_DEFAULT_RTLIB="compiler-rt" \
#  -DLLVM_LIT_ARGS=-sv \
#  $SRC_DIR/llvm
#cd $SRC_DIR
#cmake --build $LLVM_HOST_BUILD_DIR

#echo "Compiling Host swift."
#rm -rf $SWIFT_HOST_BUILD_DIR
#mkdir -p $SWIFT_HOST_BUILD_DIR
#cd $SWIFT_HOST_BUILD_DIR
#cmake -G "Ninja" \
#  -DCMAKE_C_COMPILER="$HOST_CLANG" \
#  -DCMAKE_CXX_COMPILER="$HOST_CLANGXX" \
#  -DCMAKE_ASM_COMPILER="$HOST_CLANG" \
#  -DCMAKE_BUILD_TYPE=$CMAKE_BUILD_TYPE \
#  -DSWIFT_PATH_TO_CMARK_SOURCE="$SRC_DIR/cmark" \
#  -DSWIFT_PATH_TO_CMARK_BUILD="$CMARK_HOST_BUILD_DIR" \
#  -DSWIFT_CMARK_LIBRARY_DIR="$CMARK_HOST_BUILD_DIR/src" \
#  -DSWIFT_PATH_TO_LLVM_SOURCE="$SRC_DIR/llvm" \
#  -DSWIFT_PATH_TO_LLVM_BUILD="$LLVM_HOST_BUILD_DIR" \
#  -DSWIFT_PATH_TO_CLANG_SOURCE="$SRC_DIR/clang" \
#  -DSWIFT_PATH_TO_CLANG_BUILD="$LLVM_HOST_BUILD_DIR" \
#  -DSWIFT_INCLUDE_DOCS=FALSE \
#  -DSWIFT_INCLUDE_TESTS=FALSE \
#  -DSWIFT_BUILD_PERF_TESTSUITE=FALSE \
#  -DSWIFT_BUILD_DYNAMIC_SDK_OVERLAY=TRUE \
#  -DSWIFT_BUILD_RUNTIME_WITH_HOST_COMPILER=TRUE \
#  -DSWIFT_STDLIB_BUILD_TYPE=$CMAKE_BUILD_TYPE \
#  -DSWIFT_SOURCE_DIR="$SRC_DIR/swift" \
#  -DCMAKE_C_FLAGS="-Wno-c++11-narrowing" \
#  -DCMAKE_CXX_FLAGS="-Wno-c++11-narrowing" \
#  -DSWIFT_STDLIB_BUILD_TYPE="MinSizeRel" \
#  -DCMAKE_EXE_LINKER_FLAGS="-lgcc_eh" \
#  -DCMAKE_SHARED_LINKER_FLAGS="-lgcc_eh" \
#  $SRC_DIR/swift
#cd $SRC_DIR
#cmake --build $SWIFT_HOST_BUILD_DIR

export PATH="$LFS/usr/local/bin:$LFS/usr/bin:/usr/local/bin:/usr/bin:/bin"
export LIBRARY_PATH="$SYSROOT_LIBRARY_PATH"
export LD_LIBRARY_PATH="$LIBRARY_PATH"
export CPATH=$SYSROOT_CPATH
export LANG=/usr/lib/locale/en_US
BINARY_FLAGS=`echo "$SYSROOT_PATH:$SYSROOT_LIBRARY_PATH:$SYSROOT_CPATH" | sed 's/^\|:/ -B/g'`
INCLUDE_FLAGS=`echo $SYSROOT_CPATH | sed 's/^\|:/ -I/g'`
LINK_FLAGS=`echo $SYSROOT_LIBRARY_PATH | sed 's/^\|:/ -L/g'`

#echo "Compiling cmark."
#mkdir -p $CMARK_BUILD_DIR
#cd $CMARK_BUILD_DIR && cmake -G "Ninja" \
#  -DCMAKE_CROSSCOMPILING=TRUE \
#  -DCMAKE_SYSROOT="$LFS" \
#  -DCMAKE_INSTALL_PREFIX="$INSTALL_PREFIX" \
#  -DCMAKE_C_COMPILER="/usr/bin/clang" \
#  -DCMAKE_CXX_COMPILER="/usr/bin/clang++" \
#  -DCMAKE_C_FLAGS="-target ${TRIPLE}" \
#  -DCMAKE_CXX_FLAGS="-target ${TRIPLE}" \
#  $SRC_DIR/cmark
#cd $SRC_DIR
#cmake --build $CMARK_BUILD_DIR

#echo "Compiling LLVM with clang and compiler-rt."
#rm -rf $LLVM_BUILD_DIR
#mkdir -p $LLVM_BUILD_DIR
#cd $LLVM_BUILD_DIR
#CC="$HOST_CLANG" CXX="$HOST_CLANGXX" cmake -G "Ninja" \
#  -DCMAKE_CROSSCOMPILING=TRUE \
#  -DCMAKE_SYSROOT="$LFS" \
#  -DLLVM_TABLEGEN=$LLVM_HOST_BUILD_DIR/bin/llvm-tblgen \
#  -DCLANG_TABLEGEN=$LLVM_HOST_BUILD_DIR/bin/clang-tblgen \
#  -DLLVM_DEFAULT_TARGET_TRIPLE="${TRIPLE}" \
#  -DLLVM_TARGET_ARCH="${ARCH}" \
#  -DLLVM_TARGETS_TO_BUILD="X86" \
#  -DCMAKE_INSTALL_PREFIX="$INSTALL_PREFIX" \
#  -DLLVM_ENABLE_ASSERTIONS=TRUE \
#  -DCMAKE_C_COMPILER="/usr/bin/clang" \
#  -DCMAKE_CXX_COMPILER="/usr/bin/clang++" \
#  -DCMAKE_ASM_COMPILER="/usr/bin/clang" \
#  -DPYTHON_EXECUTABLE="${PYTHON}" \
#  -DCMAKE_C_FLAGS="-fno-stack-protector -target ${TRIPLE}" \
#  -DCMAKE_CXX_FLAGS=" -fpermissive -target ${TRIPLE}" \
#  -DCMAKE_BUILD_TYPE=$CMAKE_BUILD_TYPE \
#  -DLLVM_TOOL_SWIFT_BUILD=NO \
#  -DLLVM_INCLUDE_DOCS=TRUE \
#  -DLLVM_TOOL_COMPILER_RT_BUILD=TRUE \
#  -DLLVM_BUILD_EXTERNAL_COMPILER_RT=TRUE \
#  -DLLVM_LIT_ARGS=-sv \
#  $SRC_DIR/llvm
#cd $SRC_DIR
#cmake --build $LLVM_BUILD_DIR

#echo "Patching swift files so that they work with 32 bit."
#sed -i 's/#if defined(__linux__) \&\& defined (__arm__)/#if defined(__linux__) \&\& (defined (__arm__) \|\| defined(__i386__))/' $SRC_DIR/swift/stdlib/public/SwiftShims/LibcShims.h
#sed -i 's/return RetTy{ llvm::Type::getX86_FP80Ty(ctx), Size(16), Alignment(16) };/return RetTy{ llvm::Type::getX86_FP80Ty(ctx), Size(12), Alignment(16) };/' $SRC_DIR/swift/lib/IRGen/GenType.cpp

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
  -DCMAKE_C_FLAGS="-nostdinc -Wno-c++11-narrowing -target ${TRIPLE} $INCLUDE_FLAGS" \
  -DCMAKE_CXX_FLAGS="-nostdinc -Wno-c++11-narrowing -target ${TRIPLE} $INCLUDE_FLAGS" \
  -DCMAKE_EXE_LINKER_FLAGS="$LINK_FLAGS" \
  -DCMAKE_SHARED_LINKER_FLAGS="$LINK_FLAGS" \
  -DSWIFT_NATIVE_SWIFT_TOOLS_PATH="/usr/local/var/swiftenv/shims" \
  -DLLVM_TABLEGEN_EXE=$LLVM_HOST_BUILD_DIR/bin/llvm-tblgen \
  -DSWIFT_STDLIB_BUILD_TYPE="MinSizeRel" \
  -DSWIFT_SDK_LINUX_ARCH_${ARCH}_PATH="$LFS" \
  $SRC_DIR/swift
cd $SRC_DIR
cmake --build $SWIFT_BUILD_DIR

cd $WD
echo "Installing..."
mkdir -p $INSTALL_PREFIX
cd $CMARK_BUILD_DIR && ninja install
cd $LLVM_BUILD_DIR && ninja install
cd $SWIFT_BUILD_DIR && ninja install

#echo "Compiling LLVM with clang and compiler-rt."
#mkdir -p $LLVM_BUILD_DIR
#cd $LLVM_BUILD_DIR
#cmake -G "Ninja" \
#  -DCMAKE_INSTALL_PREFIX="$INSTALL_PREFIX" \
#  -DLLVM_ENABLE_ASSERTIONS=TRUE \
#  -DCMAKE_AS_COMPILER="$AS" \
#  -DCMAKE_C_COMPILER="$GCC" \
#  -DCMAKE_CXX_COMPILER="$GXX" \
#  -DCMAKE_ASM_COMPILER="$GCC" \
#  -DCMAKE_C_FLAGS="-fno-stack-protector" \
#  -DCMAKE_CXX_FLAGS="-fpermissive" \
#  -DCMAKE_BUILD_TYPE=$CMAKE_BUILD_TYPE \
#  -DLLVM_TOOL_SWIFT_BUILD=NO \
#  -DLLVM_INCLUDE_DOCS=TRUE \
#  -DLLVM_TOOL_COMPILER_RT_BUILD=TRUE \
#  -DLLVM_BUILD_EXTERNAL_COMPILER_RT=TRUE \
#  -DCLANG_DEFAULT_RTLIB="compiler-rt" \
#  -DLLVM_LIT_ARGS=-sv \
#  $SRC_DIR/llvm
##LD_LIBRARY_PATH="$LFS/usr/local/lib" ninja -j4
#cd $SRC_DIR
#cmake --build $LLVM_BUILD_DIR
#cd $LLVM_BUILD_DIR && ninja install
cd $WD
