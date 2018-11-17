#!/usr/bin/env bash
set -e

# Set up Variables
source setup.sh
source versions.sh

# Set Up Environment
CMAKE_BUILD_TYPE=Release
INSTALL_PREFIX=$LFS/home/nao/swift-tc
ARCH=i686
VENDOR=aldebaran
OS=linux
TRIPLE=$ARCH-$VENDOR-$OS-gnu
PLATFORM=$ARCH-$OS
HOST_CLANG=/usr/bin/clang
HOST_CLANGXX=/usr/bin/clang++
TOOLS_DIRECTORY=/home/user/src/swift-tc/ctc-linux64-atom-2.5.2.74/bin
SYSROOT_PATH="$INSTALL_PREFIX/bin:$LFS/usr/local/bin:$LFS/usr/bin:$LFS/bin"
SYSROOT_LIBRARY_PATH="$INSTALL_PREFIX/lib:$LFS/usr/local/lib:$LFS/usr/lib:$LFS/usr/lib32:$LFS/lib:$LFS/lib32:$LFS:$LFS/lib/gcc/${TRIPLE}/4.9.2"
SYSROOT_LD_LIBRARY_PATH="$LIBRARY_PATH"
SYSROOT_CPATH="$INSTALL_PREFIX/include:$LFS/usr/local/include:$LFS/usr/include:$LFS/include:$LFS/include/${TRIPLE}:$LFS/usr/lib"
export LANG=/usr/lib/locale/en_US
BINARY_FLAGS=`echo "$SYSROOT_PATH:$SYSROOT_LIBRARY_PATH:$SYSROOT_CPATH" | sed 's/^\|:/ -B/g'`
INCLUDE_FLAGS=`echo $SYSROOT_CPATH | sed 's/^\|:/ -I/g'`
LINK_FLAGS=`echo $SYSROOT_LIBRARY_PATH | sed 's/^\|:/ -L/g'`

# Zlib
#rm -rf zlib-$ZLIB_VERSION
#tar -xzvf zlib-$ZLIB_VERSION.tar.gz
#rm -rf $SRC_DIR/build-zlib
#mkdir $SRC_DIR/build-zlib
#cd $SRC_DIR/build-zlib
#ARCH="${ARCH}" AS=$AS CC=$GCC CXX=$GXX ../zlib-$ZLIB_VERSION/configure --prefix=$INSTALL_PREFIX
#make
#make install
#cd $SRC_DIR

# libiconv
#rm -rf libiconv-$LIBICONV_VERSION
#tar -xzvf libiconv-$LIBICONV_VERSION.tar.gz
#rm -rf $SRC_DIR/build-libiconv
#mkdir $SRC_DIR/build-libiconv
#cd $SRC_DIR/build-libiconv
#AS=$AS CC=$GCC CXX=$GXX ../libiconv-$LIBICONV_VERSION/configure --prefix=$INSTALL_PREFIX
#make
#make install
#cd $SRC_DIR

# icu-le-hb
#rm -rf icu-le-hb-1.0.3
#tar -xzvf icu-le-hb-1.0.3.tar.gz
#cd icu-le-hb-1.0.3
#AS=$AS CC=$GCC CXX=$GXX ./autogen.sh --prefix=$INSTALL_PREFIX
#make
#make install
#cd $SRC_DIR

# ncurses
#rm -rf ncurses-$NCURSES_VERSION
#tar -xzvf ncurses-$NCURSES_VERSION.tar.gz
#rm -rf $SRC_DIR/build-ncurses
#mkdir $SRC_DIR/build-ncurses
#cd $SRC_DIR/build-ncurses
#AS=$AS CC=$GCC CXX=$GXX ../ncurses-$NCURSES_VERSION/configure \
# --prefix=$INSTALL_PREFIX             \
# --with-shared                        \
# --enable-pc-files
#make
#make install
#cd $SRC_DIR

