#!/usr/bin/env bash
set -e

source versions.sh

#wget https://ftp.gnu.org/gnu/binutils/binutils-$BINUTILS_VERSION.tar.gz
#wget https://ftp.gnu.org/gnu/gcc/gcc-$GCC_VERSION/gcc-$GCC_VERSION.tar.gz
#wget https://ftp.gnu.org/gnu/glibc/glibc-$GLIBC_VERSION.tar.gz
#wget https://www.kernel.org/pub/linux/kernel/v$LINUX_MAJOR_VERSION.x/linux-$LINUX_VERSION.tar.xz

#wget https://zlib.net/zlib-$ZLIB_VERSION.tar.gz
#wget https://ftp.gnu.org/gnu/ncurses/ncurses-$NCURSES_VERSION.tar.gz
#wget http://download.icu-project.org/files/icu4c/$ICU4C_MAJOR_VERSION.$ICU4C_MINOR_VERSION/icu4c-$ICU4C_VERSION-src.tgz
#wget https://ftp.gnu.org/gnu/libiconv/libiconv-$LIBICONV_VERSION.tar.gz

#wget https://tukaani.org/xz/xz-$XZ_VERSION.tar.xz
#wget https://git.gnome.org/browse/libxml2/tag/?h=v$LIBXML2_VERSION
#wget https://sourceforge.net/projects/libuuid/files/libuuid-$LIBUUID_VERSION.tar.gz/download

#wget https://ftp.gnu.org/gnu/bash/bash-${BASH_VERSION}.tar.gz
wget https://ftp.gnu.org/gnu/coreutils/coreutils-${COREUTILS_VERSION}.tar.xz
wget http://ftp.gnu.org/gnu/make/make-$MAKE_VERSION.tar.bz2
wget http://ftp.gnu.org/gnu/sed/sed-$SED_VERSION.tar.bz2
wget http://ftp.gnu.org/gnu/gawk/gawk-$GAWK_VERSION.tar.xz
