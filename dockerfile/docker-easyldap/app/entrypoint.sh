#!/bin/sh
# Update ldap server
if [ ! -z ${LDAP_SERVER} ]; then
  sed -i "s/openldap.ktsee.com/${LDAP_SERVER}/g" /app/app.py
fi

# Update base-dn
if [ ! -z ${LDAP_BASE_DN} ]; then
  sed -i "s/dc=ktsee,dc=com/${LDAP_BASE_DN}/g" /app/templates/login.html
fi

# Run easy-ldap
if [ -z $1 ]; then
  python app.py
else
  $@
fi