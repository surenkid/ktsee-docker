This image is used for sync files from remote machine to local machine, and sync content of user-generated to remote machine, every 1 minute.

1. Add volume for remote files to `/root/remote`, where your code on remote machine
2. Add volume for local files to `/var/www/html`, where your code on local machine
    - (So you can share this folder for other service in docker)
3. Add environment variable `UPLOAD_SUB_FOLDER`, set a folder which you want to upload to remote machine
    - (If you don't need upload local files to remote machine, ignore this step)
4. Set readiness probe command `sh /root/readiness-probe.sh`

