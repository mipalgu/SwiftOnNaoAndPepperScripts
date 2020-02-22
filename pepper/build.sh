#!/usr/bin/env bash
set -e

source setup.sh
source setup-sources.sh
source setup-sysroot.sh
source build-cross-binutils.sh
source build-libuuid.sh
source build-icu.sh
source build-host-llvm.sh
source build-target-llvm.sh
source build-swift.sh
source build-libdispatch.sh
source build-foundation.sh
source finalise.sh