# xz
#rm -rf xz-$XZ_VERSION
#tar -xvf xz-$XZ_VERSION.tar.xz
#rm -rf $SRC_DIR/build-xz
#mkdir $SRC_DIR/build-xz
#cd $SRC_DIR/build-xz
#AS=$AS CC=$GCC CXX=$GXX ../xz-$XZ_VERSION/configure --prefix=$INSTALL_PREFIX
#make
#make install
#cd $SRC_DIR

# Python
#rm -rf Python-$PYTHON_VERSION
#tar -xvf Python-$PYTHON_VERSION.tar.xz
#rm -rf $SRC_DIR/build-python
#mkdir $SRC_DIR/build-python
#cd $SRC_DIR/build-python
#echo "ac_cv_file__dev_ptmx=no" > config.site
#echo "ac_cv_file__dev_ptc=no" >> config.site
#PYTHON="$LFS/usr/local/bin/python" CONFIG_SITE=config.site AS=$AS CC=$GCC CXX=$GXX ../Python-$PYTHON_VERSION/configure --prefix=$INSTALL_PREFIX --enable-optimizations --host="${TRIPLE}" --build="${ARCH}" --disable-ipv6 --with-binascii --with-zlib
#make CFLAGS="-g0 -Os -s -I${LFS}/usr/local/include -fdata-sections -ffunction-sections" LDFLAGS="-L${LFS}/usr/lib -L${LFS}/usr/local/lib"
#make install
#cd $SRC_DIR

# libxml2
#rm -rf libxml2-$LIBXML2_VERSION
#tar -xvf libxml2-$LIBXML2_VERSION.tar.xz
#cd $SRC_DIR/libxml2-$LIBXML2_VERSION
#AS=$AS CC=$GCC CXX=$GXX CFLAGS="-march=i686" CPATH="$LFS/usr/local/include" ./autogen.sh --prefix=$INSTALL_PREFIX --host="${TRIPLE}" --build="${ARCH}"
#make
#make install
#cd $SRC_DIR

# libuuid
#rm -rf libuuid-$LIBUUID_VERSION
#tar -xzvf libuuid-$LIBUUID_VERSION.tar.gz
#rm -rf $SRC_DIR/build-libuuid
#mkdir $SRC_DIR/build-libuuid
#cd $SRC_DIR/build-libuuid
#AS=$AS CC=$GCC CXX=$GXX ../libuuid-$LIBUUID_VERSION/configure --prefix=$INSTALL_PREFIX
#make
#make install
#cd $SRC_DIR

# icu4c
rm -rf icu4c-$ICU4C_VERSION
tar -xzvf icu4c-$ICU4C_VERSION-src.tgz
cd icu/source
LIBRARY_PATH="$SYSROOT_LIBRARY_PATH" CPATH="$SYSROOT_CPATH" PATH="${SYSROOT_PATH}:${PATH}" CC="$HOST_CLANG" CXX="$HOST_CLANGXX" LD="/usr/bin/ld" RANLIB="/usr/bin/ranlib" READELF="/usr/bin/readelf" CFLAGS="-target ${TRIPLE} --sysroot=\"$LFS\" $INCLUDE_FLAGS $BINARY_FLAGS" CXXFLAGS="-target ${TRIPLE} --sysroot=\"$LFS\" $INCLUDE_FLAGS $BINARY_FLAGS" LDFLAGS="-v $LINK_FLAGS" ./configure --disable-layout --disable-layoutex  --prefix=$INSTALL_PREFIX --host="${TRIPLE}" --with-build-sysroot="$LFS"
make
make install
cd $SRC_DIR

# bash
#rm -rf bash-$BASH_VERSION
#tar -xzvf bash-$BASH_VERSION.tar.gz
#rm -rf $SRC_DIR/build-bash
#mkdir $SRC_DIR/build-bash
#cd $SRC_DIR/build-bash
#../bash-$BASH_VERSION/configure --prefix=$INSTALL_PREFIX
#make
#make install
#cd $SRC_DIR

