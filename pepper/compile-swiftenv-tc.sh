#!/usr/bin/env bash
set -e
source setup.sh

swiftenv_dir=/usr/local/var/swiftenv
swiftenv_swift_version=`cat .swift-version 2>/dev/null || cat /usr/local/var/swiftenv/version`
version=$swiftenv_swift_version

if [ "${#version}" -gt "7" ]
then
    if [ ${version: -7} == "-pepper" ]
    then
        version=${version::${#version}-7}
        swiftenv_swift_version=$version
        /usr/local/var/swiftenv/bin/swiftenv local $swiftenv_swift_version
    fi
fi

if [ ! -d $swiftenv_dir/versions/$version-pepper ]
then
    echo "Creating a swiftenv toolchain that cross compiles to the pepper."
    rm -rf $swiftenv_dir/versions/$version-pepper
    cp -R $swiftenv_dir/versions/$version $swiftenv_dir/versions/$version-pepper
    rm -rf $swiftenv_dir/versions/$version-pepper/usr/lib/swift/*
    cp -R $INSTALL_PREFIX/lib/swift/* $swiftenv_dir/versions/$version-pepper/usr/lib/swift/
    # path the glibc module map so that the paths point to the sysroot.
    sed -i "s|header \"/|header \"$LFS/|g" $swiftenv_dir/versions/$version-pepper/usr/lib/swift/linux/i686/glibc.modulemap
fi
