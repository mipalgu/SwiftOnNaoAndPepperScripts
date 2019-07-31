#!/usr/bin/env bash
set -e

source setup.sh
#source setup-sysroot.sh

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
#HOST_CLANG=/usr/local/var/swiftenv/shims/clang
#HOST_CLANGXX=/usr/local/var/swiftenv/shims/clang++
HOST_SWIFT=/usr/local/var/swiftenv/shims/swift

# Build a new set of binutils with the gold linker enabled.
#rm -rf $WD/build-binutils
#mkdir $WD/build-binutils
#cd $WD/build-binutils
#$WD/binutils-2.25/configure --prefix=$CROSS_TOOLCHAIN_DIR --target=${TRIPLE} --enable-gold=yes --with-sysroot=/
#PATH="$CROSS_TOOLCHAIN_DIR/bin:$PATH" make
#PATH="$CROSS_TOOLCHAIN_DIR/bin:$PATH" make install
#cd $WD

#rm -rf $SRC_DIR
#mkdir -p $SRC_DIR
cd $SRC_DIR
#tar -xzvf $WD/apple.tar.gz
cd llvm/tools
rm -f clang
rm -f compiler-rt
ln -s $SRC_DIR/clang .
#ln -s $SRC_DIR/compiler-rt .

#echo "Compiling cmark for host."
#rm -rf $CMARK_HOST_BUILD_DIR
#mkdir -p $CMARK_HOST_BUILD_DIR
#cd $CMARK_HOST_BUILD_DIR && cmake -G "Ninja" $SRC_DIR/cmark
#cd $SRC_DIR
#CC=/usr/bin/clang CXX=/usr/bin/clang++ cmake --build $CMARK_HOST_BUILD_DIR

#echo "Compiling Host LLVM with clang and compiler-rt."
#rm -rf $LLVM_HOST_BUILD_DIR
#mkdir -p $LLVM_HOST_BUILD_DIR
#cd $LLVM_HOST_BUILD_DIR
#CC=/usr/bin/clang CXX=/usr/bin/clang++ cmake -G "Ninja" \
#  -DLLVM_ENABLE_ASSERTIONS=TRUE \
#  -DCMAKE_C_FLAGS="-fno-stack-protector" \
#  -DCMAKE_CXX_FLAGS="-fpermissive" \
#  -DCMAKE_BUILD_TYPE=$CMAKE_BUILD_TYPE \
#  -DLLVM_INCLUDE_DOCS=TRUE \
#  -DLLVM_LIT_ARGS=-sv \
#  $SRC_DIR/llvm
#cd $SRC_DIR
#cmake --build $LLVM_HOST_BUILD_DIR

#echo "Compiling swift for host."
#rm -rf $SWIFT_HOST_BUILD_DIR
#mkdir -p $SWIFT_HOST_BUILD_DIR
#cd $SWIFT_HOST_BUILD_DIR
#cmake -G "Ninja" \
#  -DLLVM_DIR="${SRCDIR/llvm}" \
#  -DCMAKE_BUILD_TYPE=$CMAKE_BUILD_TYPE \
#  -DCMAKE_C_COMPILER="/usr/bin/clang" \
#  -DCMAKE_CXX_COMPILER="/usr/bin/clang++" \
#  -DCMAKE_ASM_COMPILER="/usr/bin/clang" \
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
#  -DCMAKE_C_FLAGS="-Wno-c++11-narrowing -fno-use-cxa-atexit" \
#  -DCMAKE_CXX_FLAGS="-Wno-c++11-narrowing -fno-use-cxa-atexit" \
#  -DCMAKE_EXE_LINKER_FLAGS="-fno-use-cxa-atexit -luuid -lpthread" \
#  -DCMAKE_SHARED_LINKER_FLAGS="-fno-use-cxa-atexit -luuid -lpthread" \
#  -DSWIFT_NATIVE_SWIFT_TOOLS_PATH="/usr/local/var/swiftenv/shims" \
#  -DLLVM_TABLEGEN_EXE=$LLVM_HOST_BUILD_DIR/bin/llvm-tblgen \
#  -DSWIFT_STDLIB_BUILD_TYPE="MinSizeRel" \
#  $SRC_DIR/swift
#cd $SRC_DIR
#cmake --build $SWIFT_HOST_BUILD_DIR
#touch $SWIFT_BUILD_DIR/lib/swift/linux/i686/StdlibUnicodeUnittest.swiftmodule
#touch $SWIFT_BUILD_DIR/lib/swift/linux/i686/StdlibUnicodeUnittest.swiftdoc
#touch $SWIFT_BUILD_DIR/lib/swift/linux/i686/StdlibUnicodeUnittest.swiftinterface
#touch $SWIFT_BUILD_DIR/lib/swift/linux/libswiftStdlibUnicodeUnittest.so
#touch $SWIFT_BUILD_DIR/lib/swift/linux/i686/StdlibCollectionUnittest.swiftmodule
#touch $SWIFT_BUILD_DIR/lib/swift/linux/i686/StdlibCollectionUnittest.swiftdoc
#touch $SWIFT_BUILD_DIR/lib/swift/linux/i686/StdlibCollectionUnittest.swiftinterface
#touch $SWIFT_BUILD_DIR/lib/swift/linux/libswiftStdlibCollectionUnittest.so

