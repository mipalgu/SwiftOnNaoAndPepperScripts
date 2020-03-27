#!/usr/bin/env bash
set +h

source setup.sh

if [ -z "$BUILD_CONFIG_SH_INCLUDED" ]
then
BUILD_CONFIG_SH_INCLUDED=yes

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
LIBDISPATCH_BUILD_DIR=$BUILD_DIR/libdispatch-$PLATFORM
XCTEST_BUILD_DIR=$BUILD_DIR/xctest-$PLATFORM
PYTHONPATH="$SRC_DIR/swift/utils"
PYTHON="/usr/bin/python"
BUILD_CLANG=$LLVM_BUILD_DIR/bin/clang
BUILD_CLANGXX=$LLVM_BUILD_DIR/bin/clang++
#HOST_CLANG=$LLVM_HOST_BUILD_DIR/bin/clang
#HOST_CLANGXX=$LLVM_HOST_BUILD_DIR/bin/clang++
HOST_CLANG=/usr/local/var/swiftenv/versions/5.1.3/usr/bin/clang
HOST_CLANGXX=/usr/local/var/swiftenv/versions/5.1.3/usr/bin/clang++
LLVM_TABLEGEN=$LLVM_HOST_BUILD_DIR/bin/llvm-tblgen
CLANG_TABLEGEN=$LLVM_HOST_BUILD_DIR/bin/clang-tblgen
HOST_SWIFT=/usr/local/var/swiftenv/shims/swift
LLVM_CROSS_PROJECTS="clang"

if [ "$BUILD_LIBCXX" = true ]
then
    LLVM_CROSS_PROJECTS="$LLVM_CROSS_PROJECTS;libcxx;libcxxabi"
fi

fi # End BUILD_CONFIG_SH_INCLUDED
