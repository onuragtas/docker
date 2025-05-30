FROM php:7.2-fpm

RUN apt-get update \
    && apt-get install --no-install-recommends -y \
     	libssh2-1-dev \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libmcrypt-dev \
        inetutils-ping \
        libpng-dev \
        zlib1g-dev \
        libicu-dev \
        g++ \
        unixodbc-dev \
    libzip-dev \
            zip \
            unzip \
        libxml2-dev \
        libaio-dev \
        libmemcached-dev \
        freetds-dev \
        libyaml-dev \
	libssl-dev \
	openssl \
	libcurl4-gnutls-dev \
	libpq-dev

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
&& composer --version

RUN rm -rf /etc/localtime && ln -s /usr/share/zoneinfo/Asia/Istanbul /etc/localtime


RUN docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && pecl install redis-5.3.6 \
    && pecl install memcached-3.0.0 \
    && pecl install mongodb-1.5.3 \
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
            pgsql \
            pdo_pgsql \
    && docker-php-ext-enable \
            redis \
            memcached \
            opcache \
            mongodb


RUN pecl install xdebug-2.9.8
RUN docker-php-ext-enable xdebug

RUN pecl install ssh2-1.3.1 \
    && docker-php-ext-enable ssh2

RUN docker-php-ext-install bcmath

RUN echo "extension=yaml.so" > /usr/local/etc/php/conf.d/yaml.ini

ENV PHALCON_VERSION=3.2.4

RUN curl -sSL "https://codeload.github.com/phalcon/cphalcon/tar.gz/v${PHALCON_VERSION}" | tar -xz \
    && cd cphalcon-${PHALCON_VERSION}/build \
    && ./install \
    && cp ../tests/_ci/phalcon.ini $(php-config --configure-options | grep -o "with-config-file-scan-dir=\([^ ]*\)" | awk -F'=' '{print $2}') \
    && cd ../../ \
    && rm -r cphalcon-${PHALCON_VERSION}

ADD crontab /etc/cron.d/hello-cron
RUN chmod 0644 /etc/cron.d/hello-cron
RUN touch /var/log/cron.log
RUN apt-get update
RUN apt-get -y install cron
RUN apt-get install -y git

RUN apt-get install -y --reinstall procps

ARG XDEBUG_HOST
ARG XDEBUG_PORT

RUN echo "xdebug.remote_enable=1" >> /usr/local/etc/php/conf.d/xdebug.ini \
   && echo "xdebug.remote_autostart=1" >> /usr/local/etc/php/conf.d/xdebug.ini &&\
   echo "xdebug.remote_connect_back=${XDEBUG_REMOTE_CONNECT_BACK}" >> /usr/local/etc/php/conf.d/xdebug.ini &&\
   echo "xdebug.remote_handler = dbgp" >> /usr/local/etc/php/conf.d/xdebug.ini &&\
   echo "xdebug.remote_mode = req" >> /usr/local/etc/php/conf.d/xdebug.ini &&\
   echo "xdebug.remote_host=$XDEBUG_HOST" >> /usr/local/etc/php/conf.d/xdebug.ini &&\
   echo "xdebug.remote_port=$XDEBUG_PORT" >> /usr/local/etc/php/conf.d/xdebug.ini

CMD cron & php-fpm
