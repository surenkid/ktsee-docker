FROM php:7.0.33-fpm-alpine3.7
LABEL maintainer="surenkids@gmail.com"

# Change alpine repo for China network
#RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories
#RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories

# Install GD depended library
RUN apk add --no-cache freetype-dev libjpeg-turbo-dev libpng-dev libwebp-dev \
      && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/

# Install dependencies
RUN apk add --no-cache libxml2-dev libmcrypt-dev openssl-dev unixodbc-dev libstdc++ libzip-dev

# Install extensions using docker-php-ext-install
RUN docker-php-ext-install gd mysqli pdo_mysql zip mcrypt

# Install REDIS, PDO_SQLSRV using pecl
RUN apk add --no-cache --virtual .build-deps $PHPIZE_DEPS \
      && pecl channel-update pecl.php.net \
      && pecl install redis-5.3.1 sqlsrv-5.3.0 pdo_sqlsrv-5.3.0 \
      && docker-php-ext-enable redis sqlsrv pdo_sqlsrv \
      && apk del .build-deps

# Install composer 
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer