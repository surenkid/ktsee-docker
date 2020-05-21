#!/bin/sh
if [ -z ${PASSWORD} ]; then
  PASSWORD=$(< /dev/urandom tr -dc A-Za-z0-9 | head -c${1:-8};echo;)
  echo "Generated password for user 'ktsee': ${PASSWORD}"
fi
# set ftp user password
echo "ktsee:${PASSWORD}" |/usr/sbin/chpasswd
chown ktsee:ktsee /home/ -R

if [ -z $1 ]; then
  /usr/sbin/vsftpd /etc/vsftpd/vsftpd.conf
else
  $@
fi