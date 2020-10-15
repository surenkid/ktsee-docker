FROM php:7.2.30-fpm-alpine3.11
LABEL maintainer="surenkids@gmail.com"

# Change alpine repo for China network
#RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories
#RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories

# Install GD depended library
RUN apk add --no-cache freetype-dev libjpeg-turbo-dev libpng-dev libwebp-dev \
      && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/

# Install dependencies
RUN apk add --no-cache libxml2-dev libmcrypt-dev libressl-dev unixodbc-dev libstdc++ libzip-dev openldap-dev curl-dev

# Install extensions using docker-php-ext-install
RUN docker-php-ext-install gd mysqli pdo_mysql pdo_dblib zip bcmath ldap

# Install REDIS, PDO_SQLSRV and MCRYPT using pecl
RUN apk add --no-cache --virtual .persistent-deps freetds unixodbc \
      && apk add --no-cache --virtual .build-deps $PHPIZE_DEPS unixodbc-dev freetds-dev \
      && pecl channel-update pecl.php.net \
      && pecl install redis-5.3.1 mcrypt-1.0.3 sqlsrv-5.8.1 pdo_sqlsrv-5.8.1 yar-2.0.5 \
      && docker-php-ext-enable redis mcrypt sqlsrv pdo_sqlsrv yar \
      && apk del .build-deps

# Install composer 
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Fix iconv library version => unknown bug. via: https://github.com/docker-library/php/issues/240#issuecomment-305038173
RUN apk add --no-cache --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing gnu-libiconv
ENV LD_PRELOAD /usr/lib/preloadable_libiconv.so php

# Change timezone to Asia/Shanghai
RUN apk add tzdata && cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && echo "Asia/Shanghai" > /etc/timezone \
    && apk del tzdata

# Add bash to alpine
RUN apk add --no-cache bash