#!/usr/bin/env bash
set -e

source build-config.sh

cd $WD
source cross.sh
rm -f $SRC_DIR/llvm/tools/compiler-rt
cd $SRC_DIR
cd llvm/tools
rm -f libcxx
rm -f libcxxabi

if [ "$BUILD_LIBCXX" = true ]
then
    ln -s $SRC_DIR/libcxx .
    ln -s $SRC_DIR/libcxxabi .
fi

if [ ! -f $CMARK_BUILD_DIR/.cmark-build-cross ]
then
    echo "Compiling cmark."
    rm -rf $CMARK_BUILD_DIR
    mkdir -p $CMARK_BUILD_DIR
    cd $CMARK_BUILD_DIR
    PATH="$CROSS_DIR/bin:$PATH" CC="$HOST_CLANG" CXX="$HOST_CLANGXX" LD="$CROSS_DIR/bin/$TIPLE-ld.gold" cmake -G "Ninja" \
      -DCMAKE_CROSSCOMPILING=TRUE \
      -DCMAKE_SYSTEM_NAME="Linux" \
      -DCMAKE_SYSROOT="$LFS" \
      -DCMAKE_INSTALL_PREFIX="$INSTALL_PREFIX" \
      -DCMAKE_FIND_ROOT_PATH_MODE_PROGRAM=NEVER \
      -DCMAKE_FIND_ROOT_PATH_MODE_LIBRARY=ONLY \
      -DCMAKE_FIND_ROOT_PATH_MODE_INCLUDE=ONLY \
      -DCMAKE_LIBRARY_ARCHITECTURE="$TRIPLE" \
      -DCMAKE_C_COMPILER="$HOST_CLANG" \
      -DCMAKE_C_COMPILER_TARGET="$TRIPLE" \
      -DCMAKE_CXX_COMPILER="$HOST_CLANGXX" \
      -DCMAKE_CXX_COMPILER_TARGET="$TRIPLE" \
      -DCMAKE_C_FLAGS="-gcc-toolchain $CROSS_DIR $INCLUDE_FLAGS $BINARY_FLAGS" \
      -DCMAKE_CXX_FLAGS="-gcc-toolchain $CROSS_DIR $INCLUDE_FLAGS $BINARY_FLAGS" \
      -DCMAKE_EXE_LINKER_FLAGS="-gcc-toolchain $CROSS_DIR" \
      -DCMAKE_SHARED_LINKER_FLAGS="-gcc-toolchain $CROSS_DIR" \
      -DLLVM_TEMPORARILY_ALLOW_OLD_TOOLCHAIN=TRUE \
      $SRC_DIR/cmark
    cd $SRC_DIR
    PATH="$CROSS_DIR/bin/:$PATH" cmake --build $CMARK_BUILD_DIR -- -j${PARALLEL}
    PATH="$CROSS_DIR/bin/:$PATH" cd $CMARK_BUILD_DIR && ninja install
    touch $CMARK_BUILD_DIR/.cmark-build-cross
fi

if [ ! -f $LLVM_BUILD_DIR/.llvm-build-cross ]
then
    echo "Compiling LLVM with clang and compiler-rt."
    rm -rf $LLVM_BUILD_DIR
    mkdir -p $LLVM_BUILD_DIR
    cd $LLVM_BUILD_DIR
    PATH="$CROSS_DIR/bin:$PATH" CC="$HOST_CLANG" CXX="$HOST_CLANGXX" CPATH="$CPATH" LIBRARY_PATH="$LIBRARY_PATH" cmake -G "Ninja" \
      -DCMAKE_CROSSCOMPILING=TRUE \
      -DCMAKE_SYSTEM_NAME="Linux" \
      -DCMAKE_SYSROOT="$LFS" \
      -DCMAKE_INSTALL_PREFIX="$INSTALL_PREFIX" \
      -DCMAKE_FIND_ROOT_PATH_MODE_PROGRAM=NEVER \
      -DCMAKE_FIND_ROOT_PATH_MODE_LIBRARY=ONLY \
      -DCMAKE_FIND_ROOT_PATH_MODE_INCLUDE=ONLY \
      -DCMAKE_LIBRARY_ARCHITECTURE="$TRIPLE" \
      -DCMAKE_C_COMPILER="$HOST_CLANG" \
      -DCMAKE_C_COMPILER_TARGET="$TRIPLE" \
      -DCMAKE_CXX_COMPILER="$HOST_CLANGXX" \
      -DCMAKE_CXX_COMPILER_TARGET="$TRIPLE" \
      -DCMAKE_ASM_COMPILER="$HOST_CLANG" \
      -DLLVM_TABLEGEN=$LLVM_TABLEGEN \
      -DCLANG_TABLEGEN=$CLANG_TABLEGEN \
      -DLLVM_ENABLE_PROJECTS="$LLVM_CROSS_PROJECTS" \
      -DLLVM_DEFAULT_TARGET_TRIPLE="${TRIPLE}" \
      -DLLVM_TARGET_ARCH="${ARCH}" \
      -DLLVM_TARGETS_TO_BUILD="X86" \
      -DLLVM_ENABLE_ASSERTIONS=TRUE \
      -DPYTHON_EXECUTABLE="${PYTHON}" \
      -DCMAKE_C_FLAGS="-gcc-toolchain $CROSS_DIR -fno-stack-protector $INCLUDE_FLAGS $BINARY_FLAGS" \
      -DCMAKE_CXX_FLAGS="-gcc-toolchain $CROSS_DIR -fpermissive $INCLUDE_FLAGS $BINARY_FLAGS" \
      -DCMAKE_EXE_LINKER_FLAGS="-gcc-toolchain $CROSS_DIR $LINK_FLAGS" \
      -DCMAKE_SHARED_LINKER_FLAGS="-gcc-toolchain $CROSS_DIR $LINK_FLAGS" \
      -DCMAKE_BUILD_TYPE=$CMAKE_BUILD_TYPE \
      -DLLVM_USE_LINKER=gold \
      -DLLVM_INCLUDE_DOCS=TRUE \
      -DLLVM_LIT_ARGS=-sv \
      $SRC_DIR/llvm
    cd $SRC_DIR
    PATH="$CROSS_DIR/bin:$PATH" cmake --build $LLVM_BUILD_DIR
    PATH="$CROSS_DIR/bin:$PATH" cd $LLVM_BUILD_DIR && ninja install
    touch $LLVM_BUILD_DIR/.llvm-build-cross
fi

cd $WD
