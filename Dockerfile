FROM php:7.2-cli-stretch

RUN curl -sS https://getcomposer.org/installer | php
RUN mv composer.phar /usr/local/bin/composer

RUN apt-get update && apt-get install -y wget lsb-release
RUN wget http://packages.couchbase.com/releases/couchbase-release/couchbase-release-1.0-6-amd64.deb
RUN dpkg -i couchbase-release-1.0-6-amd64.deb
RUN rm couchbase-release-1.0-6-amd64.deb
RUN apt-get update && apt-get install -y \
    git libcouchbase-dev zlib1g-dev

RUN docker-php-ext-install zip
RUN docker-php-ext-install sockets

RUN pecl install xdebug
RUN pecl install couchbase
RUN docker-php-ext-enable xdebug
RUN docker-php-ext-enable sockets
RUN docker-php-ext-enable couchbase

RUN echo "xdebug.remote_enable = 1" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
  && echo "xdebug.remote_autostart = 1" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
  && echo "xdebug.remote_host = docker.for.mac.localhost" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
  && echo "xdebug.remote_port = 9001" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
  && echo "xdebug.remote_log = /tmp/xdebug.log" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
  && echo "xdebug.idekey = VSCODE" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini

#PHPUNIT
RUN composer global require "phpunit/phpunit"
ENV PATH /root/.composer/vendor/bin:$PATH
RUN ln -s /root/.composer/vendor/bin/phpunit /usr/bin/phpunit

WORKDIR /app
