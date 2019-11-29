#!/usr/bin/env bash
set -e

source setup.sh

usage() { echo "Usage: $0 [-j<value>] -l -s <swift-version> -t <swift-tag>"; }

while getopts "j:hls:t:" o; do
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
        s)
	        SWIFT_VERSION=swift-${OPTARG}-RELEASE
	        ;;
        t)
	        SWIFT_VERSION=${OPTARG}
	        ;;
        *)
            echo "Invalid argument ${o}"
            usage 1>&2
            exit 1
            ;;
    esac
done

source setup-sources.sh
source setup-sysroot.sh
source build-cross-binutils.sh
source build-libuuid.sh
source build-swift.sh
source finalise.sh
