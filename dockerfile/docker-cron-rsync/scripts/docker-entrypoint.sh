#!/bin/sh
if [ -z ${UPLOAD_SUB_FOLDER} ]; then
  touch /root/inotify-watch-path.ktsee
else
  echo ${UPLOAD_SUB_FOLDER} > /root/inotify-watch-path.ktsee
fi

if [ -z $1 ]; then
  exec crond -f
else
  $@
fi