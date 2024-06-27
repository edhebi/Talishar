FROM php:8.3.8-apache

# Runtime dependencies

RUN apt-get update && apt-get install -y \
    libc-client-dev libkrb5-dev libxslt-dev \
    libbz2-dev libzip-dev \
    libssh2-1-dev

RUN rm -r /var/lib/apt/lists/*
COPY --from=composer/composer:2.7.7-bin /composer /usr/bin/composer

# Extensions

RUN docker-php-ext-configure imap --with-kerberos --with-imap-ssl
RUN docker-php-ext-install imap zip bz2 shmop mysqli pdo pdo_mysql

RUN pecl install -of redis ssh2-1.4 \
    && rm -rf /tmp/pear \
    && docker-php-ext-enable redis ssh2

# Configuration

RUN cp "$PHP_INI_DIR/php.ini-development" "$PHP_INI_DIR/php.ini"
