set +h
umask 022

if [ -z "$SETUP_SH_INCLUDED" ]
then
SETUP_SH_INCLUDED=yes

WD=`pwd`
SRC_DIR=$WD
LFS=/tools
SRC_DIR=$WD/src
BUILD_DIR=/$WD/build

mkdir -p $SRC_DIR
mkdir -p $BUILD_DIR

function check() {
	if [ ! -f $1 ]
	then
		$2
	fi
}

fi
