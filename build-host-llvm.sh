#!/usr/bin/env bash
set -e

source setup.sh
#source setup-sysroot.sh
source build-config.sh

cd $SRC_DIR/apple
cd llvm/tools
rm -f clang
rm -f compiler-rt
ln -s $SRC_DIR/clang .
ln -s $SRC_DIR/compiler-rt .


function cmark_host() {
    echo "Compiling cmark for host."
    rm -rf $CMARK_HOST_BUILD_DIR
    mkdir -p $CMARK_HOST_BUILD_DIR
    cd $CMARK_HOST_BUILD_DIR && CC=clang CXX=clang++ cmake -G "Ninja" $SRC_DIR/apple/cmark
    cd $WD
    cmake --build $CMARK_HOST_BUILD_DIR -- -j${PARALLEL}
}
check $BUILD_DIR/.cmark-host cmark_host

function llvm_host() {
    echo "Compiling Host LLVM with clang and compiler-rt."
    rm -rf $LLVM_HOST_BUILD_DIR
    mkdir -p $LLVM_HOST_BUILD_DIR
    cd $LLVM_HOST_BUILD_DIR
    CC=/usr/bin/clang CXX=/usr/bin/clang++ cmake -G "Ninja" \
      -DLLVM_ENABLE_ASSERTIONS=TRUE \
      -DCMAKE_C_FLAGS="-fno-stack-protector" \
      -DCMAKE_CXX_FLAGS="-fpermissive" \
      -DCMAKE_BUILD_TYPE=$CMAKE_BUILD_TYPE \
      -DLLVM_INCLUDE_DOCS=TRUE \
      -DLLVM_LIT_ARGS=-sv \
      $SRC_DIR/apple/llvm
    cd $WD
    cmake --build $LLVM_HOST_BUILD_DIR -- -j${PARALLEL}
}
check $BUILD_DIR/.llvm-host llvm_host

cd $WD
