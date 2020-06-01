#!/bin/sh
local_dir=/var/www/html
remote_dir=/root/remote


# === pull files from remote to local ===
# check last pull and last push
if [ ! -f /root/last-full-pull.ktsee ]; then
    echo 0000000000000 > /root/last-full-pull.ktsee
fi

if [ ! -f /root/remote/last-part-push.ktsee ]; then
    # Pull code from remote fully
    echo "Pull files from $remote_dir/ to $local_dir/"
    rsync -avzupgoI $remote_dir/ $local_dir/ --exclude=last-part-push.ktsee >> /proc/self/fd/2

    # get current timestamp
    cur_sec_and_ns=`date '+%s-%N'`
    cur_sec=${cur_sec_and_ns%-*}
    cur_ns=${cur_sec_and_ns##*-}
    cur_timestamp=$((cur_sec*1000+cur_ns/1000000))
    echo $cur_timestamp > /root/remote/last-part-push.ktsee
else
    remote_push_time=`cat /root/remote/last-part-push.ktsee`
    local_pull_time=`cat /root/last-full-pull.ktsee`
    if [ $remote_push_time -gt $local_pull_time ]; then
        # Pull code from remote partly
        echo "Pull files from $remote_dir/ to $local_dir/"
        rsync -avzupgo $remote_dir/ $local_dir/ --exclude=last-part-push.ktsee >> /proc/self/fd/2

        # get current timestamp
        cur_sec_and_ns=`date '+%s-%N'`
        cur_sec=${cur_sec_and_ns%-*}
        cur_ns=${cur_sec_and_ns##*-}
        cur_timestamp=$((cur_sec*1000+cur_ns/1000000))

        # update last pull time
        echo $cur_timestamp > /root/last-full-pull.ktsee

        # init inotify watch
        flock -xn /tmp/inotify-rsync-push.lock -c "nohup sh /root/inotify-rsync-push.sh &" >> /proc/self/fd/2
        touch /root/deploy.ktsee
    fi
fi

# === push files from local to remote ===
if [ -f /root/pre-push-file-list.ktsee ]; then
    # remove repeat line
    sort /root/pre-push-file-list.ktsee | uniq > /root/push-file-list.ktsee
    rm -rf /root/pre-push-file-list.ktsee

    # copy changed path
    while read path
    do
        echo "Push files from $local_dir/$path/ to $remote_dir/$path/"
        rsync -avzupgo --exclude=*/ $local_dir/$path/ $remote_dir/$path/ >> /proc/self/fd/2
    done < /root/push-file-list.ktsee;
    # rm -rf /root/push-file-list.ktsee

    # get current timestamp
    cur_sec_and_ns=`date '+%s-%N'`
    cur_sec=${cur_sec_and_ns%-*}
    cur_ns=${cur_sec_and_ns##*-}
    cur_timestamp=$((cur_sec*1000+cur_ns/1000000))
    echo $cur_timestamp > /root/remote/last-part-push.ktsee
fi



