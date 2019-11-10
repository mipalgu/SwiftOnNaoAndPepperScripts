#!/usr/bin/env bash

source setup.sh

echo 'import Glibc' > main.swift
echo '' >> main.swift
echo 'let x = rand()' >> main.swift
echo 'print("Random: \(x)")' >> main.swift
swiftc -c main.swift -target i686-aldebaran-linux-gnu -Xcc -I$INSTALL_PREFIX/include -Xcc -I/$LFS/usr/include
$CROSS_TOOLCHAIN_DIR/$TRIPLE/bin/ld.gold -pie -z relro --hash-style=gnu --eh-frame-hdr -m elf_i386 -dynamic-linker /lib/ld-linux.so.2 -o main $LFS/usr/lib/Scrt1.o $LFS/usr/lib/crti.o $GCC_TOOLCHAIN/crtbeginS.o -L$INSTALL_PREFIX/lib/swift/linux -L$GCC_TOOLCHAIN -L$INSTALL_PREFIX/lib -L$LFS/usr/lib -L$LFS/lib /usr/local/var/swiftenv/versions/5.1-pepper/usr/lib/swift/linux/i686/swiftrt.o main.o -lswiftSwiftOnoneSupport -lswiftCore -lswiftCore --sysroot=/root/src/nao_swift/pepper/sysroot -lstdc++ -lm -lgcc_s -lgcc -lc -lgcc_s -lgcc $GCC_TOOLCHAIN/crtendS.o $LFS/usr/lib/crtn.o -R/home/nao/swift-tc/lib/swift/linux -R/home/nao/swift-tc/lib
