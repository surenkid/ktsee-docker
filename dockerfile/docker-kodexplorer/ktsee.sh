#!/bin/sh
echo 'starting...';
php-fpm --daemonize

cd /var/www/html
php -S 0.0.0.0:8000