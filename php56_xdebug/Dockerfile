FROM php:5.6-fpm

ENV COMPOSER_HOME=/root/.composer

RUN echo "deb [trusted=yes] http://archive.debian.org/debian stretch main non-free contrib" > /etc/apt/sources.list
RUN echo "deb-src [trusted=yes] http://archive.debian.org/debian stretch main non-free contrib" >> /etc/apt/sources.list
RUN echo "deb [trusted=yes] http://archive.debian.org/debian-security stretch/updates main non-free contrib" >> /etc/apt/sources.list

RUN apt-get update \
    && apt-get install -q -y  --force-yes --no-install-recommends nano curl git wget zip unzip libpq-dev

RUN apt-get install -y --force-yes libmemcached11 libmemcachedutil2 build-essential libmemcached-dev libz-dev \
    && pecl install memcached-2.2.0 \
    && echo extension=memcached.so >> /usr/local/etc/php/conf.d/memcached.ini

RUN apt-get install -y --force-yes \
        libssl-dev libxslt1-dev \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libzip-dev \
        zip \
        libmcrypt-dev \
        zlib1g-dev libicu-dev g++ \
        && docker-php-ext-configure intl && docker-php-ext-install intl \
    && docker-php-ext-install  iconv mcrypt ftp \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install  gd

RUN docker-php-ext-install exif gd mbstring intl xsl zip mysql mysqli pdo pdo_pgsql pdo_mysql soap bcmath sockets

RUN pecl install mongodb-1.4.1 && echo "extension=mongodb.so" >> /usr/local/etc/php/conf.d/mongodb.ini
RUN pecl install mongo-1.6.6 && echo "extension=mongo.so" >> /usr/local/etc/php/conf.d/mongo.ini

RUN mkdir -p $COMPOSER_HOME \
&& curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
&& composer --version

RUN pecl install xdebug-2.5.5

ADD crontab /etc/cron.d/hello-cron
RUN chmod 0644 /etc/cron.d/hello-cron
RUN touch /var/log/cron.log
RUN apt-get update
RUN apt-get -y --force-yes install cron

RUN apt-get install -y --reinstall procps

RUN rm -rf /etc/localtime && ln -s /usr/share/zoneinfo/Asia/Istanbul /etc/localtime

ARG XDEBUG_HOST
ARG XDEBUG_PORT
RUN echo "zend_extension=xdebug.so" >> /usr/local/etc/php/conf.d/xdebug.ini
RUN echo "xdebug.remote_enable=1" >> /usr/local/etc/php/conf.d/xdebug.ini \
   && echo "xdebug.remote_autostart=1" >> /usr/local/etc/php/conf.d/xdebug.ini &&\
   echo "xdebug.remote_connect_back=${XDEBUG_REMOTE_CONNECT_BACK}" >> /usr/local/etc/php/conf.d/xdebug.ini &&\
   echo "xdebug.remote_handler = dbgp" >> /usr/local/etc/php/conf.d/xdebug.ini &&\
   echo "xdebug.remote_mode = req" >> /usr/local/etc/php/conf.d/xdebug.ini &&\
   echo "xdebug.remote_host=${XDEBUG_HOST}" >> /usr/local/etc/php/conf.d/xdebug.ini &&\
   echo "xdebug.remote_port=${XDEBUG_PORT}" >> /usr/local/etc/php/conf.d/xdebug.ini

CMD cron & php-fpm