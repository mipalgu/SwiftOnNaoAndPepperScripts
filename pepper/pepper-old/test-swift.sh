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

cd $SWIFT_BUILD_DIR
env C_INDEX_TEST=$LLVM_HOST_BUILD_DIR/bin/c-index-test SWIFT_AUTOLINK_EXTRACT=$SWIFT_HOST_BUILD_DIR/bin/swift-autolink-extract SWIFT_DEMANGLE_YAMLDUMP=$SWIFT_HOST_BUILD_DIR/bin/swift-demangle-yamldump SWIFT_REFACTOR=$SWIFT_HOST_BUILD_DIR/bin/swift-refactor SWIFT_API_DIGESTER=$SWIFT_HOST_BUILD_DIR/bin/swift-api-digester LLVM_DIS=$LLVM_HOST_BUILD_DIR/bin/llvm-dis LLVM_DWARFDUMP=$LLVM_HOST_BUILD_DIR/bin/llvm-dwarfdump FILECHECK=$LLVM_HOST_BUILD_DIR/bin/FileCheck LLVM_STRINGS=$LLVM_HOST_BUILD_DIR/bin/llvm-strings LLVM_COV=$LLVM_HOST_BUILD_DIR/bin/llvm-cov LLVM_PROFDATA=$LLVM_HOST_BUILD_DIR/bin/llvm-profdata SWIFT_LLVM_OPT=$SWIFT_HOST_BUILD_DIR/bin/swift-llvm-opt LLVM_LINK=$LLVM_HOST_BUILD_DIR/bin/llvm-link CLANG=$LLVM_HOST_BUILD_DIR/bin/clang SWIFT_FORMAT=$SWIFT_HOST_BUILD_DIR/bin/swift-format SWIFT_REMOTEAST_TEST=$SWIFT_HOST_BUILD_DIR/bin/swift-remoteast-test SWIFT_REFLECTION_DUMP=$SWIFT_HOST_BUILD_DIR/bin/swift-reflection-dump SWIFT_SYNTAX_TEST=$SWIFT_HOST_BUILD_DIR/bin/swift-syntax-test SWIFT_IDE_TEST=$SWIFT_HOST_BUILD_DIR/bin/swift-ide-test LLDB_MODULEIMPORT_TEST=$SWIFT_HOST_BUILD_DIR/bin/lldb-moduleimport-test SIL_PASSPIPELINE_DUMPER=$SWIFT_HOST_BUILD_DIR/bin/sil-passpipeline-dumper SIL_NM=$SWIFT_HOST_BUILD_DIR/bin/sil-nm SIL_LLVM_GEN=$SWIFT_HOST_BUILD_DIR/bin/sil-llvm-gen SIL_FUNC_EXTRACTOR=$SWIFT_HOST_BUILD_DIR/bin/sil-func-extractor SIL_OPT=$SWIFT_HOST_BUILD_DIR/bin/sil-opt SWIFT=$SWIFT_HOST_BUILD_DIR/bin/swift SWIFTC=$SWIFT_HOST_BUILD_DIR/bin/swiftc $SRC_DIR/llvm/utils/lit/lit.py -sv --param remote_run_host=nao@pepper.local --param remote_run_tmpdir=/tmp --param remote_run_skip_upload_stdlib --param LDFLAGS="-L$LFS/usr/local/lib -L$LFS/usr/lib -L$LFS/lib" --param SWIFTCFLAGS="--sysroot=$LFS"   test-linux-i686
cd $WD
