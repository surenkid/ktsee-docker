#!/bin/sh
local_dir=/var/www/html/
code_dir=/root/code/
upload_dir=/root/upload/

# Pull code from remote
rsync -avzhupgo $code_dir $local_dir >> /proc/self/fd/2

# Push user generate content to remote
rsync -avzhupgo --include-from="/root/pre-push-file.list" --exclude="/*" $local_dir $upload_dir >> /proc/self/fd/2


# Write deploy success flag for readiness probe of k8s
touch /root/deploy.ktsee