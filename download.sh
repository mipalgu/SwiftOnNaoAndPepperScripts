set +h
umask 022

if [ -z "$DOWNLOAD_SH_INCLUDED" ]
then
DOWNLOAD_SH_INCLUDED=yes

source setup.sh

function download() {
	url=$1
	[[ -z "$2" ]] && filename=`basename $url` || filename="$2"
	[[ -z "$3" ]] && outname=$filename || outname="$3"
	function _download() {
		PATH="/usr/local/bin:$PATH" LD_LIBRARY_PATH="/usr/local/lib:$LD_LIBRARY_PATH" wget $url
		if [ $filename != $outname ]
		then
			mv $filename $outname
		fi
	}
	check _download
}
fi
