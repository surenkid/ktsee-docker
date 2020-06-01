#!/bin/sh
local_dir=/var/www/html
upload_sub_folder=`cat /root/upload-sub-folder.ktsee`

if [ ! -d $local_dir/$upload_sub_folder ]; then
        mkdir -p $local_dir/$upload_sub_folder
        chown -R 82:82 $local_dir/$upload_sub_folder
fi

/usr/bin/inotifywait -mrq --format  '%Xe %w%f' -e modify,create,delete,attrib,close_write,move $local_dir/$upload_sub_folder | while read file         #把监控到有发生更改的"文件路径列表"循环
do
        INO_EVENT=$(echo $file | awk '{print $1}')      # 把inotify输出切割 把事件类型部分赋值给INO_EVENT
        INO_FILE=$(echo $file | awk '{print $2}')       # 把inotify输出切割 把文件路径部分赋值给INO_FILE
        CHECK_CREATE=$(echo $INO_EVENT | grep "CREATE")
        CHECK_MODIFY=$(echo $INO_EVENT | grep "MODIFY")
        CHECK_CLOSE_WRITE=$(echo $INO_EVENT | grep "CLOSE_WRITE")
        CHECK_MOVED_TO=$(echo $INO_EVENT | grep "MOVED_TO")
        CHECK_DELETE=$(echo $INO_EVENT | grep "DELETE")
        CHECK_MOVED_FROM=$(echo $INO_EVENT | grep "MOVED_FROM")
        CHECK_ATTRIB=$(echo $INO_EVENT | grep "ATTRIB")
        echo "-------------------------------$(date)------------------------------------"
        echo $file
        #增加、修改、写入完成、移动进事件
        #增、改放在同一个判断，因为他们都肯定是针对文件的操作，即使是新建目录，要同步的也只是一个空目录，不会影响速度。
        if [[ "$CHECK_CREATE" != "" ]] || [[ "$CHECK_MODIFY" != "" ]] || [[ "$CHECK_CLOSE_WRITE" != "" ]] || [[ "$CHECK_MOVED_TO" != "" ]]         # 判断事件类型
        then
                echo 'CREATE or MODIFY or CLOSE_WRITE or MOVED_TO'
                path=$(dirname ${INO_FILE})
                echo ${path:${#local_dir}} >> /root/pre-push-file-list.ktsee
        fi
        #删除、移动出事件
        if [[ "$CHECK_DELETE" != "" ]] || [[ "$CHECK_MOVED_FROM" != "" ]]
        then
                echo 'DELETE or MOVED_FROM'
                path=$(dirname ${INO_FILE})
                echo ${path:${#local_dir}} >> /root/pre-push-file-list.ktsee
        fi
        #修改属性事件 指 touch chgrp chmod chown等操作
        if [[ "$CHECK_ATTRIB" != "" ]]
        then
                echo 'ATTRIB'
                if [ ! -d "$INO_FILE" ]                 # 如果修改属性的是目录 则不同步，因为同步目录会发生递归扫描，等此目录下的文件发生同步时，rsync会顺带更新此目录。
                then
                        echo 'ATTRIB FILE'
                        path=$(dirname ${INO_FILE})
                        echo ${path:${#local_dir}} >> /root/pre-push-file-list.ktsee
                fi
        fi
done