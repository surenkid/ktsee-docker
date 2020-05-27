#!/bin/sh
local_dir=/var/www/html/
code_dir=/root/code/
upload_dir=/root/upload/

# Pull code from remote
rsync -avzhupgo --progress $code_dir $local_dir >> /root/rsync/pull.log

# Push user generate content to remote
rsync -avzhupgo --progress --include-from="/root/rsync/upload_dir.conf" --exclude="/*" $local_dir $upload_dir >> /root/rsync/push.log