cd $WD
source cross.sh
rm -f $SRC_DIR/llvm/tools/compiler-rt

#echo "Compiling cmark."
#rm -rf $CMARK_BUILD_DIR
#mkdir -p $CMARK_BUILD_DIR
#cd $CMARK_BUILD_DIR
#CC="$HOST_CLANG" CXX="$HOST_CLANGXX" cmake -G "Ninja" \
#  -DCMAKE_CROSSCOMPILING=TRUE \
#  -DCMAKE_SYSROOT="$LFS" \
#  -DCMAKE_INSTALL_PREFIX="$INSTALL_PREFIX" \
#  -DCMAKE_C_COMPILER="$HOST_CLANG" \
#  -DCMAKE_CXX_COMPILER="$HOST_CLANGXX" \
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
#  -DCMAKE_C_COMPILER="$HOST_CLANG" \
#  -DCMAKE_CXX_COMPILER="$HOST_CLANGXX" \
#  -DCMAKE_ASM_COMPILER="$HOST_CLANG" \
#  -DPYTHON_EXECUTABLE="${PYTHON}" \
#  -DCMAKE_C_FLAGS="-fno-stack-protector -target ${TRIPLE}" \
#  -DCMAKE_CXX_FLAGS="-fpermissive -target ${TRIPLE}" \
#  -DCMAKE_BUILD_TYPE=$CMAKE_BUILD_TYPE \
#  -DLLVM_USE_LINKER=gold \
#  -DLLVM_INCLUDE_DOCS=TRUE \
#  -DLLVM_LIT_ARGS=-sv \
#  $SRC_DIR/llvm
#cd $SRC_DIR
#cmake --build $LLVM_BUILD_DIR

cd $WD
#source cross-gcc-headers.sh

#cd $LFS/usr/include
#ln -s ../../lib/gcc/i686-aldebaran-linux-gnu/4.9.2/include/stddef.h .
#ln -s ../../lib/gcc/i686-aldebaran-linux-gnu/4.9.2/include/stdarg.h .
#ln -s linux/stddef.h .
cd $WD

#cd $WD/zlib-1.2.11
#make distclean
#rm -rf $WD/build-zlib
#mkdir $WD/build-zlib
#cd $WD/build-zlib
#PATH="$CROSS_TOOLCHAIN_DIR/bin:$PATH" CFLAGS="$CFLAGS -fPIC" CXXFLAGS="$CXXFLAGS -fPIC" CC="$CROSS_TOOLCHAIN_DIR/bin/$TRIPLE-gcc" AR="$CROSS_TOOLCHAIN_DIR/bin/$TRIPLE-ar" LD="$CROSS_TOOLCHAIN_DIR/bin/$TRIPLE-ld" $WD/zlib-1.2.11/configure --prefix=$INSTALL_PREFIX
#PATH="$CROSS_TOOLCHAIN_DIR/bin:$PATH" make
#PATH="$CROSS_TOOLCHAIN_DIR/bin:$PATH" make install
#cd $WD

#rm -rf $WD/build-xz
#mkdir $WD/build-xz
#cd $WD/build-xz
#PATH="$CROSS_TOOLCHAIN_DIR/bin:$PATH" CFLAGS="$CFLAGS -fPIC" CXXFLAGS="$CXXFLAGS -fPIC" $WD/xz-5.0.5/configure --prefix=$INSTALL_PREFIX --host=${TRIPLE} --with-sysroot="${CROSS_TOOLCHAIN_DIR}"
#PATH="$CROSS_TOOLCHAIN_DIR/bin:$PATH" make
#PATH="$CROSS_TOOLCHAIN_DIR/bin:$PATH" make install
#cd $SRC_DIR

