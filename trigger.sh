#!/usr/bin/env bash
set -e

# Set up Variables
source setup.sh
source versions.sh

chroot /tools $LFS/usr/bin/env -i HOME=/root TERM="$TERM" PS1='\u:\w\$ ' PATH="$LFS/usr/local/bin:$LFS/usr/bin:$LFS/bin" CPATH="$LFS/usr/local/include:$LFS/usr/include:/$LFS/include" LIBRARY_PATH="$LFS/usr/local/lib:$LFS/usr/lib:$LFS/lib" LD_LIBRARY_PATH="$LFS/usr/local/lib:$LFS/usr/lib:$LFS/lib" /build-swift.sh
