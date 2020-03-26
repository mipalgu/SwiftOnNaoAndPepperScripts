#!/usr/bin/env bash
set -e

source setup.sh

function xbinutils() {
	function xbinutils_configure() {
		$SRC_DIR/binutils-$BINUTILS_VERSION/configure --prefix="$CROSS_DIR" \
			--target=${TRIPLE} \
			--enable-gold=yes \
			--enable-multilib=yes \
			--with-sysroot="$LFS"
	}
	rm -rf $BUILD_DIR/binutils
	compile "binutils" "$BINUTILS_VERSION"
}
check $BUILD_DIR/.xbinutils xbinutils

function xgcc() {
	function gcc_untar() {
		tar -xzvf gcc-$GCC_VERSION.tar.gz
		cd gcc-$GCC_VERSION
		./contrib/download_prerequisites
		cd $SRC_DIR
	}
	function xgcc_configure() {
		cd $SRC_DIR/gcc-$GCC_VERSION
		cat gcc/limitx.h gcc/glimits.h gcc/limity.h > \
		 `dirname $($LFS_TGT-gcc -print-libgcc-file-name)`/include-fixed/limits.h
		for file in \
		 $(find gcc/config -name linux64.h -o -name linux.h -o -name sysv4.h)
		do
		 if [ -f $file.bak ]
		 then
		  cp $file.bak $file
		 else
		  cp $file $file.bak
		 fi
		done
		cd $BUILD_DIR/gcc
		$SRC_DIR/gcc-$GCC_VERSION/configure \
			--prefix=$CROSS_DIR \
			--with-local-prefix=$LFS/usr/local \
			--with-native-system-header-dir=$LFS/include \
			--target=${TRIPLE} \
			--with-sysroot="$LFS"
			--enable-languages=c,c++ \
			--disable-libstdcxx-pch \
			--disable-multilib \
			--disable-bootstrap \
			--disable-libgomp
	}
	rm -rf $BUILD_DIR/gcc
	compile "gcc" "$GCC_VERSION gcc_untar
}
check $BUILD_DIR/.xgcc xgcc
