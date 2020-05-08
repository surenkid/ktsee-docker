FROM php:7.3.12-fpm-alpine3.10
LABEL maintainer="surenkids@gmail.com"

RUN docker-php-ext-install pdo pdo_mysql mysqli

RUN apk add --no-cache libmcrypt-dev \
      && apk add --no-cache --virtual .build-deps $PHPIZE_DEPS \
      && pecl install redis \
      && pecl install xdebug \
      && pecl install mcrypt \
      && docker-php-ext-enable redis xdebug mcrypt \
      && apk del .build-deps

RUN apk add --no-cache freetype-dev \
      && apk add --no-cache libjpeg-turbo-dev \
      && apk add --no-cache libpng-dev \
      && apk add --no-cache libwebp-dev \
      && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
      && docker-php-ext-install gd
      
RUN apk add --no-cache openldap-dev \
      && docker-php-ext-configure ldap --with-libdir=lib/ \
      && docker-php-ext-install ldap
