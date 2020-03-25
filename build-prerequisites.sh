#!/usr/bin/env bash
set -e

# Set up Variables
source setup.sh
source versions.sh

# Set Up Environment
set +h
umask 022
PATH="$LFS/bin:/bin:/usr/bin"
LIBRARY_PATH="$LFS/usr/local/lib:$LFS/usr/lib:$LFS/lib"
CPATH="$LFS/usr/local/include:$LFS/usr/include:$LFS/include:$LFS/usr/include/ncurses"
GCC="$LFS/bin/gcc"
GXX="$LFS/bin/g++"
export PATH LIBRARY_PATH CPATH

INSTALL_PREFIX=$LFS/usr

# Zlib
compile "zlib" "$ZLIB_VERSION"

# libiconv
compile "libiconv" "$LIBICONV_VERSION"

# ncurses
compile "ncurses" "$NCURSES_VERSION" "" "$SRC_DIR/ncurses-$NCURSES_VERSION/configure --prefix=$INSTALL_PREFIX --with-shared --enable-pc-files"

# icu4c
function icu_untar() {
	tar -xzvf icu4c-$ICU4C_VERSION-src.tgz
	mv icu icu4c-$ICU4C_VERSION
}
function icu_configure() {
	cp -r $SRC_DIR/icu4c-$ICU4C_VERSION/* .
	cd source && ./configure --prefix=$INSTALL_PREFIX
}
function icu_build() {
	cd source
	make
}
function icu_install() {
	cd source
	sudo make install
}
compile "icu4c" "$ICU4C_VERSION" icu_untar icu_configure icu_build icu_install

# xz
compile "xz" "$XZ_VERSION" "tar -xvf xz-$XZ_VERSION.tar.xz"

# libxml2
compile "libxml2" "$LIBXML2_VERSION"

# libuuid
compile "libuuid" "$LIBUUID_VERSION"

# bash
compile "bash" "$BASH_VERSION"

# coreutils
function coreutils_configure() {
	FORCE_UNSAFE_CONFIGURE=1 $SRC_DIR/coreutils-$COREUTILS_VERSION/configure --prefix=$INSTALL_PREFIX
}
compile "coreutils" "$COREUTILS_VERSION" "tar -xvf coreutils-$COREUTILS_VERSION.tar.xz" coreutils_configure

# sed
compile "sed" "$SED_VERSION" "tar -xvf sed-$SED_VERSION.tar.bz2"

# grep
compile "grep" "$GREP_VERSION" "tar -xvf grep-$GREP_VERSION.tar.xz"

# gawk
compile "gawk" "$GAWK_VERSION" "tar -xvf gawk-$GAWK_VERSION.tar.xz"

# GNU make
compile "make" "$MAKE_VERSION" "tar -xvf make-$MAKE_VERSION.tar.bz2"

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

# Openssl
#rm -rf openssl-$OPENSSL_VERSION
#tar -xzvf openssl-$OPENSSL_VERSION.tar.gz
#rm -rf $LFS/op

# Copy scripts into $LFS
cp setup.sh $LFS
cp versions.sh $LFS
cp build-chroot.sh $LFS
cp build-swift.sh $LFS

function finalise() {
	sudo ln -s $LFS/usr/bin/bash $LFS/bin/sh
	sudo mkdir $LFS/dev
	sudo mknod -m 600 $LFS/dev/console c 5 1
	sudo mknod -m 666 $LFS/dev/null c 1 3
	sudo mkdir $LFS/tmp
}
check $BUILD_DIR/.finalise finalise

#chroot $LFS $LFS/usr/bin/env -i HOME=/root TERM="$TERM" PS1='\u:\w\$ ' PATH="$LFS/usr/local/bin:$LFS/usr/bin:$LFS/bin" CPATH="$LFS/usr/local/include:$LFS/usr/include:/$LFS/include" LIBRARY_PATH="$LFS/usr/local/lib:$LFS/usr/lib:$LFS/lib" LD_LIBRARY_PATH="$LFS/usr/local/lib:$LFS/usr/lib:$LFS/lib" /build-chroot.sh
