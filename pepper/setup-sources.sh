#!/usr/bin/env bash
set -e

source setup.sh

if [ ! -f "binutils-$BINUTILS_VERSION.tar.gz" ]
then
    wget https://ftp.gnu.org/gnu/binutils/binutils-$BINUTILS_VERSION.tar.gz
    tar -xzf binutils-$BINUTILS_VERSION.tar.gz
fi

if [ ! -f "zlib-$ZLIB_VERSION.tar.gz" ]
then
    wget https://zlib.net/zlib-$ZLIB_VERSION.tar.gz
    tar -xzf zlib-$ZLIB_VERSION.tar.gz
fi

if [ ! -f "icu4c-$ICU4C_VERSION.tar.gz" ]
then
    wget http://download.icu-project.org/files/icu4c/$ICU4C_MAJOR_VERSION.$ICU4C_MINOR_VERSION/icu4c-$ICU4C_VERSION-src.tgz
    mv icu4c-$ICU4C_VERSION-src.tgz icu4c-$ICU4C_VERSION.tar.gz
    tar -xzf icu4c-$ICU4C_VERSION.tar.gz
    mv icu icu-$ICU4C_VERSION
fi

if [ ! -f "xz-$XZ_VERSION.tar.gz" ]
then
    wget https://tukaani.org/xz/xz-$XZ_VERSION.tar.gz
    tar -xzf xz-$XZ_VERSION.tar.gz
fi

if [ ! -f "libxml2-$LIBXML2_VERSION.tar.gz" ]
then
    wget ftp://xmlsoft.org/libxml2/libxml2-$LIBXML2_VERSION.tar.gz
    tar -xzf libxml2-$LIBXML2_VERSION.tar.gz
fi

if [ ! -f "libuuid-$LIBUUID_VERSION.tar.gz" ]
then
    wget https://sourceforge.net/projects/libuuid/files/libuuid-$LIBUUID_VERSION.tar.gz/download
    mv download libuuid-$LIBUUID_VERSION.tar.gz
    tar -xzf libuuid-$LIBUUID_VERSION.tar.gz
fi
