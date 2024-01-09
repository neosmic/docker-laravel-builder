FROM ubuntu:22.04

# Copying environment vars
ARG APP_NAME=${APP_NAME}
ARG APP_PORT=${APP_PORT}
ARG TZ=${TZ}
ARG NODE_VERSION=${NODE_VERSION}
ARG UNAME=${UNAME}
ARG PHP_VERSION=${PHP_VERSION}

# Files and TimeZone
COPY startup /usr/local/bin
RUN chmod 755 /usr/local/bin/startup
RUN apt update
RUN apt install -y tzdata
ENV TZ=${TZ}

# PHP install
RUN apt update
RUN apt install software-properties-common gnupg2 -y
RUN add-apt-repository ppa:ondrej/php
RUN apt update -y

RUN apt install -y php$PHP_VERSION \
    php$PHP_VERSION-cli \
    php$PHP_VERSION-common \ 
    php$PHP_VERSION-opcache \ 
    php$PHP_VERSION-mysql \ 
    php-mbstring \ 
    php$PHP_VERSION-zip \ 
    php$PHP_VERSION-fpm \ 
    php$PHP_VERSION-curl \ 
    php$PHP_VERSION-xml \
    php-json

# Xdebug
RUN apt install php$PHP_VERSION-xdebug

RUN echo "xdebug.mode=debug"  >> /etc/php/$PHP_VERSION/cli/conf.d/20-xdebug.ini
RUN echo "xdebug.start_with_request=yes"  >> /etc/php/$PHP_VERSION/cli/conf.d/20-xdebug.ini
RUN echo "xdebug.client_host=host.docker.internal"  >> /etc/php/$PHP_VERSION/cli/conf.d/20-xdebug.ini
RUN echo "xdebug.remote_enable=off"  >> /etc/php/$PHP_VERSION/cli/conf.d/20-xdebug.ini
RUN echo "xdebug.discover_client_host=1"  >> /etc/php/$PHP_VERSION/cli/conf.d/20-xdebug.ini
RUN echo "xdebug.remote_port=9003"  >> /etc/php/$PHP_VERSION/cli/conf.d/20-xdebug.ini

EXPOSE 9003

RUN apt update
RUN apt install -y composer
RUN composer global require "laravel/installer=~1.1"
WORKDIR /app

# NodeJS install
RUN apt update
RUN apt install -y ca-certificates curl gnupg
RUN mkdir -p /etc/apt/keyrings
RUN curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg
ENV NODE_MAJOR=${NODE_VERSION}
RUN echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_$NODE_MAJOR.x nodistro main" | tee /etc/apt/sources.list.d/nodesource.list
RUN apt update
RUN apt install -y nodejs
RUN apt autoremove
RUN node --version
RUN npm --version

# User permission
RUN useradd -ms /bin/bash -g www-data ${UNAME}
RUN chown -R ${UNAME}:1000 /app

# Uncomment for local development after creating files. See documentation
# USER 1000:www-data

# Composer and Laravel Script
CMD ["startup"]