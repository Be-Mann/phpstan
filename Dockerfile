FROM php:8.5-cli-alpine

# --------------------------------------------------
# System Dependencies
# --------------------------------------------------
RUN apk add --no-cache \
    $PHPIZE_DEPS \
    linux-headers \
    git \
    unzip \
    icu-dev \
    libzip-dev \
    libpng-dev \
    libjpeg-turbo-dev \
    freetype-dev \
    libsodium-dev \
    ca-certificates

# --------------------------------------------------
# PHP Extensions
# --------------------------------------------------
RUN docker-php-ext-configure gd --with-freetype --with-jpeg \
 && docker-php-ext-install \
    gd \
    exif \
    sockets \
    intl \
    zip \
    sodium

# --------------------------------------------------
# PHP Config
# --------------------------------------------------
RUN echo "memory_limit=-1" > /usr/local/etc/php/conf.d/memory.ini

# --------------------------------------------------
# Composer
# --------------------------------------------------
ENV COMPOSER_HOME=/composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# --------------------------------------------------
# PHPStan
# --------------------------------------------------
RUN composer global require phpstan/phpstan \
 && ln -s /composer/vendor/bin/phpstan /usr/local/bin/phpstan

# --------------------------------------------------
# Workdir
# --------------------------------------------------
WORKDIR /app
VOLUME /app

ENTRYPOINT ["phpstan"]
CMD ["analyse"]
