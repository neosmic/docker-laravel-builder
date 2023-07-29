FROM ubuntu:22.04

# Copying environment vars
ARG APP_NAME=${APP_NAME}
ARG APP_PORT=${APP_PORT}
ARG TZ=${TZ}
ARG NODE_VERSION=${NODE_VERSION}

# Files and TimeZone
COPY startup /usr/local/bin
RUN chmod 755 /usr/local/bin/startup
RUN apt update
RUN apt install -y tzdata
ENV TZ=${TZ}

# PHP install
RUN apt install -y php php-cli php-common php-json php-opcache php-mysql php-mbstring php-zip php-fpm php-curl php-xml
RUN apt install -y composer
RUN composer global require "laravel/installer=~1.1"
WORKDIR /app

# NodeJS install
ENV URL_NODE=https://deb.nodesource.com/setup_${NODE_VERSION}.x
RUN apt install -y curl
RUN curl -sL $URL_NODE | bash --
RUN apt install -y nodejs
RUN apt autoremove
RUN node --version
RUN npm --version

# Composer and Laravel Script
CMD ["startup"]