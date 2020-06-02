#!/bin/sh
if [ -z ${UPLOAD_SUB_FOLDER} ]; then
  touch /root/inotify-watch-path.ktsee
else
  echo ${UPLOAD_SUB_FOLDER} > /root/inotify-watch-path.ktsee
fi

if [ -z $1 ]; then
  crond -f
else
  $@
fi