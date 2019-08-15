#! /bin/sh

exec /usr/local/bin/g++-5 -isysroot `xcrun --show-sdk-path` --sysroot=`xcrun --show-sdk-path` "$@"
