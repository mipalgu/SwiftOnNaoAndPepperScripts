set +h
umask 022

if [ -z "$DOWNLOAD_SH_INCLUDED" ]
then
DOWNLOAD_SH_INCLUDED=yes

source setup.sh

function download() {
	url=$1
	[[ -z "$3" ]] && filename=`basename $url` || filename="$3"
	[[ -z "$2" ]] && outname=$filename || outname="$2"
	function _download() {
		PATH="/usr/local/bin:$PATH" LD_LIBRARY_PATH="/usr/local/lib:$LD_LIBRARY_PATH" wget $url
		if [ $filename != $outname ]
		then
			mv $filename $outname
		fi
	}
	check $outname _download
}
fi
