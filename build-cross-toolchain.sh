#!/usr/bin/env bash
set -e

source setup.sh

function xbinutils() {
	function xbinutils_configure() {
		 $SRC_DIR/binutils-$BINUTILS_VERSION/configure \
			--prefix="$CROSS_DIR" \
			--target=${TRIPLE} \
			--enable-gold=yes \
			--enable-multilib=yes \
			--disable-werror \
			--with-sysroot="$LFS"
	}
	rm -rf $BUILD_DIR/binutils
	compile "binutils" "$BINUTILS_VERSION" "" xbinutils_configure
}
check $BUILD_DIR/.xbinutils xbinutils
