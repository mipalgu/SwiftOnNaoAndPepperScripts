#!/usr/bin/env bash
set -e

usage() { echo "Usage: $0 [-j<value>] -l"; }

BUILD_LIBCXX=false

while getopts "j:hl" o; do
    case "${o}" in
        h)
            usage
            exit 0
            ;;
        j)
            PARALLEL=${OPTARG}
            ;;
	l)
            BUILD_LIBCXX=true
	    ;;
        *)
            echo "Invalid argument ${o}"
            usage 1>&2
            exit 1
            ;;
    esac
done

source setup.sh
source setup-sources.sh
source setup-sysroot.sh
source build-cross-binutils.sh
source build-libuuid.sh
source build-swift.sh
source finalise.sh
