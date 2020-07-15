#!/bin/sh
echo 'starting...';
php-fpm --daemonize

cd /var/www/html
php -S localhost:8000