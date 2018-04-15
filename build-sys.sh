#!/usr/bin/env bash
set -e

# Set up Variables
source setup.sh
source versions.sh

# Set Up Environment
LC_ALL=POSIX
LFS_TGT=$(uname -m)-lfs-linux-gnu
PATH=/$LFS/bin:/bin:/usr/bin
export LFS LC_ALL LFS_TGT PATH

# Set Up Folders
rm -rf $LFS
mkdir -p $LFS/$LFS
rm -r $LFS/$LFS
ln -s $LFS $LFS/$LFS
cd $SRC_DIR

# Build the system.
# binutils - FirstPass
rm -rf binutils-$GCC_VERSION
tar -xvf binutils-$BINUTILS_VERSION.tar.gz
rm -rf $SRC_DIR/build-binutils
mkdir $SRC_DIR/build-binutils
cd $SRC_DIR/build-binutils
../binutils-$BINUTILS_VERSION/configure --prefix=$LFS --with-sysroot=$LFS --with-lib-path=$LFS/lib --target=$LFS_TGT --disable-nls --disable-werror
make
make install
cd $SRC_DIR

# GCC - First Pass
rm -rf gcc-$GCC_VERSION
tar -xvf gcc-$GCC_VERSION.tar.gz
cd $SRC_DIR/gcc-$GCC_VERSION
#./contrib/download_prerequisites
for file in \
 $(find gcc/config -name linux64.h -o -name linux.h -o -name sysv4.h)
do
 cp -uv $file{,.orig}
 sed -e 's@/lib\(64\)\?\(32\)\?/ld@/tools&@g' \
 -e 's@/usr@/tools@g' $file.orig > $file
 echo '
#undef STANDARD_STARTFILE_PREFIX_1
#undef STANDARD_STARTFILE_PREFIX_2
#define STANDARD_STARTFILE_PREFIX_1 "/tools/lib/"
#define STANDARD_STARTFILE_PREFIX_2 ""' >> $file
 touch $file.orig
done
sed -i '/k prot/agcc_cv_libc_provides_ssp=yes' gcc/configure
sed -i 's/if \((code.*))\)/if (\1 \&\& \!DEBUG_INSN_P (insn))/' gcc/sched-deps.c
cd $SRC_DIR
rm -rf $SRC_DIR/build-gcc
mkdir $SRC_DIR/build-gcc
cd $SRC_DIR/build-gcc
../gcc-$GCC_VERSION/configure \
 --target=$LFS_TGT \
 --prefix=$LFS \
 --with-sysroot=$LFS \
 --with-newlib \
 --without-headers \
 --with-local-prefix=$LFS \
 --with-native-system-header-dir=$LFS/include \
 --disable-nls \
 --disable-shared \
 --disable-multilib \
 --disable-decimal-float \
 --disable-threads \
 --disable-libatomic \
 --disable-libgomp \
 --disable-libitm \
 --disable-libquadmath \
 --disable-libsanitizer \
 --disable-libssp \
 --disable-libvtv \
 --disable-libcilkrts \
 --disable-libstdc++-v3 \
 --enable-languages=c,c++
make
make install
cd $SRC_DIR

# Linux
rm -rf linux-$LINUX_VERSION
tar -xvf linux-$LINUX_VERSION.tar.xz
cd $SRC_DIR/linux-$LINUX_VERSION
make mrproper
make INSTALL_HDR_PATH=dest headers_install
cp -rv dest/include/* $LFS/include
cd $SRC_DIR

# Glibc
rm -rf glibc-$GLIBC_VERSION
tar -xvf glibc-$GLIBC_VERSION.tar.gz
rm -rf $SRC_DIR/build-glibc
mkdir $SRC_DIR/build-glibc
cd $SRC_DIR/build-glibc
../glibc-$GLIBC_VERSION/configure \
 --prefix=$LFS \
 --host=$LFS_TGT \
 --build=$(../glibc-$GLIBC_VERSION/scripts/config.guess) \
 --disable-profile \
 --enable-kernel=2.6.32 \
 --with-headers=$LFS/include \
 libc_cv_forced_unwind=yes \
 libc_cv_ctors_header=yes \
 libc_cv_c_cleanup=yes
make
make install
cd $SRC_DIR

# Libstdc++
rm -rf $SRC_DIR/build-gcc
mkdir $SRC_DIR/build-gcc
cd $SRC_DIR/build-gcc
../gcc-$GCC_VERSION/libstdc++-v3/configure \
 --host=$LFS_TGT \
 --prefix=$LFS \
 --disable-multilib \
 --disable-shared \
 --disable-nls \
 --disable-libstdcxx-threads \
 --disable-libstdcxx-pch \
 --with-gxx-include-dir=$LFS/$LFS_TGT/include/c++/$GCC_VERSION
make
make install
cd $SRC_DIR

# binutils - Second Pass
rm -rf binutils-$BINUTILS_VERSION
tar -xvf binutils-$BINUTILS_VERSION.tar.gz
rm -rf $SRC_DIR/build-binutils
mkdir $SRC_DIR/build-binutils
cd $SRC_DIR/build-binutils
CC=$LFS_TGT-gcc \
AR=$LFS_TGT-ar \
RANLIB=$LFS_TGT-ranlib \
../binutils-$BINUTILS_VERSION/configure \
 --prefix=$LFS \
 --disable-nls \
 --disable-werror \
 --with-lib-path=$LFS/lib \
 --with-sysroot
make
make install
make -C ld clean
make -C ld LIB_PATH=/usr/lib:/lib
cp -v ld/ld-new $LFS/bin
cd $SRC_DIR

 # GCC - Second Pass
rm -rf gcc-$GCC_VERSION
tar -xvf gcc-$GCC_VERSION.tar.gz
cd $SRC_DIR/gcc-$GCC_VERSION
cat gcc/limitx.h gcc/glimits.h gcc/limity.h > \
 `dirname $($LFS_TGT-gcc -print-libgcc-file-name)`/include-fixed/limits.h
for file in \
 $(find gcc/config -name linux64.h -o -name linux.h -o -name sysv4.h)
do
 cp -uv $file{,.orig}
 sed -e 's@/lib\(64\)\?\(32\)\?/ld@/tools&@g' \
 -e 's@/usr@/tools@g' $file.orig > $file
 echo '
#undef STANDARD_STARTFILE_PREFIX_1
#undef STANDARD_STARTFILE_PREFIX_2
#define STANDARD_STARTFILE_PREFIX_1 "/tools/lib/"
#define STANDARD_STARTFILE_PREFIX_2 ""' >> $file
 touch $file.orig
done
./contrib/download_prerequisites
sed -i 's/if \((code.*))\)/if (\1 \&\& \!DEBUG_INSN_P (insn))/' gcc/sched-deps.c
cd $SRC_DIR
rm -rf $SRC_DIR/build-gcc
mkdir $SRC_DIR/build-gcc
cd $SRC_DIR/build-gcc
CC=$LFS_TGT-gcc \
CXX=$LFS_TGT-g++ \
AR=$LFS_TGT-ar \
RANLIB=$LFS_TGT-ranlib \
../gcc-4.9.1/configure \
 --prefix=$LFS \
 --with-local-prefix=$LFS \
 --with-native-system-header-dir=$LFS/include \
 --enable-languages=c,c++ \
 --disable-libstdcxx-pch \
 --disable-multilib \
 --disable-bootstrap \
 --disable-libgomp
 make
 make install
 ln -sv gcc $LFS/bin/cc
 cd $SRC_DIR