#rm -rf $WD/build-python
#mkdir $WD/build-python
#cd $WD/build-python
#echo "ac_cv_file__dev_ptmx=no" > config.site
#echo "ac_cv_file__dev_ptc=no" >> config.site
#PATH="$CROSS_TOOLCHAIN_DIR/bin:$PATH" CFLAGS="$CFLAGS -fPIC $INCLUDE_FLAGS" CXXFLAGS="$CXXFLAGS -fPIC $INCLUDE_FLAGS" LDFLAGS="$L_FLAGS" CONFIG_SITE=config.site $WD/Python-2.7.15rc1/configure --prefix=$INSTALL_PREFIX --host=${TRIPLE} --build=$ARCH --prefix="${CROSS_TOOLCHAIN_DIR}" --disable-ipv6
#PATH="$CROSS_TOOLCHAIN_DIR/bin:$PATH" make
#PATH="$CROSS_TOOLCHAIN_DIR/bin:$PATH" make install
#cd $SRC_DIR

#rm -rf $WD/build-xml2
#mkdir $WD/build-xml2
#cd $WD/build-xml2
#PATH="$CROSS_TOOLCHAIN_DIR/bin:$PATH" CFLAGS="$CFLAGS -fPIC $INCLUDE_FLAGS" CXXFLAGS="$CXXFLAGS -fPIC $INCLUDE_FLAGS" LDFLAGS="$L_FLAGS -lz -llzma" $WD/libxml2-2.9.2/configure --prefix=$INSTALL_PREFIX --host=${TRIPLE} --with-sysroot="${CROSS_TOOLCHAIN_DIR}" --with-zlib="$INSTALL_PREFIX/lib" --with-lzma="$INSTALL_PREFIX/lib" 
#PATH="$CROSS_TOOLCHAIN_DIR/bin:$PATH" make
#PATH="$CROSS_TOOLCHAIN_DIR/bin:$PATH" make install
#cd $SRC_DIR

#cd $SRC_DIR/icu
#make distclean
#rm -rf $WD/build-icu
#mkdir $WD/build-icu
#cd $WD/build-icu
#PATH="$CROSS_TOOLCHAIN_DIR/bin:$PATH" CFLAGS="$CFLAGS -fPIC" CXXFLAGS="$CXXFLAGS -fPIC" LDFLAGS="$L_FLAGS" $SRC_DIR/icu/configure --prefix=$INSTALL_PREFIX --host=${TRIPLE} --with-sysroot="${CROSS_TOOLCHAIN_DIR}"
#PATH="$CROSS_TOOLCHAIN_DIR/bin:$PATH" make
#PATH="$CROSS_TOOLCHAIN_DIR/bin:$PATH" make install
#cd $SRC_DIR

#rm -rf $WD/build-libuuid
#mkdir $WD/build-libuuid
#cd $WD/build-libuuid
#PATH="$CROSS_TOOLCHAIN_DIR/bin:$PATH" CFLAGS="$CFLAGS -fPIC" CXXFLAGS="$CXXFLAGS -fPIC" LDFLAGS="$L_FLAGS -fPIC" ../libuuid-1.0.3/configure --prefix=$INSTALL_PREFIX --host=${TRIPLE} --with-sysroot="${CROSS_TOOLCHAIN_DIR}"
#PATH="$CROSS_TOOLCHAIN_DIR/bin:$PATH" make
#PATH="$CROSS_TOOLCHAIN_DIR/bin:$PATH" make install
#cd $SRC_DIR