# coreutils
#rm -rf coreutils-$COREUTILS_VERSION
#tar -xvf coreutils-$COREUTILS_VERSION.tar.xz
#rm -rf $SRC_DIR/build-coreutils
#mkdir $SRC_DIR/build-coreutils
#cd $SRC_DIR/build-coreutils
#FORCE_UNSAFE_CONFIGURE=1 ../coreutils-$COREUTILS_VERSION/configure --prefix=$INSTALL_PREFIX
#make
#make install
#cd $SRC_DIR

# sed
#rm -rf sed-$SED_VERSION
#tar -xvf sed-$SED_VERSION.tar.bz2
#rm -rf $SRC_DIR/build-sed
#mkdir $SRC_DIR/build-sed
#cd $SRC_DIR/build-sed
#../sed-$SED_VERSION/configure --prefix=$INSTALL_PREFIX
#make
#make install
#cd $SRC_DIR

# grep
#rm -rf grep-$GREP_VERSION
#tar -xvf grep-$GREP_VERSION.tar.xz
#rm -rf $SRC_DIR/build-grep
#mkdir $SRC_DIR/build-grep
#cd $SRC_DIR/build-grep
#../grep-$GREP_VERSION/configure --prefix=$INSTALL_PREFIX
#make
#make install
#cd $SRC_DIR

# gawk
#rm -rf gawk-$GAWK_VERSION
#tar -xvf gawk-$GAWK_VERSION.tar.xz
#rm -rf $SRC_DIR/build-gawk
#mkdir $SRC_DIR/build-gawk
#cd $SRC_DIR/build-gawk
#../gawk-$GAWK_VERSION/configure --prefix=$INSTALL_PREFIX
#make
#make install
#cd $SRC_DIR

# GNU make
#rm -rf make-$MAKE_VERSION
#tar -xvf make-$MAKE_VERSION.tar.bz2
#rm -rf $SRC_DIR/build-make
#mkdir $SRC_DIR/build-make
#cd $SRC_DIR/build-make
#../make-$MAKE_VERSION/configure --prefix=$INSTALL_PREFIX
#make
#make install
#cd $SRC_DIR

# Python
#rm -rf Python-$PYTHON_VERSION
#tar -xvf Python-$PYTHON_VERSION.tar.xz
#rm -rf $LFS/Python-$PYTHON_VERSION
#mv Python-$PYTHON_VERSION $LFS/Python-$PYTHON_VERSION
#rm -rf $LFS/build-python
#mkdir $LFS/build-python

# ninja
#rm -rf ninja-$NINJA_VERSION
#tar -xvf ninja-$NINJA_VERSION.tar.gz
#rm -rf $LFS/ninja-$NINJA_VERSION
#mv ninja-$NINJA_VERSION $LFS/ninja-$NINJA_VERSION
#rm -rf $LFS/build-ninja
#mkdir $LFS/build-ninja

# CMake
#rm -rf cmake-$CMAKE_VERSION
#tar -xzvf cmake-$CMAKE_VERSION.tar.gz
#rm -rf $LFS/cmake-$CMAKE_VERSION
#mv cmake-$CMAKE_VERSION $LFS/cmake-$CMAKE_VERSION
#rm -rf $LFS/build-cmake
#mkdir $LFS/build-cmake

# Copy scripts into $LFS
#cp setup.sh $LFS
#cp versions.sh $LFS
#cp build-chroot.sh $LFS
#cp build-swift.sh $LFS

#ln -s $LFS/usr/bin/bash $LFS/bin/sh
#mkdir $LFS/dev
#mknod -m 600 $LFS/dev/console c 5 1
#mknod -m 666 $LFS/dev/null c 1 3
#mkdir $LFS/tmp

#chroot $LFS $LFS/usr/bin/env -i HOME=/root TERM="$TERM" PS1='\u:\w\$ ' PATH="$LFS/usr/local/bin:$LFS/usr/bin:$LFS/bin" CPATH="$LFS/usr/local/include:$LFS/usr/include:/$LFS/include" LIBRARY_PATH="$LFS/usr/local/lib:$LFS/usr/lib:$LFS/lib" LD_LIBRARY_PATH="$LFS/usr/local/lib:$LFS/usr/lib:$LFS/lib" /build-chroot.sh
