FROM php:7.1.4-fpm-alpine

RUN apk add --update --no-cache \
        git \
        mysql-client \
        curl \
        mc \
        # gd
        freetype-dev libpng-dev libwebp-dev jpeg-dev \
        # mcrypt
        libmcrypt-dev \
        # xsl
        libxslt-dev \ 
        # intl
        icu-dev \ 
        # Other
        openssh zlib-dev \
    && docker-php-ext-configure \
        gd --with-png-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
        --with-webp-dir=/usr/include/ --with-freetype-dir=/usr/include/ \
    && docker-php-ext-install -j$(getconf _NPROCESSORS_ONLN) \
    # intl iconv mcrypt gd pdo_mysql zip soap json xsl mbstring 
    # simplexml xml opcache
        gd mcrypt xsl intl pdo_mysql mysqli zip soap opcache \
    && rm -rf /tmp/* \
    # Install composer globally
    && echo "memory_limit=-1" > "$PHP_INI_DIR/conf.d/memory-limit.ini" \
    && curl -sS https://getcomposer.org/installer | \
        php -- --install-dir=/usr/bin/ --filename=composer

COPY php.ini /usr/local/etc/php/
ADD www.conf /usr/local/etc/php-fpm.d/

USER www-data

WORKDIR /var/www/html

CMD ["php-fpm"]

#RUN  dpkg-reconfigure -f noninteractive tzdata
RUN  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