#echo "Compiling swift."
#rm -rf $SWIFT_BUILD_DIR
#mkdir -p $SWIFT_BUILD_DIR
#cd $SWIFT_BUILD_DIR
#cmake -G "Ninja" \
#  -DLLVM_DIR="${SRCDIR/llvm}" \
#  -DCMAKE_PREFIX_PATH="$PREFIX_PATH" \
#  -DCMAKE_CROSSCOMPILING=TRUE \
#  -DCMAKE_SYSROOT="$LFS" \
#  -DCMAKE_INSTALL_PREFIX="$INSTALL_PREFIX" \
#  -DCMAKE_C_COMPILER="$HOST_CLANG" \
#  -DCMAKE_CXX_COMPILER="$HOST_CLANGXX" \
#  -DCMAKE_ASM_COMPILER="$HOST_CLANG" \
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
#  -DSWIFT_INCLUDE_TESTS=TRUE \
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
#  -DCMAKE_C_FLAGS="-gcc-toolchain $CROSS_TOOLCHAIN_DIR -Wno-c++11-narrowing -target ${TRIPLE} $INCLUDE_FLAGS -fno-use-cxa-atexit -fPIC $BINARY_FLAGS" \
#  -DCMAKE_CXX_FLAGS="-gcc-toolchain $CROSS_TOOLCHAIN_DIR -Wno-c++11-narrowing -target ${TRIPLE} $INCLUDE_FLAGS -fno-use-cxa-atexit -fPIC $BINARY_FLAGS" \
#  -DCMAKE_EXE_LINKER_FLAGS="$LINK_FLAGS -gcc-toolchain $CROSS_TOOLCHAIN_DIR -fno-use-cxa-atexit -luuid -lpthread -fvisibility=protected -Bsymbolic" \
#  -DCMAKE_SHARED_LINKER_FLAGS="$LINK_FLAGS -gcc-toolchain $CROSS_TOOLCHAIN_DIR -fno-use-cxa-atexit -luuid -lpthread -fvisibility=protected -Bsymbolic" \
#  -DSWIFT_ENABLE_GOLD_LINKER=TRUE \
#  -DSWIFT_ENABLE_LLD_LINKER=FALSE \
#  -DSWIFT_NATIVE_SWIFT_TOOLS_PATH="/usr/local/var/swiftenv/shims" \
#  -DLLVM_TABLEGEN_EXE=$LLVM_HOST_BUILD_DIR/bin/llvm-tblgen \
#  -DSWIFT_STDLIB_BUILD_TYPE="MinSizeRel" \
#  -DSWIFT_SDK_LINUX_ARCH_${ARCH}_PATH="$LFS" \
#  $SRC_DIR/swift
#cd $SRC_DIR
#cmake --build $SWIFT_BUILD_DIR
#touch $SWIFT_BUILD_DIR/lib/swift/linux/i686/StdlibUnicodeUnittest.swiftmodule
#touch $SWIFT_BUILD_DIR/lib/swift/linux/i686/StdlibUnicodeUnittest.swiftdoc
#touch $SWIFT_BUILD_DIR/lib/swift/linux/i686/StdlibUnicodeUnittest.swiftinterface
#touch $SWIFT_BUILD_DIR/lib/swift/linux/libswiftStdlibUnicodeUnittest.so
#touch $SWIFT_BUILD_DIR/lib/swift/linux/i686/StdlibCollectionUnittest.swiftmodule
#touch $SWIFT_BUILD_DIR/lib/swift/linux/i686/StdlibCollectionUnittest.swiftdoc
#touch $SWIFT_BUILD_DIR/lib/swift/linux/i686/StdlibCollectionUnittest.swiftinterface
#touch $SWIFT_BUILD_DIR/lib/swift/linux/libswiftStdlibCollectionUnittest.so

#cd $WD
#echo "Installing..."
#mkdir -p $INSTALL_PREFIX
#cd $CMARK_BUILD_DIR && ninja install
#cd $LLVM_BUILD_DIR && ninja install
#cd $SWIFT_BUILD_DIR && ninja install

#COMMAND="/usr/local/var/swiftenv/versions/5.0/usr/bin/clang -o hello main.o ${LINK_FLAGS} -L$INSTALL_PREFIX/lib/swift/linux -lswiftCore -lswiftSwiftOnoneSupport -target $TRIPLE"
#echo "$COMMAND"
#$COMMAND
rm -r $WD/main
mkdir -p $WD/main
cd $WD/main
echo "print(\"Hello World\")" > main.swift
#$HOST_SWIFT package init --type executable
SWIFT_INCLUDE_FLAGS=`echo "$INCLUDE_FLAGS" | sed 's/^\|\s/ -Xcc /g'`
SWIFT_LD_FLAGS=`echo "$LINK_FLAGS" | sed 's/^\|\s+/ -Xlinker /g'`
COMMAND="swiftc -o main.o -c main.swift -target $TRIPLE -sdk $INSTALL_PREFIX $SWIFT_LD_FLAGS $SWIFT_INCLUDE_FLAGS"
echo "$COMMAND"
$COMMAND

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
#  -DLLVM_TABLEGEN_EXE=$LLVM_HOST_BUILD_DIR/bin/llvm-tblgen \
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
#  -DLLVM_TABLEGEN_EXE=$LLVM_HOST_BUILD_DIR/bin/llvm-tblgen \
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
#  -DLLVM_TABLEGEN_EXE=$LLVM_HOST_BUILD_DIR/bin/llvm-tblgen \
#  -DSWIFT_STDLIB_BUILD_TYPE="MinSizeRel" \
#  -DSWIFT_SDK_LINUX_ARCH_${ARCH}_PATH="$LFS" \
#  $SRC_DIR/swift-corelibs-foundation
#cd $SRC_DIR
#cmake --build $FOUNDATION_BUILD_DIR
#cd $FOUNDATION_BUILD_DIR && ninja install
