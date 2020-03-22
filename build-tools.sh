#!/usr/bin/env bash
set -e

source setup.sh
source versions.sh

INSTALL_PREFIX=/usr/local

#CMake
#compile "cmake" "$CMAKE_VERSION"

#Ninja
function ninja_configure() {
	cp -r $SRC_DIR/ninja-$NINJA_VERSION/* .
	./configure.py --bootstrap
}
function ninja_build() {
	echo "skip"
}
function ninja_install() {
	sudo install ninja $INSTALL_PREFIX/bin
}
compile "ninja" "$NINJA_VERSION" "" ninja_configure ninja_build ninja_install
