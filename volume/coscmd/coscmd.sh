#!/bin/sh
upload_dir=/$(date "+%Y/%m/%d")
delete_dir=/$(date --date="@$(($(date +%s) - 3600*24*90))" "+%Y/%m/%d")

# backup folders
set "/nfs2/mongo" "/nfs2/mysql"
for path in do "$@"
do
	tar cvzf /archive.tar.gz $path
	/usr/local/bin/coscmd upload /archive.tar.gz $upload_dir$path/archive.tar.gz -H "{'x-cos-storage-class':'Archive'}"
	rm -f /archive.tar.gz
done
set x; shift

# backup sub folders
set "/nfs1" "/nfs2/web"
for path in do "$@"
do
	dirList=`ls -p $path |grep / |tr -d /`
	for dir in $dirList
	do
		tar cvzf /$dir.tar.gz $path/$dir
		/usr/local/bin/coscmd upload /$dir.tar.gz $upload_dir$path/$dir.tar.gz -H "{'x-cos-storage-class':'Archive'}"
		rm -f /$dir.tar.gz
	done
done
set x; shift

# delete backup files before 3 month
/usr/local/bin/coscmd delete -rf $delete_dir