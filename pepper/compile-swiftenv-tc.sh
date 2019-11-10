#!/usr/bin/env bash
set -e
source setup.sh

swiftenv_dir=/usr/local/var/swiftenv
version=`cat /usr/local/var/swiftenv/version`

rm -rf $swiftenv_dir/versions/$version-pepper
cp -R $swiftenv_dir/versions/$version $swiftenv_dir/versions/$version-pepper
rm -rf $swiftenv_dir/versions/$version-pepper/usr/lib/swift/*
cp -R $INSTALL_PREFIX/lib/swift/* $swiftenv_dir/versions/$version-pepper/usr/lib/swift/
