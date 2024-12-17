FROM php:8.1-fpm


RUN apt-get update \
   && apt-get install --no-install-recommends -y \
   libfreetype6-dev \
   libpq-dev \
   libjpeg62-turbo-dev \
   libmcrypt-dev \
   inetutils-ping \
   libpng-dev \
   zlib1g-dev \
   libicu-dev \
   libonig-dev \
   g++ \
   unixodbc-dev \
   libxml2-dev \
   libzip-dev \
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
   wget


# Add Microsoft repository for SQL Server drivers
RUN curl -sSL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor -o /usr/share/keyrings/microsoft-archive-keyring.gpg \
   && echo "deb [signed-by=/usr/share/keyrings/microsoft-archive-keyring.gpg] https://packages.microsoft.com/ubuntu/20.04/prod focal main" > /etc/apt/sources.list.d/mssql-release.list \
   && apt-get update \
   && ACCEPT_EULA=Y apt-get install -y msodbcsql18 mssql-tools18 unixodbc-dev \
   && apt-get clean -y \
   && echo 'export PATH="$PATH:/opt/mssql-tools18/bin"' >> ~/.bashrc


# Install SQLSRV and PDO_SQLSRV extensions
RUN pecl install sqlsrv pdo_sqlsrv \
   && docker-php-ext-enable sqlsrv pdo_sqlsrv


RUN docker-php-ext-install pdo_pgsql


RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
   && composer --version


RUN pecl install redis \
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
       redis \
       memcached \
       opcache \
       mongodb


RUN pecl install xdebug-3.1.4
RUN docker-php-ext-enable xdebug


ARG XDEBUG_HOST
ARG XDEBUG_PORT


RUN apt-get install -y git
RUN echo "xdebug.mode=debug" >> /usr/local/etc/php/conf.d/xdebug.ini \
  && echo "xdebug.start_with_request = yes" >> /usr/local/etc/php/conf.d/xdebug.ini \
  && echo "xdebug.discover_client_host=${XDEBUG_REMOTE_CONNECT_BACK}" >> /usr/local/etc/php/conf.d/xdebug.ini \
  && echo "xdebug.client_host=$XDEBUG_HOST" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
  && echo "xdebug.client_port=$XDEBUG_PORT" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini


RUN echo "extension=yaml.so" > /usr/local/etc/php/conf.d/yaml.ini


ADD crontab /etc/cron.d/hello-cron
RUN chmod 0644 /etc/cron.d/hello-cron
RUN touch /var/log/cron.log
RUN apt-get update
RUN apt-get -y install cron
CMD cron & php-fpm

