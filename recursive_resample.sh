#!/bin/bash

SAVEIFS=$IFS
IFS=$(echo -en "\n\b")
MP3_ROOT=/home/djcp/mp3/
NEW_ROOT=/home/djcp/mp3_resample/
MK_DIR="perl -n -e 's/(.+\/).+$/\$1/;print'"
FILE_TYPE="perl -n -e 's/(.+)\..+$/\$1/;print'"
LAME_OPTIONS="-V4 -q2 --vbr-new"

cd $MP3_ROOT;
for FILE in `find -type f | grep -iE '(flac|ogg|mp3)$'`; do

	DIR_CMD="echo -n \"${FILE}\" | ${MK_DIR}"
	DIR=`eval $DIR_CMD`
	mkdir -p "${NEW_ROOT}${DIR}"

	BASE_FILE_CMD="echo -n \"${FILE}\" | ${FILE_TYPE}"
	BASE_FILE=`eval $BASE_FILE_CMD`
	OUTPUT_FILE="${NEW_ROOT}${BASE_FILE}.mp3"

	if [ `echo $FILE | grep -iE 'ogg$'` ]
	then
		if [ ! -e $OUTPUT_FILE ] 
		then
			ID3_INFO=`~/bin/ogg_id3_info.pl "${FILE}"`
			TRANSCODE_OGG_COMMAND="/usr/bin/oggdec -o - \"$MP3_ROOT$FILE\" | /usr/local/bin/lame ${ID3_INFO} ${LAME_OPTIONS} -r - \"$OUTPUT_FILE\""
			eval $TRANSCODE_OGG_COMMAND 
		fi
	fi
	if [ `echo $FILE | grep -iE 'mp3$'` ]
	then
		if [ ! -e $OUTPUT_FILE ] 
		then
			ID3_INFO=`mp3info -p "\-\-tt \"%t\" \-\-ta \"%a\" \-\-tl \"%l\" \-\-ty \"%y\" \-\-tn \"%n\"" "$FILE"`
			TRANSCODE_MP3_COMMAND="/usr/local/bin/lame ${ID3_INFO} ${LAME_OPTIONS} \"${FILE}\" \"${OUTPUT_FILE}\""
			eval $TRANSCODE_MP3_COMMAND
		fi
	fi
	if [ `echo $FILE | grep -iE 'flac$'` ]
	then
		if [ ! -e $OUTPUT_FILE ] 
		then
			ID3_INFO=`~/bin/flac_id3_info.pl "${FILE}"`
			TRANSCODE_FLAC_COMMAND="/usr/bin/flac -dc \"${FILE}\" | /usr/local/bin/lame ${ID3_INFO} ${LAME_OPTIONS} - \"${OUTPUT_FILE}\""
			eval $TRANSCODE_FLAC_COMMAND
		fi
	fi
done;
