#!/usr/bin/env bash
set -e

source setup.sh
source versions.sh

if [ ! -r gcc-${GCC_VERISON}.tar.gz ]; then
    wget https://ftp.gnu.org/gnu/gcc/gcc-${GCC_VERSION}/gcc-${GCC_VERSION}.tar.gz
fi
