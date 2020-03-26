#!/usr/bin/env bash
set -e

source setup.sh
source build-config.sh

cd $WD
rm -f $SRC_DIR/apple/llvm/tools/compiler-rt
cd $SRC_DIR/apple
cd llvm/tools
rm -f libcxx
rm -f libcxxabi

if [ "$BUILD_LIBCXX" = true ]
then
    ln -s $SRC_DIR/apple/libcxx .
    ln -s $SRC_DIR/apple/libcxxabi .
fi

LFS_TGT=$(uname -m)-lfs-linux-gnu
INSTALL_PREFIX=$LFS
INCLUDE_FLAGS="-I$LFS/usr/include -I$LFS/include"
LINK_FLAGS="-L$LFS/usr/lib -L$LFS/lib"
LIBRARY_PATH="$LFS/usr/lib:$LFS/lib"

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
      -DCMAKE_C_COMPILER="$LFS_TGT-gcc" \
      -DCMAKE_CXX_COMPILER="$LFS_TGT-g++" \
      -DCMAKE_C_FLAGS="$INCLUDE_FLAGS $BINARY_FLAGS" \
      -DCMAKE_CXX_FLAGS="$INCLUDE_FLAGS $BINARY_FLAGS" \
      -DCMAKE_EXE_LINKER_FLAGS="" \
      -DCMAKE_SHARED_LINKER_FLAGS="" \
      $SRC_DIR/apple/cmark
    cd $SRC_DIR/apple
    PATH="$CROSS_DIR/bin/:$PATH" cmake --build $CMARK_BUILD_DIR -- -j${PARALLEL}
    PATH="$CROSS_DIR/bin/:$PATH" cd $CMARK_BUILD_DIR && sudo ninja install
    touch $CMARK_BUILD_DIR/.cmark-build-cross
}
check $CMARK_BUILD_DIR/.cmark cmark

function llvm() {
    echo "Compiling LLVM with clang and compiler-rt."
    rm -rf $LLVM_BUILD_DIR
    mkdir -p $LLVM_BUILD_DIR
    cd $LLVM_BUILD_DIR
    PATH="$CROSS_DIR/bin:$PATH" CC="$LFS/bin/gcc" CXX="$LFS/bin/g++" LD="$LFS/bin/ld.gold" CPATH="$CPATH" LIBRARY_PATH="$LIBRARY_PATH" /usr/local/bin/cmake -G "Ninja" \
      -DCMAKE_SYSTEM_NAME="Linux" \
      -DCMAKE_INSTALL_PREFIX="$INSTALL_PREFIX" \
      -DCMAKE_SYSROOT="$LFS" \
      -DLLVM_ENABLE_PROJECTS="$LLVM_CROSS_PROJECTS" \
      -DLLVM_ENABLE_ASSERTIONS=TRUE \
      -DPYTHON_EXECUTABLE="${PYTHON}" \
      -DCMAKE_C_FLAGS="-fno-stack-protector $INCLUDE_FLAGS" \
      -DCMAKE_CXX_FLAGS="-fpermissive $INCLUDE_FLAGS" \
      -DCMAKE_EXE_LINKER_FLAGS="$LINK_FLAGS" \
      -DCMAKE_SHARED_LINKER_FLAGS="$LINK_FLAGS" \
      -DCMAKE_INCLUDE_PATH="$LFS/usr/include;$LFS/include" \
      -DCMAKE_LIBRARY_PATH="$LFS/usr/lib;$LFS/lib" \
      -DZLIB_ROOT="$LFS/usr" \
      -DCMAKE_BUILD_TYPE=$CMAKE_BUILD_TYPE \
      -DLLVM_INCLUDE_DOCS=TRUE \
      -DLLVM_LIT_ARGS=-sv \
      $SRC_DIR/apple/llvm
    cd $SRC_DIR/apple
    PATH="$CROSS_DIR/bin:$PATH" /usr/local/bin/cmake --build $LLVM_BUILD_DIR
    PATH="$CROSS_DIR/bin:$PATH" cd $LLVM_BUILD_DIR && sudo ninja install
    touch $LLVM_BUILD_DIR/.llvm-build-cross
}
check $LLVM_BUILD_DIR/.llvm llvm

cd $WD
