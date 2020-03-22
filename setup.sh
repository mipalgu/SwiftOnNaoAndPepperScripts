set +h
umask 022

if [ -z "$SETUP_SH_INCLUDED" ]
then
SETUP_SH_INCLUDED=yes

WD=`pwd`
SRC_DIR=$WD
LFS=/home/nao/tools
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

function compile() {
	name=$1
	version=$2
	[[ -z "$3" ]] && local_untar="tar -xzvf $SRC_DIR/$name-$version.tar.gz" || local_untar="$3"
	[[ -z "$4" ]] && local_configure="$SRC_DIR/$name-$version/configure --prefix=$INSTALL_PREFIX" || local_configure="$4"
	[[ -z "$5" ]] && local_build="make" || local_build="$5"
	[[ -z "$6" ]] && local_install="sudo make install" || local_install="$6"
	function _compile() {
		rm -rf $BUILD_DIR/$name
		mkdir -p $BUILD_DIR/$name
		cd $BUILD_DIR/$name
		if [ ! -d $SRC_DIR/$name-$version ]
		then
			echo "Checking: $SRC_DIR/$name-$version"
			cd $SRC_DIR
			echo "untaring: $local_untar"
			$local_untar
			cd $BUILD_DIR/$name
		fi
		echo "Configure: $local_configure"
		$local_configure
		cd $BUILD_DIR/$name
		echo "Build: $local_build"
		$local_build
		cd $BUILD_DIR/$name
		echo "Install: $local_install"
		$local_install
		cd $BUILD_DIR/$name
		touch .$name
		cd $WD
	}
	check $BUILD_DIR/$name/.$name _compile
}

fi
