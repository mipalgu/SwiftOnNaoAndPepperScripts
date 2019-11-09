#!/usr/bin/env bash
set -e

source setup.sh
#source setup-sysroot.sh

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
LLVM_TABLEGEN=$LLVM_HOST_BUILD_DIR/bin/llvm-tblgen
CLANG_TABLEGEN=$LLVM_HOST_BUILD_DIR/bin/clang-tblgen
HOST_SWIFT=/usr/local/var/swiftenv/shims/swift

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
    cd $SRC_DIR
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
source cross.sh
rm -f $SRC_DIR/llvm/tools/compiler-rt

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

if [ ! -f $SWIFT_BUILD_DIR/.swift-build-cross ]
then
    echo "Compiling swift."
    rm -rf $SWIFT_BUILD_DIR
    mkdir -p $SWIFT_BUILD_DIR
    cd $SWIFT_BUILD_DIR
    PATH="$CROSS_DIR/bin:$PATH" CC="$HOST_CLANG" CXX="$HOST_CLANGXX" CPATH="$CPATH" LIBRARY_PATH="$LIBRARY_PATH" cmake -G "Ninja" \
      -DLLVM_DIR="${SRCDIR/llvm}" \
      -DCMAKE_PREFIX_PATH="$PREFIX_PATH" \
      -DCMAKE_CROSSCOMPILING=TRUE \
      -DCMAKE_SYSROOT="$LFS" \
      -DCMAKE_INSTALL_PREFIX="$INSTALL_PREFIX" \
      -DCMAKE_C_COMPILER="$HOST_CLANG" \
      -DCMAKE_CXX_COMPILER="$HOST_CLANGXX" \
      -DCMAKE_ASM_COMPILER="$HOST_CLANG" \
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
      -DSWIFT_INCLUDE_TESTS=TRUE \
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
      -DCMAKE_C_FLAGS="-gcc-toolchain $CROSS_DIR -Wno-c++11-narrowing -target ${TRIPLE} $INCLUDE_FLAGS -fno-use-cxa-atexit -fPIC $BINARY_FLAGS -I$CROSS_DIR/$TRIPLE/include/c++/$GCC_VERSION -I$CROSS_DIR/$TRIPLE/include/c++/$GCC_VERSION/$TRIPLE" \
      -DCMAKE_CXX_FLAGS="-gcc-toolchain $CROSS_DIR -Wno-c++11-narrowing -target ${TRIPLE} $INCLUDE_FLAGS -fno-use-cxa-atexit -fPIC $BINARY_FLAGS -I$CROSS_DIR/$TRIPLE/include/c++/$GCC_VERSION -I$CROSS_DIR/$TRIPLE/include/c++/$GCC_VERSION/$TRIPLE" \
      -DCMAKE_EXE_LINKER_FLAGS="$LINK_FLAGS -gcc-toolchain $CROSS_DIR -fno-use-cxa-atexit -luuid -lpthread -fvisibility=protected -Bsymbolic" \
      -DCMAKE_SHARED_LINKER_FLAGS="$LINK_FLAGS -gcc-toolchain $CROSS_DIR -fno-use-cxa-atexit -luuid -lpthread -fvisibility=protected -Bsymbolic" \
      -DSWIFT_ENABLE_GOLD_LINKER=TRUE \
      -DSWIFT_ENABLE_LLD_LINKER=FALSE \
      -DSWIFT_NATIVE_SWIFT_TOOLS_PATH="/usr/local/var/swiftenv/shims" \
      -DLLVM_TABLEGEN_EXE=$LLVM_TABLEGEN \
      -DSWIFT_STDLIB_BUILD_TYPE="MinSizeRel" \
      -DSWIFT_SDK_LINUX_ARCH_${ARCH}_PATH="$LFS" \
      -DSWIFT_LINUX_${ARCH}_ICU_UC="$CROSS_DIR/icu/lib/libicuuc.so" \
      -DSWIFT_LINUX_${ARCH}_ICU_UC_INCLUDE="$CROSS_DIR/icu/include" \
      -DSWIFT_LINUX_${ARCH}_ICU_I18N="$CROSS_DIR/icu/lib/libicui18n.so" \
      -DSWIFT_LINUX_${ARCH}_ICU_I18N_INCLUDE="$CROSS_DIR/icu/include" \
      -DLIBXML2_INCLUDE_DIR="$CROSS_DIR/xml2/include/libxml2" \
      -DLIBXML2_LIBRARY="$CROSS_DIR/xml2/lib/libxml2.so" \
      $SRC_DIR/swift
    cd $SRC_DIR
    cmake --build $SWIFT_BUILD_DIR -- -j${PARALLEL}
    touch $SWIFT_BUILD_DIR/lib/swift/linux/i686/StdlibUnicodeUnittest.swiftmodule
    touch $SWIFT_BUILD_DIR/lib/swift/linux/i686/StdlibUnicodeUnittest.swiftdoc
    touch $SWIFT_BUILD_DIR/lib/swift/linux/i686/StdlibUnicodeUnittest.swiftinterface
    touch $SWIFT_BUILD_DIR/lib/swift/linux/libswiftStdlibUnicodeUnittest.so
    touch $SWIFT_BUILD_DIR/lib/swift/linux/i686/StdlibCollectionUnittest.swiftmodule
    touch $SWIFT_BUILD_DIR/lib/swift/linux/i686/StdlibCollectionUnittest.swiftdoc
    touch $SWIFT_BUILD_DIR/lib/swift/linux/i686/StdlibCollectionUnittest.swiftinterface
    touch $SWIFT_BUILD_DIR/lib/swift/linux/libswiftStdlibCollectionUnittest.so
    cd $SWIFT_BUILD_DIR && ninja install
    touch $SWIFT_BUILD_DIR/.swift-build-cross
