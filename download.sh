set +h
umask 022

if [ -z "$DOWNLOAD_SH_INCLUDED" ]
then
DOWNLOAD_SH_INCLUDED=yes

function download() {
	url=$1
	[[ -z "$2" ]] && filename=`basename $url` || filename="$2"
	[[ -z "$3" ]] && outname=$filename || outname="$3"
	PATH="/usr/local/bin:$PATH" LD_LIBRARY_PATH="/usr/local/lib:$LD_LIBRARY_PATH" wget $url
	if [ $filename != $outname ]
	then
		mv $filename $outname
	fi
}
fi
