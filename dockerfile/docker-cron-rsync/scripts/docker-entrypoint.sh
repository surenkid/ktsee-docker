#!/bin/sh
crond
if [ -z $1 ]; then
  sh /root/inotify-rsync-push.sh ${UPLOAD_SUB_FOLDER}
else
  $@
fi