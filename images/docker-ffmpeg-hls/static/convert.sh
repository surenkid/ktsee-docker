#!/bin/bash
#convert mp4 to ts
function batch_convert() {
    for file in `ls $1`
    do
        if [ -d $1"/"$file ]
        then
            batch_convert $1"/"$file
        elif [ "${file##*.}" = "mp4" -o "${file##*.}" = "MP4" ]
        then
            #replace old path, remove suffix
            file2folder=$TS_VIDEO_DIR${1/$MP4_VIDEO_DIR/}"/"${file%.*}
            if [ ! -d $file2folder ]
            then
                mkdir -p $file2folder
            fi
            #echo $1" : "$1"/"$file
            ffmpeg -i $1"/"$file -f segment -segment_time $VIDEO_SEGMENT_TIME -segment_format mpegts -segment_list $file2folder"/playlist.m3u8" -c copy -bsf:v h264_mp4toannexb -map 0 $file2folder"/%03d.ts"
            cp /root/player.html $file2folder"/index.html"
            echo $file" convert success!"
        fi
    done
}
batch_convert $MP4_VIDEO_DIR
# upload to ftp server
lftp -u $FTP_USER,$FTP_PASSWORD -e "set ftp:ssl-allow no; mirror -R --only-newer --only-missing --verbose --parallel=$FTP_UPLOAD_PARALLEL $TS_VIDEO_DIR/ $FTP_UPLOAD_DIR;exit;" $FTP_SERVER