#!/bin/sh
if [ -z ${PASSWORD} ]; then
  PASSWORD=$(< /dev/urandom tr -dc A-Za-z0-9 | head -c${1:-8};echo;)
  echo "Generated password for user 'ftp': ${PASSWORD}"
fi
# set ftp user password
echo "ftp:${PASSWORD}" |/usr/sbin/chpasswd
chown ftp:ftp /var/lib/ftp/ -R

if [ -z $1 ]; then
  /usr/sbin/vsftpd /etc/vsftpd/vsftpd.conf
else
  $@
fi