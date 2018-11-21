#!/usr/bin/env bash

SYSROOT_LIBRARY_PATH="$LFS/lib/gcc/${TRIPLE}/4.9.2/include:${SYSROOT_LIBRARY_PATH}"
source cross.sh
