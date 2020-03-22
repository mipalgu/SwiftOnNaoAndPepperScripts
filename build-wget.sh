#!/usr/bin/env bash
set -e

source setup.sh
source download.sh

OPENSSL_VERSION=1.1.1e
NETTLE_VERSION=3.5
WGET_VERSION=1.20
GNUTLS_VERSION=3.1.5

INSTALL_PREFIX=/usr/local

cd $SRC_DIR

download https://www.openssl.org/source/openssl-$OPENSSL_VERSION.tar.gz
download ftp://ftp.gnu.org/gnu/nettle/nettle-$NETTLE_VERSION.tar.gz
download ftp://ftp.gnu.org/gnu/gnutls/gnutls-$GNUTLS_VERSION.tar.xz
download ftp://ftp.gnu.org/gnu/wget/wget-$WGET_VERSION.tar.gz

cd $WD

compile "openssl" "$OPENSSL_VERSION" "" "$SRC_DIR/openssl-$OPENSSL_VERSION/config --prefix=$INSTALL_PREFIX"
compile "nettle" "$NETTLE_VERSION" "" "$SRC_DIR/nettle-$NETTLE_VERSION/configure --prefix=$INSTALL_PREFIX --disable-static"
compile "gnutls" "$GNUTLS_VERSION" "tar -xvf gnutls-$GNUTLS_VERSION.tar.xz"
compile "wget" "$WGET_VERSION"
