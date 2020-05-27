This image is used for sync code from NFS to local disk, and sync content of user-generated to NFS, every 5 mins.

1. Write a sync shell script named `cron-rsync.sh`, and saved to `/root/rsync`
2. Add volume for source code to `/root/code`, where your code on NFS
3. Add volume for the content of user-generated to `root/upload`, where you want to upload to NFS
4. This image was made by surenkid.

`cron-rsync.sh` example:
```
#!/bin/sh
local_dir=/var/www/html/
code_dir=/root/code/
upload_dir=/root/upload/

# Pull code from remote
rsync -avzhupgo --progress $code_dir $local_dir >> /root/rsync/pull.log

# Push user generate content to remote
rsync -avzhupgo --progress --include-from="/root/rsync/upload_dir.conf" --exclude="/*" $local_dir $upload_dir >> /root/rsync/push.log
```
`upload_dir.conf` example:
```
upload/
```