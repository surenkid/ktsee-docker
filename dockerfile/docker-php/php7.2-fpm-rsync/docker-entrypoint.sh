#!/bin/sh
rsync --avzhu —progress /root/web/ /var/www/html/

echo "*/5    *       *       *       *       /usr/bin/rsync --avzhu /var/www/html/ /root/web/" >> /etc/crontab/root

if [ -z $1 ]; then
  /usr/local/sbin/php-fpm
else
  $@
fi