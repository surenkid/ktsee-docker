#!/bin/sh
if [ -z ${UPLOAD_SUB_FOLDER} ]; then
  echo ${UPLOAD_SUB_FOLDER} > /root/upload-sub-folder.ktsee
else
  touch /root/upload-sub-folder.ktsee
fi

if [ -z $1 ]; then
  crond -f
else
  $@
fi