FROM jebovic/alpine-nginx:latest

MAINTAINER Jérémy Baumgarth

# Install php
RUN apk update && \
    apk upgrade && \
    apk add --update libressl libressl-dev libssl1.0 supervisor redis \
    php5 \
    php5-fpm \
    php5-pdo \
    php5-zlib \
    php5-phar \
    php5-openssl \
    php5-cli \
    php5-common \
    php5-dev \
    php5-opcache \
    #php5-mbstring \
    php5-gd \
    php5-intl \
    php5-memcached \
    php5-mysql \
    php5-redis \
    php5-curl \
    php5-json \
    php5-xsl \
    php5-xml \
    php5-pear \
    php5-imagick \
    mongo-php5-driver \
    --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing/ \
    --repository http://dl-cdn.alpinelinux.org/alpine/edge/community/ \
    --repository http://dl-cdn.alpinelinux.org/alpine/edge/main/ && \
    #pecl install mongodb && \
    mkdir /var/log/supervisor && \
    rm -rf /var/cache/apk/*

# Nginx configuration
RUN rm /etc/nginx/conf.d/*
COPY config/nginx/conf.d/ /etc/nginx/conf.d/

# PHP configuration
COPY config/php/php-fpm.conf /etc/php5/php-fpm.conf
COPY config/php/php-fpm.d/ /etc/php5/fpm.d/
COPY config/php/conf.d/ /etc/php5/conf.d/

# Redis configuration
COPY config/redis/redis.conf /etc/redis.conf

# Default pages
COPY src/ /var/www/

# Configure supervisord
COPY config/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# init scrip
COPY init_script.sh /init_script.sh
RUN chmod +x /init_script.sh

CMD ["/bin/sh", "/init_script.sh"]
