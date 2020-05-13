#!/bin/sh
backup_list[0]="/mnt/nfs1/volumes"
backup_list[1]="/mnt/nfs2/upload/static.sumeils.com/2020"
backup_list[2]="/mnt/nfs2/upload/truly-mall.sumeils.com"

upload_dir=/$(date "+%Y/%m/%d")
delete_dir=/$(date -d"-3 month +1 day" +%Y-%m-%d)

# list and zip folders
for path in ${backup_list[@]}
do
	dirList=`ls -p $path |grep / |tr -d /`
	for dir in $dirList
	do
		tar cvzf /$dir.tar.gz $path/$dir
		/usr/local/bin/coscmd upload /$dir.tar.gz $upload_dir -H "{'x-cos-storage-class':'Archive'}"
		rm -f /$dir.tar.gz
	done
done

# delete backup files before 3 month
/usr/local/bin/coscmd delete -rf $delete_dir