fi

cd $WD

#COMMAND="/usr/local/var/swiftenv/versions/5.0/usr/bin/clang -o hello main.o ${LINK_FLAGS} -L$INSTALL_PREFIX/lib/swift/linux -lswiftCore -lswiftSwiftOnoneSupport -target $TRIPLE"
#echo "$COMMAND"
#$COMMAND
#rm -r $WD/main
#mkdir -p $WD/main
#cd $WD/main
#echo "print(\"Hello World\")" > main.swift
#$HOST_SWIFT package init --type executable
#SWIFT_INCLUDE_FLAGS=`echo "$INCLUDE_FLAGS" | sed 's/^\|\s/ -Xcc /g'`
#SWIFT_LD_FLAGS=`echo "$LINK_FLAGS" | sed 's/^\|\s+/ -Xlinker /g'`
#COMMAND="swiftc -o main.o -c main.swift -target $TRIPLE -sdk $INSTALL_PREFIX $SWIFT_LD_FLAGS $SWIFT_INCLUDE_FLAGS"
#echo "$COMMAND"
#$COMMAND

#ln -s $SWIFT_BUILD_DIR/lib/swift/linux/i686 $SWIFT_HOST_BUILD_DIR/lib/swift/linux/

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
#  -DLLVM_TABLEGEN_EXE=$LLVM_TABLEGEN \
#  -DSWIFT_STDLIB_BUILD_TYPE="MinSizeRel" \
#  -DSWIFT_SDK_LINUX_ARCH_${ARCH}_PATH="$LFS" \
#  $SRC_DIR/llbuild
#cd $SRC_DIR
#cmake --build $LLBUILD_BUILD_DIR
#cd $LLBUILD_BUILD_DIR && ninja install

#echo "Compiling libdispatch"
#rm -rf $DISPATCH_BUILD_DIR
#mkdir -p $DISPATCH_BUILD_DIR
#cd $DISPATCH_BUILD_DIR
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
#  -DCMAKE_C_FLAGS="-nostdinc -Wno-c++11-narrowing -Wno-conversion -Wno-sign-conversion -Wno-builtin-requires-header -ferror-limit=100 -target ${TRIPLE} $INCLUDE_FLAGS" \
#  -DCMAKE_CXX_FLAGS="-nostdinc -Wno-c++11-narrowing -Wno-conversion -Wno-sign-conversion -Wno-builtin-requires-header -ferror-limit=100 -target ${TRIPLE} $INCLUDE_FLAGS" \
#  -DCMAKE_EXE_LINKER_FLAGS="$LINK_FLAGS -latomic" \
#  -DCMAKE_SHARED_LINKER_FLAGS="$LINK_FLAGS -latomic" \
#  -DSWIFT_NATIVE_SWIFT_TOOLS_PATH="/usr/local/var/swiftenv/shims" \
#  -DLLVM_TABLEGEN_EXE=$LLVM_TABLEGEN \
#  -DSWIFT_STDLIB_BUILD_TYPE="MinSizeRel" \
#  -DSWIFT_SDK_LINUX_ARCH_${ARCH}_PATH="$LFS" \
#  $SRC_DIR/swift-corelibs-libdispatch
#cp -p $DISPATCH_BUILD_DIR/build.ninja $DISPATCH_BUILD_DIR/build.ninja.orig
#sed < $DISPATCH_BUILD_DIR/build.ninja.orig > $DISPATCH_BUILD_DIR/build.ninja					\
#    -e "s|-Werror |-Wno-implicit-function-declaration |g"		\
#    -e "s|-Wdeprecated-dynamic-exception-spec ||g"			\
#    -e "s|-Wconversion |-Wno-macro-redefined |g"			\
#    -e "s|-Wimplicit-function-declaration ||g"			\
#    -e "s|-Wbuiltin-requires-header ||g"				\
#    -e "s|-Wmacro-redefined ||g"					\
#    -e "s|-Wsign-conversion ||g"
#cd $SRC_DIR
#cmake --build $DISPATCH_BUILD_DIR
#cd $DISPATCH_BUILD_DIR && ninja install

#echo "Compiling Foundation"
#rm -rf $FOUNDATION_BUILD_DIR
#mkdir -p $FOUNDATION_BUILD_DIR
#cd $FOUNDATION_BUILD_DIR
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
#  -DLLVM_TABLEGEN_EXE=$LLVM_TABLEGEN \
#  -DSWIFT_STDLIB_BUILD_TYPE="MinSizeRel" \
#  -DSWIFT_SDK_LINUX_ARCH_${ARCH}_PATH="$LFS" \
#  $SRC_DIR/swift-corelibs-foundation
#cd $SRC_DIR
#cmake --build $FOUNDATION_BUILD_DIR
#cd $FOUNDATION_BUILD_DIR && ninja install
