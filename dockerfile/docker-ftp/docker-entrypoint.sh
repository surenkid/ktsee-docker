#!/bin/sh
if [ -z ${PASSWORD} ]; then
  PASSWORD=$(< /dev/urandom tr -dc A-Za-z0-9 | head -c${1:-8};echo;)
  echo "Generated password for user 'ktsee': ${PASSWORD}"
fi

# set passive mode parameters:
echo "pasv_enable=${PASV_ENABLE}" >> /etc/vsftpd/vsftpd.conf
echo "pasv_address=${PASV_ADDRESS}" >> /etc/vsftpd/vsftpd.conf
echo "pasv_max_port=${PASV_MAX_PORT}" >> /etc/vsftpd/vsftpd.conf
echo "pasv_min_port=${PASV_MIN_PORT}" >> /etc/vsftpd/vsftpd.conf
echo "pasv_addr_resolve=${PASV_ADDR_RESOLVE}" >> /etc/vsftpd/vsftpd.conf

# set ftp user password
echo "ktsee:${PASSWORD}" |/usr/sbin/chpasswd
chown ktsee:ktsee /home/ -R

if [ -z $1 ]; then
  /usr/sbin/vsftpd /etc/vsftpd/vsftpd.conf
else
  $@
fi