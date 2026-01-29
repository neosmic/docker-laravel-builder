# Args
ARG APP_NAME=${APP_NAME}
ARG APP_PORT=${APP_PORT}
ARG TZ=${TZ}
ARG UNAME=${UNAME}
ARG PHP_VERSION=${PHP_VERSION}

# FPM PHP Version
FROM php:${PHP_VERSION}-fpm

# Env Vars
ENV TZ=${TZ}
ENV COMPOSER_ALLOW_SUPERUSER=1
ENV DEBIAN_FRONTEND=noninteractive

# Timezone
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# System Dependencies
RUN apt-get update && apt-get install -y \
    gnupg \
    ca-certificates \
    curl \
    git \
    unzip \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libwebp-dev \
    libzip-dev \
    libonig-dev \
    libxml2-dev \
    libcurl4-openssl-dev \
    libssl-dev \
    libpq-dev \
    && rm -rf /var/lib/apt/lists/*

# GD Library
RUN docker-php-ext-configure gd \
    --with-freetype \
    --with-jpeg \
    --with-webp

# PHP extensions for Laravel
RUN docker-php-ext-install \
    pdo \
    pdo_mysql \
    pdo_pgsql \
    mysqli \
    mbstring \
    zip \
    exif \
    pcntl \
    bcmath \
    opcache \
    gd \
    curl \
    xml

# Xdebug config
RUN pecl install xdebug && docker-php-ext-enable xdebug
COPY conf/xdebug.ini /usr/local/etc/php/conf.d/xdebug.ini

# Composer Install
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# NodeJS LTS
RUN curl -sL https://deb.nodesource.com/setup_lts.x | bash - \
    && apt-get install -y nodejs \
    && npm install -g npm@latest yarn \
    && rm -rf /var/lib/apt/lists/*

# Versions installed
RUN php --version \
    && composer --version \
    && node --version \
    && npm --version

# non-root user
RUN groupmod -o -g 1000 www-data \
    && usermod -o -u 1000 -g www-data www-data \
    && useradd -ms /bin/bash -g www-data ${UNAME:-laravel}

# Workdir
WORKDIR /var/www/html

# Permissions
# RUN chown -R www-data:www-data /var/www/html \
#    && chmod -R 755 /var/www/html \
#    && chmod -R 777 /var/www/html/storage \
#    && chmod -R 777 /var/www/html/bootstrap/cache

# Custom PHP config
COPY conf/php.ini /usr/local/etc/php/conf.d/custom.ini
COPY conf/www.conf /usr/local/etc/php-fpm.d/www.conf

# PHP-FPM Port
EXPOSE 9000

# Switch to non-root user for production (optional)
# USER www-data

# Startup script
COPY startup /usr/local/bin/startup
RUN chmod +x /usr/local/bin/startup

# Execution
CMD ["startup"]