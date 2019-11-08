#!/usr/bin/env bash
set -e

usage() { echo "Usage: $0 [-j<value>]"; }

while getopts "j:h" o; do
    case "${o}" in
        h)
            usage
            exit 0
            ;;
        j)
            PARALLEL=${OPTARG}
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
source build-swift.sh
