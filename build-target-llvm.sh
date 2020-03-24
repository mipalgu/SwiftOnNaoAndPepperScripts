#!/usr/bin/env bash
set -e

source build-config.sh

cd $WD
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

function cmark() {
    echo "Compiling cmark."
    rm -rf $CMARK_BUILD_DIR
    mkdir -p $CMARK_BUILD_DIR
    cd $CMARK_BUILD_DIR
    PATH="$CROSS_DIR/bin:$PATH" CC="$LFS_TGT-gcc" CXX="$LFS_TGT-g++" LD="$LFS/bin/$LFS_TGT-ld.gold" cmake -G "Ninja" \
      -DCMAKE_SYSTEM_NAME="Linux" \
      -DCMAKE_INSTALL_PREFIX="$INSTALL_PREFIX" \
      -DCMAKE_FIND_ROOT_PATH_MODE_PROGRAM=NEVER \
      -DCMAKE_FIND_ROOT_PATH_MODE_LIBRARY=ONLY \
      -DCMAKE_FIND_ROOT_PATH_MODE_INCLUDE=ONLY \
      -DCMAKE_C_COMPILER="$HOST_CLANG" \
      -DCMAKE_CXX_COMPILER="$HOST_CLANGXX" \
      -DCMAKE_C_FLAGS="-gcc-toolchain $LFS $INCLUDE_FLAGS $BINARY_FLAGS" \
      -DCMAKE_CXX_FLAGS="-gcc-toolchain $LFS $INCLUDE_FLAGS $BINARY_FLAGS" \
      -DCMAKE_EXE_LINKER_FLAGS="-gcc-toolchain $LFS" \
      -DCMAKE_SHARED_LINKER_FLAGS="-gcc-toolchain $LFS" \
      $SRC_DIR/cmark
    cd $SRC_DIR
    PATH="$CROSS_DIR/bin/:$PATH" cmake --build $CMARK_BUILD_DIR -- -j${PARALLEL}
    PATH="$CROSS_DIR/bin/:$PATH" cd $CMARK_BUILD_DIR && ninja install
    touch $CMARK_BUILD_DIR/.cmark-build-cross
}
check $CMARK_BUILD_DIR/.cmark cmark

function llvm() {
    echo "Compiling LLVM with clang and compiler-rt."
    rm -rf $LLVM_BUILD_DIR
    mkdir -p $LLVM_BUILD_DIR
    cd $LLVM_BUILD_DIR
    PATH="$CROSS_DIR/bin:$PATH" CC="$LFS_TGT-gcc" CXX="$LFS_TGT-g++" CPATH="$CPATH" LIBRARY_PATH="$LIBRARY_PATH" cmake -G "Ninja" \
      -DCMAKE_SYSTEM_NAME="Linux" \
      -DCMAKE_INSTALL_PREFIX="$INSTALL_PREFIX" \
      -DCMAKE_FIND_ROOT_PATH_MODE_PROGRAM=NEVER \
      -DCMAKE_FIND_ROOT_PATH_MODE_LIBRARY=ONLY \
      -DCMAKE_FIND_ROOT_PATH_MODE_INCLUDE=ONLY \
      -DCMAKE_C_COMPILER="$LFS_TGT-gcc" \
      -DCMAKE_CXX_COMPILER="$LFS_TGT-g++" \
      -DCMAKE_ASM_COMPILER="$LFS_TGT-gcc" \
      -DLLVM_ENABLE_PROJECTS="$LLVM_CROSS_PROJECTS" \
      -DLLVM_TARGET_ARCH="${ARCH}" \
      -DLLVM_TARGETS_TO_BUILD="X86" \
      -DLLVM_ENABLE_ASSERTIONS=TRUE \
      -DPYTHON_EXECUTABLE="${PYTHON}" \
      -DCMAKE_C_FLAGS="-gcc-toolchain $LFS -fno-stack-protector $INCLUDE_FLAGS $BINARY_FLAGS" \
      -DCMAKE_CXX_FLAGS="-gcc-toolchain $LFS -fpermissive $INCLUDE_FLAGS $BINARY_FLAGS" \
      -DCMAKE_EXE_LINKER_FLAGS="-gcc-toolchain $LFS $LINK_FLAGS" \
      -DCMAKE_SHARED_LINKER_FLAGS="-gcc-toolchain $LFS $LINK_FLAGS" \
      -DCMAKE_BUILD_TYPE=$CMAKE_BUILD_TYPE \
      -DLLVM_USE_LINKER=gold \
      -DLLVM_INCLUDE_DOCS=TRUE \
      -DLLVM_LIT_ARGS=-sv \
      $SRC_DIR/llvm
    cd $SRC_DIR
    PATH="$CROSS_DIR/bin:$PATH" cmake --build $LLVM_BUILD_DIR
    PATH="$CROSS_DIR/bin:$PATH" cd $LLVM_BUILD_DIR && ninja install
    touch $LLVM_BUILD_DIR/.llvm-build-cross
}
check $LLVM_BUILD_DIR/.llvm llvm

cd $WD
