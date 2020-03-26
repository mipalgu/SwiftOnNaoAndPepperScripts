#!/usr/bin/env bash
set -e

source setup.sh
#source setup-sysroot.sh
source build-config.sh

cd $SRC_DIR
cd llvm/tools
rm -f clang
rm -f compiler-rt
ln -s $SRC_DIR/clang .
ln -s $SRC_DIR/compiler-rt .


if [ ! -f $CMARK_HOST_BUILD_DIR/.cmark-build-host ]
then
    echo "Compiling cmark for host."
    rm -rf $CMARK_HOST_BUILD_DIR
    mkdir -p $CMARK_HOST_BUILD_DIR
    cd $CMARK_HOST_BUILD_DIR && cmake -G "Ninja" $SRC_DIR/cmark
    cd $SRC_DIR/apple
    CC=/usr/bin/clang CXX=/usr/bin/clang++ cmake --build $CMARK_HOST_BUILD_DIR -- -j${PARALLEL}
    touch $CMARK_HOST_BUILD_DIR/.cmark-build-host
fi

if [ ! -f $LLVM_HOST_BUILD_DIR/.llvm-build-host ]
then
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
      $SRC_DIR/llvm
    cd $SRC_DIR
    cmake --build $LLVM_HOST_BUILD_DIR -- -j${PARALLEL}
    touch $LLVM_HOST_BUILD_DIR/.llvm-build-host
fi

cd $WD
