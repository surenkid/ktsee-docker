PHP supervisord and crond service for queue service.

How to use:

1. Mount wwwroot to `/root/remote`
2. Add below to `/etc/crontabs/root` to enable sync mode
    - `*       *       *       *       *       /usr/bin/flock -xn /tmp/cron-rsync.lock -c 'sh /root/cron-rsync.sh'`
3. Set readiness check with `/root/readiness-probe.sh` 
4. Delete the `/root/remote/last-part-upload.ktsee` if you updated your codes