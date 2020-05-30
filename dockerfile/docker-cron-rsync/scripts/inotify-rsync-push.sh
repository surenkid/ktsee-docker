#!/bin/sh
local_dir=/var/www/html/

/usr/bin/inotifywait -mrq --format  '%Xe %w%f' -e modify,create,delete,attrib,close_write,move $local_dir$1 | while read file         #把监控到有发生更改的"文件路径列表"循环
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
                #rsync -avzcR --password-file=${rsync_passwd_file} $(dirname ${INO_FILE}) ${user}@${ip1}::${des} &&         # INO_FILE变量代表路径哦  -c校验文件内容
                #rsync -avzcR --password-file=${rsync_passwd_file} $(dirname ${INO_FILE}) ${user}@${ip2}::${des}
                 #仔细看 上面的rsync同步命令 源是用了$(dirname ${INO_FILE})变量 即每次只针对性的同步发生改变的文件的目录(只同步目标文件的方法在生产环境的某些极端环境下会漏文件 现在可以在不漏文件下也有不错的速度 做到平衡) 然后用-R参数把源的目录结构递归到目标后面 保证目录结构一致性
        fi
        #删除、移动出事件
        if [[ "$CHECK_DELETE" != "" ]] || [[ "$CHECK_MOVED_FROM" != "" ]]
        then
                echo 'DELETE or MOVED_FROM'
                path=$(dirname ${INO_FILE})
                echo ${path:${#local_dir}} >> /root/pre-push-file-list.ktsee
                #rsync -avzR --delete --password-file=${rsync_passwd_file} $(dirname ${INO_FILE}) ${user}@${ip1}::${des} &&
                #rsync -avzR --delete --password-file=${rsync_passwd_file} $(dirname ${INO_FILE}) ${user}@${ip2}::${des}
                #看rsync命令 如果直接同步已删除的路径${INO_FILE}会报no such or directory错误 所以这里同步的源是被删文件或目录的上一级路径，并加上--delete来删除目标上有而源中没有的文件，这里不能做到指定文件删除，如果删除的路径越靠近根，则同步的目录月多，同步删除的操作就越花时间。这里有更好方法的同学，欢迎交流。
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
                        #rsync -avzcR --password-file=${rsync_passwd_file} $(dirname ${INO_FILE}) ${user}@${ip1}::${des} &&
                        #rsync -avzcR --password-file=${rsync_passwd_file} $(dirname ${INO_FILE}) ${user}@${ip2}::${des}
                fi
        fi
done