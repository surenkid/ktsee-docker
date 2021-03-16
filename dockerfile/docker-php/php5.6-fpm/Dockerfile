FROM php:5.6.40-fpm-alpine3.8
LABEL maintainer="surenkids@gmail.com"

# Change alpine repo for China network
#RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories
#RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories

# Install GD depended library
RUN apk add --no-cache freetype-dev libjpeg-turbo-dev libpng-dev libwebp-dev \
      && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/

# Install dependencies
RUN apk add --no-cache libxml2-dev libmcrypt-dev openssl-dev unixodbc-dev libstdc++ libzip-dev

# Copy Zend loader to extionsion dir and install them
COPY zend-loader-php5.6-linux-x86_64/files/ /usr/local/lib/php/extensions/no-debug-non-zts-20131226/
RUN docker-php-ext-enable ZendGuardLoader opcache

# Install extensions using docker-php-ext-install
RUN docker-php-ext-install gd mysqli pdo_mysql zip mcrypt bcmath sockets

# Install REDIS, PDO_SQLSRV using pecl
RUN apk add --no-cache --virtual .build-deps $PHPIZE_DEPS \
      && pecl channel-update pecl.php.net \
      && pecl install redis-4.3.0 mongo-1.6.16 \
      && docker-php-ext-enable redis mongo \
      && apk del .build-deps

# Install composer 
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Change timezone to Asia/Shanghai
RUN apk add tzdata && cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && echo "Asia/Shanghai" > /etc/timezone \
    && apk del tzdata

# Add bash to alpine
RUN apk add --no-cache bash