#!/usr/bin/env bash
set -e

# Set up Variables
source setup.sh
source versions.sh

# Set Up Environment
LC_ALL=POSIX
LFS_TGT=$(uname -m)-lfs-linux-gnu
PATH=$LFS/usr/bin:$LFS/bin:/usr/bin:/bin
export LFS LC_ALL LFS_TGT PATH

# Set Up Folders
function setup_folders() {
	sudo rm -rf $LFS
	mkdir -p $LFS/$LFS
	mkdir -p $LFS/include
	sudo rm -r $LFS/$LFS
	filename=`basename $LFS`
	relativePath=`python -c "import os.path; print os.path.relpath('$LFS', '$LFS/$LFS')"`
	ln -s $relativePath/$filename $LFS/$LFS
}
check $BUILD_DIR/.lfs setup_folders

# Build the system.
# binutils - FirstPass
function binutils1() {
	function binutils_configure1() {
		$SRC_DIR/binutils-$BINUTILS_VERSION/configure --prefix=$LFS --with-sysroot=$LFS --with-lib-path=$LFS/lib --target=$LFS_TGT --disable-nls --disable-werror --enable-gold=yes
	}
	rm -rf $BUILD_DIR/binutils
	compile "binutils" "$BINUTILS_VERSION" "" binutils_configure1
}
check $BUILD_DIR/.binutils1 binutils1

# GCC - First Pass
function gcc1() {
	function gcc_untar() {
		tar -xzvf gcc-$GCC_VERSION.tar.gz
		cd gcc-$GCC_VERSION
		./contrib/download_prerequisites
		cd $SRC_DIR
	}
	function gcc_configure() {
		cd $SRC_DIR/gcc-$GCC_VERSION
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
		for file in \
		 $(find gcc/config -name linux64.h -o -name linux.h -o -name sysv4.h)
		do
		 cp -uv $file{,.orig}
		 sed -e "s@/lib\\(64\\)\?\\(32\\)\?/ld@$LFS&@g" \
		 -e "s@/usr@$LFS@g" $file.orig > $file
		 echo "
		#undef STANDARD_STARTFILE_PREFIX_1
		#undef STANDARD_STARTFILE_PREFIX_2
		#define STANDARD_STARTFILE_PREFIX_1 \"$LFS/lib/\"
		#define STANDARD_STARTFILE_PREFIX_2 \"\"" >> $file
		 touch $file.orig
		done
		sed -i '/k prot/agcc_cv_libc_provides_ssp=yes' gcc/configure
		sed -i 's/if \((code.*))\)/if (\1 \&\& \!DEBUG_INSN_P (insn))/' gcc/sched-deps.c
		cd $BUILD_DIR/gcc
		$SRC_DIR/gcc-$GCC_VERSION/configure \
			--target=$LFS_TGT \
			--prefix=$LFS \
			--with-sysroot=$LFS \
			--with-newlib \
			--without-headers \
			--with-local-prefix=$LFS/usr/local \
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
			--disable-libstdc__-v3 \
			--enable-languages=c,c++
	}
	rm -rf $BUILD_DIR/gcc
	compile "gcc" "$GCC_VERSION" gcc_untar gcc_configure
}
check $BUILD_DIR/.gcc1 gcc1

