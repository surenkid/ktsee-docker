#!/bin/sh
local_dir=/var/www/html/
remote_dir=/root/remote/

# === pull files ===
# check last pull and last push
remote_push_time=`cat /root/remote/last-part-push.ktsee`
local_pull_time=`cat /root/last-full-pull.ktsee`
if [ ! -f "/root/remote/last-part-push.ktsee" ] || [ ! -f "/root/last-full-pull.ktsee" ] || [ $remote_push_time -gt $local_pull_time ]; then
    # Pull code from remote
    rsync -avzhupgo $remote_dir $local_dir >> /proc/self/fd/2

    # get current timestamp
    cur_sec_and_ns=`date '+%s-%N'`
    cur_sec=${cur_sec_and_ns%-*}
    cur_ns=${cur_sec_and_ns##*-}
    cur_timestamp=$((cur_sec*1000+cur_ns/1000000))

    # update last pull time
    echo $cur_timestamp > /root/last-full-pull.ktsee
fi

# === push files ===
if [ -f "/root/pre-push-file-list.ktsee" ]; then
    # remove repeat line
    sort /root/pre-push-file-list.ktsee | uniq > /root/push-file-list.ktsee
    rm -rf /root/pre-push-file-list.ktsee

    # copy changed path
    while read path
    do
    rsync -avzhupgo --exclude=*/ $local_dir$path $remote_dir$path 
    done < '/root/push-file-list.ktsee';
    rm -rf /root/push-file-list.ktsee

    # get current timestamp
    cur_sec_and_ns=`date '+%s-%N'`
    cur_sec=${cur_sec_and_ns%-*}
    cur_ns=${cur_sec_and_ns##*-}
    cur_timestamp=$((cur_sec*1000+cur_ns/1000000))
    echo $cur_timestamp > /root/remote/last-part-push.ktsee
fi



