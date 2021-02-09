FROM php:7.3.3-apache

ENV DEBIAN_FRONTEND="noninteractive"

# Arguments
#ARG DB_CONNECTION
ARG DB_HOST
ARG DB_DATABASE
ARG DB_USERNAME
ARG DB_PASSWORD
ARG DB_SOCKET

# Enviroment
#ENV DB_CONNECTION=$DB_CONNECTION
ENV DB_HOST=$DB_HOST
ENV DB_DATABASE=$DB_DATABASE
ENV DB_USERNAME=$DB_USERNAME
ENV DB_PASSWORD=$DB_PASSWORD
ENV DB_SOCKET=$DB_SOCKET

# Install dependencies
RUN apt-get update && apt-get install -yqq  --no-install-recommends \
  libicu-dev \
  libpq-dev \
  git \
  curl \
  zip \
  unzip \
  libxslt-dev \
  # https://github.com/Safran/RoPA/issues/4
  libzip-dev \
  # https://stackoverflow.com/questions/2977662/php-zip-installation-on-linux
  zlib1g-dev

# Install php modules
RUN docker-php-ext-install \
  intl \
  mbstring \
  pcntl \
  zip \
  opcache \
  soap \
  simplexml \
  pdo \
  xsl \
  calendar \
  exif

# Configure the mysql modules
RUN docker-php-ext-install mysqli \
    && docker-php-ext-configure mysqli \
    && docker-php-ext-enable mysqli

RUN docker-php-ext-install pdo_mysql \
    && docker-php-ext-configure pdo_mysql  \
    && docker-php-ext-enable pdo_mysql

# Install GD
RUN apt-get update && apt-get install -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libmcrypt-dev \
        libxml2-dev \
        libicu-dev \
        g++ \
        libmcrypt-dev

RUN docker-php-ext-install -j$(nproc) iconv \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd

# Clean cache
RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /

# Inject vhost
RUN rm /etc/apache2/sites-available/000-default.conf
COPY ./config/000-default.conf /etc/apache2/sites-available/000-default.conf
RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf

# Install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin/ --filename=composer

# Install app
RUN rm -rf /var/www/html
RUN composer create-project --prefer-dist cakephp/app:4.2 /var/www/html --no-interaction

# Add Cake BIN to system path
ENV CAKEPHP_BIN=/var/www/html/bin
RUN chmod +x -R ${CAKEPHP_BIN}
ENV PATH="${PATH}:${CAKEPHP_BIN}"
ENV CAKEPHP_TASKS_APP=/var/www/html/src/Shell/Task/
ENV CAKEPHP_TASKS_PLUGIN=/var/www/html/vendor/token27/cakephp-queued-plugin/src/Shell/Task/

WORKDIR /var/www/html
# Install plugin
RUN composer require token27/cakephp-queued-plugin:dev-main --no-interaction

# CakePHP additional
RUN composer require cakephp/plugin-installer --no-interaction
RUN composer require cakephp/cakephp-codesniffer --no-interaction
# Install additinal plugins
RUN composer require friendsofcake/search --no-interaction
RUN composer require curl/curl --no-interaction
RUN composer require josegonzalez/dotenv --no-interaction
RUN composer require phpunit/phpunit --no-interaction
RUN composer require phpstan/phpstan --no-interaction

# Load the plugin
RUN cake plugin load Queued

# Inject cakephp app config
RUN rm ./config/app_local.php
COPY ./config/app_local.php ./config/app_local.php

# Inject cakephp queued plugin config
COPY ./config/app_queued.php /var/www/html/config/app_queued.php

# Create tmp directory and make it writable by the web server
RUN mkdir -p \
    ./tmp/cache/models \
    ./tmp/cache/persistent \
    ./tmp/cache/views \
    ./tmp/sessions \
    ${CAKEPHP_TASKS_APP} \
    ${CAKEPHP_TASKS_PLUGIN}

# Inject queued tasks
COPY ./tasks/*  ${CAKEPHP_TASKS_APP}/

#change ownership of our applications
RUN chown -R www-data:www-data .
#change uid and gid of apache to docker user uid/gid
RUN usermod -u 1000 www-data && groupmod -g 1000 www-data
#permission on tmp folder
RUN chmod 755 -R .
RUN chmod 777 -R ./tmp
RUN chmod 777 -R ${CAKEPHP_TASKS_APP}
RUN chmod 777 -R ${CAKEPHP_TASKS_PLUGIN}

# Create plugin database schema
#RUN cake migrations migrate -p Queued

# Enable Apache modules and restart
RUN a2enmod rewrite session headers \
  && service apache2 restart

EXPOSE 80


