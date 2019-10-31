#FROM php:7.2-fpm-alpine
#
#ARG XDEBUG_HOST="127.0.0.1"
#ARG XDEBUG_PORT=9001
#
#RUN apk add --no-cache --update --virtual buildDeps bash libcurl curl curl-dev autoconf gcc make g++ zlib-dev libzip-dev postgresql-dev libxml2-dev libpng libpng-dev libjpeg-turbo-dev libwebp-dev zlib-dev libxpm-dev gd icu-dev libxslt libxslt-dev libmemcached libmemcached-dev
#
#RUN docker-php-ext-install mysql curl zip mysqli pdo pdo_pgsql pdo_mysql soap exif gd mbstring intl xsl mysql bcmath sockets
#
#
#RUN pecl install xdebug redis-4.0.1 mongodb
#RUN docker-php-ext-enable redis xdebug mongodb
#RUN apk del buildDeps
#
#RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
#&& composer --version
#RUN echo "extension=mongodb.so" > /usr/local/etc/php/conf.d/mongodb.ini
#RUN echo "xdebug.remote_enable=1" >> /usr/local/etc/php/conf.d/xdebug.ini \
#   && echo "xdebug.remote_autostart=1" >> /usr/local/etc/php/conf.d/xdebug.ini &&\
#   echo "xdebug.remote_connect_back=1" >> /usr/local/etc/php/conf.d/xdebug.ini &&\
#   echo "xdebug.remote_handler = dbgp" >> /usr/local/etc/php/conf.d/xdebug.ini &&\
#   echo "xdebug.remote_mode = req" >> /usr/local/etc/php/conf.d/xdebug.ini &&\
#   echo "xdebug.idekey='PHPSTORM'" >> /usr/local/etc/php/conf.d/xdebug.ini &&\
#   echo "xdebug.remote_host=${XDEBUG_HOST}" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini &&\
#   echo "xdebug.remote_port=${XDEBUG_PORT}" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini


FROM php:7.2-fpm

RUN apt-get update \
    && apt-get install --no-install-recommends -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libmcrypt-dev \
        libpng-dev \
        zlib1g-dev \
        libicu-dev \
        g++ \
        unixodbc-dev \
        libxml2-dev \
        libaio-dev \
        libmemcached-dev \
        freetds-dev \
        libyaml-dev \
	libssl-dev \
	openssl \
	libcurl4-gnutls-dev

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
&& composer --version


RUN docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && pecl install sqlsrv-4.1.6.1 \
    && pecl install pdo_sqlsrv-4.1.6.1 \
    && pecl install redis \
    && pecl install memcached \
    && pecl install mongodb \
    && pecl install yaml \
    && docker-php-ext-install \
	    curl \
            iconv \
            mbstring \
            intl \
            gd \
            exif \
            mysqli \
            pdo_mysql \
            soap \
            sockets \
            zip \
            pcntl \
            ftp \
    && docker-php-ext-enable \
            sqlsrv \
            pdo_sqlsrv \
            redis \
            memcached \
            opcache \
            mongodb


RUN pecl install xdebug
RUN docker-php-ext-enable xdebug

RUN docker-php-ext-install bcmath

ARG XDEBUG_HOST
ARG XDEBUG_PORT

RUN apt-get install -y git
RUN echo "xdebug.remote_enable=1" >> /usr/local/etc/php/conf.d/xdebug.ini \
   && echo "xdebug.remote_autostart=1" >> /usr/local/etc/php/conf.d/xdebug.ini &&\
   echo "xdebug.remote_connect_back=0" >> /usr/local/etc/php/conf.d/xdebug.ini &&\
   echo "xdebug.remote_handler = dbgp" >> /usr/local/etc/php/conf.d/xdebug.ini &&\
   echo "xdebug.remote_mode = req" >> /usr/local/etc/php/conf.d/xdebug.ini &&\
   echo "xdebug.remote_host=$XDEBUG_HOST" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini &&\
   echo "xdebug.remote_port=$XDEBUG_PORT" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini

RUN echo "extension=yaml.so" > /usr/local/etc/php/conf.d/yaml.ini
