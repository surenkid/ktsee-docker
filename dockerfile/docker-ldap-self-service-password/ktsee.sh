#!/bin/sh
echo 'starting...';
php-fpm7 --daemonize
nginx -g "daemon off;"
