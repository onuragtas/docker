FROM php:8.4-fpm

ENV ACCEPT_EULA=Y

# Sistem bağımlılıkları
RUN apt-get update && apt-get install --no-install-recommends -y \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libpng-dev \
    zlib1g-dev \
    libicu-dev \
    libonig-dev \
    g++ \
    libxml2-dev \
    libzip-dev \
    libpq-dev \
    libaio-dev \
    libmemcached-dev \
    freetds-dev \
    libyaml-dev \
    libssl-dev \
    openssl \
    libcurl4-gnutls-dev \
    apt-transport-https \
    gnupg2 \
    curl \
    wget \
    git \
    inetutils-ping \
    unixodbc-dev \
    cron \
    librdkafka-dev \
    pkg-config \
    && apt-get clean

# Microsoft SQL Server sürücüleri
RUN curl -sSL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor -o /usr/share/keyrings/microsoft-archive-keyring.gpg && \
    echo "deb [signed-by=/usr/share/keyrings/microsoft-archive-keyring.gpg] https://packages.microsoft.com/ubuntu/20.04/prod focal main" > /etc/apt/sources.list.d/mssql-release.list && \
    apt-get update && \
    apt-get install -y msodbcsql18 mssql-tools18 unixodbc-dev && \
    echo 'export PATH="$PATH:/opt/mssql-tools18/bin"' >> ~/.bashrc

# PHP Kafka uzantısı kurulumu
RUN pecl install rdkafka \
 && echo "extension=rdkafka.so" > /usr/local/etc/php/conf.d/rdkafka.ini

# YAML uzantısı kurulumu
RUN pecl install yaml \
 && echo "extension=yaml.so" > /usr/local/etc/php/conf.d/yaml.ini

# Derleyici güncellemeleri
RUN apt-get update && apt-get install -y gcc-11 g++-11 \
 && update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-11 100 \
 && update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-11 100

# PHP uzantılarının kurulumu
RUN docker-php-ext-configure gd --with-freetype --with-jpeg && \
    docker-php-ext-install -j$(nproc) \
        curl \
        iconv \
        mbstring \
        intl \
        gd \
        exif \
        mysqli \
        pdo_mysql \
        pdo_pgsql \
        soap \
        sockets \
        zip \
        pcntl \
        ftp \
        opcache

# Xdebug kurulumu (PHP 8.4 uyumlu)
RUN pecl install xdebug-3.4.2 \
  && docker-php-ext-enable xdebug

# Xdebug konfigürasyonu
ARG XDEBUG_HOST
ARG XDEBUG_PORT

RUN echo "xdebug.mode=debug" >> /usr/local/etc/php/conf.d/xdebug.ini \
 && echo "xdebug.start_with_request=yes" >> /usr/local/etc/php/conf.d/xdebug.ini \
 && echo "xdebug.discover_client_host=1" >> /usr/local/etc/php/conf.d/xdebug.ini \
 && echo "xdebug.client_host=$XDEBUG_HOST" >> /usr/local/etc/php/conf.d/xdebug.ini \
 && echo "xdebug.client_port=$XDEBUG_PORT" >> /usr/local/etc/php/conf.d/xdebug.ini

RUN echo "zend.exception_ignore_args=Off" > /usr/local/etc/php/conf.d/zend-exception.ini

# Composer kurulumu
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
    && composer --version

# Cron job ekleme
ADD crontab /etc/cron.d/hello-cron
RUN chmod 0644 /etc/cron.d/hello-cron && touch /var/log/cron.log

# Başlangıç komutu
CMD cron && php-fpm