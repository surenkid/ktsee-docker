#!/bin/sh
local_dir=/var/www/html
remote_dir=/root/remote

# get current timestamp
cur_sec_and_ns=`date '+%s-%N'`
cur_sec=${cur_sec_and_ns%-*}
cur_ns=${cur_sec_and_ns##*-}
cur_timestamp=$((cur_sec*1000+cur_ns/1000000))

# === download files from remote to local ===
# check last download and last upload
if [ ! -f /root/last-full-download.ktsee ]; then
    echo 0000000000000 > /root/last-full-download.ktsee
fi

if [ ! -f $remote_dir/last-part-upload.ktsee ]; then
    echo $cur_timestamp > $remote_dir/last-part-upload.ktsee
fi

if [ ! -f $remote_dir/rsync-exclude-list.ktsee ]; then
    touch $remote_dir/rsync-exclude-list.ktsee
fi

# check newer, if remote is newer, pull from remote to local
remote_update_time=`cat /root/remote/last-part-upload.ktsee`
local_update_time=`cat /root/last-full-download.ktsee`
if [ $remote_update_time -gt $local_update_time ]; then
    # Download files from remote partly
    echo "Download files from $remote_dir/ to $local_dir/"

    # if init.ktsee exist, download partly
    if [ -f /root/init.ktsee ]; then
        rsync -avzupgo $remote_dir/ $local_dir/ --exclude=*.ktsee --exclude-from=$remote_dir/rsync-exclude-list.ktsee >> /proc/self/fd/2   
    else
        rsync -avzupgoI $remote_dir/ $local_dir/ --exclude=*.ktsee --exclude-from=$remote_dir/rsync-exclude-list.ktsee >> /proc/self/fd/2
        touch /root/init.ktsee

        # do not use inotify-watch if inotify-watch-path.ktsee(upload folder config) is blank
        if [ -s /root/inotify-watch-path.ktsee ]; then
            # init inotify watch
            sh /root/inotify-watch.sh &
            # unlock cron lock
            rm -rf /tmp/cron-rsync.lock
        fi

        touch /root/deploy.ktsee
    fi

    # update last pull time
    echo $cur_timestamp > /root/last-full-download.ktsee

else
    echo "No files need to download"
fi

# === push files from local to remote ===
if [ -f /root/pre-upload-file-list.ktsee ]; then
    # remove repeat line
    sort /root/pre-upload-file-list.ktsee | uniq > /root/upload-file-list.ktsee
    rm -rf /root/pre-upload-file-list.ktsee

    # copy changed path
    while read path
    do
        echo "Upload files from $local_dir/$path/ to $remote_dir/$path/"
        if [ ! -d $local_dir/$path ]; then
                mkdir -p $local_dir/$path
                chown -R 82:82 $local_dir/$path
        fi
        rsync -avzupgo --exclude=*/ $local_dir/$path/ $remote_dir/$path/ >> /proc/self/fd/2
    done < /root/upload-file-list.ktsee;
    # rm -rf /root/upload-file-list.ktsee

    echo $cur_timestamp > /root/remote/last-part-upload.ktsee
fi



