#! /bin/sh

exec /usr/local/bin/cpp-5 -isysroot `xcrun --show-sdk-path` "$@"
