#!/usr/bin/env bash
set -e

source download-sources.sh
source setup-sources.sh
source build-cross-toolchain.sh
source build-host-llvm.sh
source build-swift.sh
