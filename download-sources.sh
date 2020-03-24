#!/usr/bin/env bash
set -e

source setup.sh
source versions.sh
source download.sh

cd $SRC_DIR

download https://ftp.gnu.org/gnu/binutils/binutils-$BINUTILS_VERSION.tar.gz
download https://ftp.gnu.org/gnu/gcc/gcc-$GCC_VERSION/gcc-$GCC_VERSION.tar.gz
download https://ftp.gnu.org/gnu/glibc/glibc-$GLIBC_VERSION.tar.gz
download https://www.kernel.org/pub/linux/kernel/v$LINUX_MAJOR_VERSION.x/linux-$LINUX_VERSION.tar.xz

download https://zlib.net/zlib-$ZLIB_VERSION.tar.gz
download https://ftp.gnu.org/gnu/ncurses/ncurses-$NCURSES_VERSION.tar.gz
download http://download.icu-project.org/files/icu4c/$ICU4C_MAJOR_VERSION.$ICU4C_MINOR_VERSION/icu4c-$ICU4C_VERSION-src.tgz
download https://ftp.gnu.org/gnu/libiconv/libiconv-$LIBICONV_VERSION.tar.gz

download https://tukaani.org/xz/xz-$XZ_VERSION.tar.xz
download ftp://xmlsoft.org/libxml2/libxml2-$LIBXML2_VERSION.tar.gz
download https://sourceforge.net/projects/libuuid/files/libuuid-$LIBUUID_VERSION.tar.gz/download libuuid-$LIBUUID_VERSION.tar.gz

download https://ftp.gnu.org/gnu/bash/bash-${BASH_VERSION}.tar.gz
download https://ftp.gnu.org/gnu/coreutils/coreutils-${COREUTILS_VERSION}.tar.xz
download http://ftp.gnu.org/gnu/make/make-$MAKE_VERSION.tar.bz2
download http://ftp.gnu.org/gnu/sed/sed-$SED_VERSION.tar.bz2
download https://ftp.gnu.org/gnu/grep/grep-$GREP_VERSION.tar.xz
download http://ftp.gnu.org/gnu/gawk/gawk-$GAWK_VERSION.tar.xz
download https://curl.haxx.se/download/curl-$CURL_VERSION.tar.gz
download https://mirrors.edge.kernel.org/pub/software/scm/git/git-$GIT_VERSION.tar.xz

cd $WD