# Linux
function linux() {
	function linux_configure() {
		cp -R $SRC_DIR/linux-$LINUX_VERSION/* .
	}
	function linux_build() {
		make mrproper
	}
	function linux_install() {
		sudo make INSTALL_HDR_PATH=dest headers_install
		sudo cp -rv dest/include/* $LFS/include
	}
	compile "linux" "$LINUX_VERSION" "tar -xvf linux-$LINUX_VERSION.tar.xz" linux_configure linux_build linux_install
}
check "$BUILD_DIR/.linux" linux

# Glibc
function glibc() {
	glibc_configure() {
		CC=$LFS_TGT-gcc \
		AR=$LFS_TGT-ar \
		RANLIB=$LFS_TGT-ranlib \
		$SRC_DIR/glibc-$GLIBC_VERSION/configure \
			--prefix=$LFS \
			--host=$LFS_TGT \
			--build=$(../glibc-$GLIBC_VERSION/scripts/config.guess) \
			--disable-profile \
			--enable-kernel=2.6.32 \
			--enable-obsolete-rpc \
			--with-headers=$LFS/include \
			libc_cv_forced_unwind=yes \
			libc_cv_ctors_header=yes \
			libc_cv_c_cleanup=yes
	}
	compile "glibc" "$GLIBC_VERSION" "" glibc_configure
}
check $BUILD_DIR/.glibc glibc

# Libstdc++
function libstdcpp() {
	function libstdcpp_untar() {
		mkdir -p $SRC_DIR/libstdc++-$GCC_VERSION
	}
	function libstdcpp_configure() {
		CC=$LFS_TGT-gcc \
		AR=$LFS_TGT-ar \
		RANLIB=$LFS/bin/$LFS_TGT-ranlib \
		$SRC_DIR/gcc-$GCC_VERSION/libstdc++-v3/configure \
			--host=$LFS_TGT \
			--prefix=$LFS \
			--disable-multilib \
			--disable-shared \
			--disable-nls \
			--disable-libstdcxx-threads \
			--disable-libstdcxx-pch \
			--with-gxx-include-dir=$LFS/$LFS_TGT/include/c++/$GCC_VERSION
	}
	compile "libstdc++" "$GCC_VERSION" libstdcpp_untar libstdcpp_configure
}
check $BUILD_DIR/.libstdcpp libstdcpp

# binutils - Second Pass
function binutils2() {
	function binutils_configure2() {
		CC=$LFS_TGT-gcc \
		AR=$LFS_TGT-ar \
		RANLIB=$LFS/bin/$LFS_TGT-ranlib \
		$SRC_DIR/binutils-$BINUTILS_VERSION/configure \
			--prefix=$LFS \
			--disable-nls \
			--disable-werror \
			--enable-gold=yes \
			--with-lib-path=$LFS/lib \
			--with-sysroot
	}
	function binutils_install2() {
		sudo make install
		make -C ld clean
		make -C ld LIB_PATH=/usr/lib:/lib
		sudo cp -v ld/ld-new $LFS/bin
	}
	rm -rf $BUILD_DIR/binutils
	compile "binutils" "$BINUTILS_VERSION" "" binutils_configure2 "" binutils_install2
}
check $BUILD_DIR/.binutils2 binutils2

# GCC - Second Pass
function gcc2() {
	function gcc_untar2() {
		tar -xvf gcc-$GCC_VERSION.tar.gz
		cd $SRC_DIR/gcc-$GCC_VERSION
		./contrib/download_prerequisites
		cd $SRC_DIR
	}
	function gcc_configure2() {
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
		for file in \
		 $(find gcc/config -name linux64.h -o -name linux.h -o -name sysv4.h)
		do
		 cp -uv $file{,.orig}
		 sed -e "s@/lib\\(64\\)\?\\(32\\)\?/ld@$LFS&@g" \
		 -e "s@/usr@/$LFS@g" $file.orig > $file
		 echo "
		#undef STANDARD_STARTFILE_PREFIX_1
		#undef STANDARD_STARTFILE_PREFIX_2
		#define STANDARD_STARTFILE_PREFIX_1 \"$LFS/lib/\"
		#define STANDARD_STARTFILE_PREFIX_2 \"\"" >> $file
		 touch $file.orig
		done
		sed -i 's/if \((code.*))\)/if (\1 \&\& \!DEBUG_INSN_P (insn))/' gcc/sched-deps.c
		cd $BUILD_DIR/gcc
		CC=$LFS_TGT-gcc \
		CXX=$LFS_TGT-g++ \
		AR=$LFS_TGT-ar \
		RANLIB=$LFS/bin/$LFS_TGT-ranlib \
		$SRC_DIR/gcc-$GCC_VERSION/configure \
		 --prefix=$LFS \
		 --with-local-prefix=$LFS/usr/local \
		 --with-native-system-header-dir=$LFS/include \
		 --enable-languages=c,c++ \
		 --disable-libstdcxx-pch \
		 --disable-multilib \
		 --disable-bootstrap \
		 --disable-libgomp
	}
	function gcc_build2() {
		CC=$LFS_TGT-gcc \
		CXX=$LFS_TGT-g++ \
		AR=$LFS_TGT-ar \
		RANLIB=$LFS/bin/$LFS_TGT-ranlib \
		make
	}
	function gcc_install2() {
		CC=$LFS_TGT-gcc \
		CXX=$LFS_TGT-g++ \
		AR=$LFS_TGT-ar \
		RANLIB=$LFS/bin/$LFS_TGT-ranlib \
		sudo make install
		sudo ln -sv gcc $LFS/bin/cc
	}
	rm -rf $SRC_DIR/gcc-$GCC_VERSION
	rm -rf $BUILD_DIR/gcc
	compile "gcc" "$GCC_VERSION" gcc_untar2 gcc_configure2 gcc_build2 gcc_install2
}
check $BUILD_DIR/.gcc2 gcc2
