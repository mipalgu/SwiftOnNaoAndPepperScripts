set +h
umask 022

WD=`pwd`
SRC_DIR=$WD
LFS=/tools
SRC_DIR=$WD/src
BUILD_DIR=/$WD/build

mkdir -p $SRC_DIR
mkdir -p $BUILD_DIR
