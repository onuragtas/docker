FROM php:5.6.3-fpm
LABEL maintainer="Sinan Turgut <mail@sinanturgut.com.tr>"

ENV COMPOSER_HOME=/root/.composer

RUN apt-get update \
    && apt-get install -q -y  --force-yes --no-install-recommends nano curl git wget zip unzip libpq-dev

RUN apt-get install -y --force-yes libmemcached11 libmemcachedutil2 build-essential libmemcached-dev libz-dev \
    && pecl install memcached-2.2.0 \
    && echo extension=memcached.so >> /usr/local/etc/php/conf.d/memcached.ini

RUN apt-get install -y --force-yes \
        libssl-dev libxslt1-dev \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libmcrypt-dev \
        libpng12-dev zlib1g-dev libicu-dev g++ \
        && docker-php-ext-configure intl && docker-php-ext-install intl \
    && docker-php-ext-install  iconv mcrypt \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install  gd

RUN docker-php-ext-install exif gd mbstring intl xsl zip mysql mysqli pdo pdo_pgsql pdo_mysql soap bcmath sockets

RUN pecl install mongo && echo "extension=mongo.so" >> /usr/local/etc/php/conf.d/mongodb.ini

RUN mkdir -p $COMPOSER_HOME \
&& curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
&& composer --version

RUN pecl install xdebug-2.5.5


ARG XDEBUG_HOST="172.28.0.1"
ARG XDEBUG_PORT=9001
RUN echo "zend_extension=xdebug.so" >> /usr/local/etc/php/conf.d/xdebug.ini
RUN echo "xdebug.remote_enable=1" >> /usr/local/etc/php/conf.d/xdebug.ini \
   && echo "xdebug.remote_autostart=1" >> /usr/local/etc/php/conf.d/xdebug.ini &&\
   echo "xdebug.remote_connect_back=1" >> /usr/local/etc/php/conf.d/xdebug.ini &&\
   echo "xdebug.remote_handler = dbgp" >> /usr/local/etc/php/conf.d/xdebug.ini &&\
   echo "xdebug.remote_mode = req" >> /usr/local/etc/php/conf.d/xdebug.ini &&\
   echo "xdebug.idekey='PHPSTORM'" >> /usr/local/etc/php/conf.d/xdebug.ini &&\
   echo "xdebug.remote_host=${XDEBUG_HOST}" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini &&\
   echo "xdebug.remote_port=${XDEBUG_PORT}" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini