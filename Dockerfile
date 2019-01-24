FROM php:7.1.4-fpm-alpine

RUN apk add --update --no-cache \
<<<<<<< HEAD
        git \
        mysql-client \
        curl \
        mc \
=======
        git mysql-client curl mc \
>>>>>>> aaea6f2c250de108ad1af616c085f27d6c678e8e
        # gd
        freetype-dev libpng-dev libwebp-dev jpeg-dev \
        # mcrypt
        libmcrypt-dev \
        # xsl
        libxslt-dev \ 
        # intl
        icu-dev \ 
        # Other
<<<<<<< HEAD
        openssh \
=======
        openssh zlib-dev pcre-dev \
>>>>>>> aaea6f2c250de108ad1af616c085f27d6c678e8e
    && docker-php-ext-configure \
        gd --with-png-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
        --with-webp-dir=/usr/include/ --with-freetype-dir=/usr/include/ \
    && docker-php-ext-install -j$(getconf _NPROCESSORS_ONLN) \
    # intl iconv mcrypt gd pdo_mysql zip soap json xsl mbstring 
    # simplexml xml opcache
        gd mcrypt xsl intl pdo_mysql mysqli zip soap opcache \
    && rm -rf /tmp/* \
    # Install composer globally
<<<<<<< HEAD
    && echo "memory_limit=-1" > "$PHP_INI_DIR/conf.d/memory-limit.ini"
    && curl -sS https://getcomposer.org/installer | \
        php -- --install-dir=/usr/bin/ --filename=composer

# Create entrypoint for custom shell commands
RUN mkdir /docker-entrypoint-initphp.d
COPY docker-entrypoint.sh /docker-entrypoint.sh
ENTRYPOINT ["/docker-entrypoint.sh"]
=======
    && echo "memory_limit=-1" > "$PHP_INI_DIR/conf.d/memory-limit.ini" \
    && curl -sS https://getcomposer.org/installer | \
        php -- --install-dir=/usr/bin/ --filename=composer

COPY php.ini /usr/local/etc/php/
ADD www.conf /usr/local/etc/php-fpm.d/

USER www-data

WORKDIR /var/www/html
>>>>>>> aaea6f2c250de108ad1af616c085f27d6c678e8e

CMD ["php-fpm"]

#RUN  dpkg-reconfigure -f noninteractive tzdata
RUN  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
