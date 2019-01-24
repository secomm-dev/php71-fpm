FROM php:7.1-fpm-alpine

RUN apk add --update --no-cache \
        # gd
        freetype-dev libpng-dev libwebp-dev jpeg-dev \
        # mcrypt
        libmcrypt-dev \
        # xsl
        libxslt-dev \ 
        # intl
        icu-dev \
        # composer
        curl git subversion openssh zlib-dev \
    && docker-php-ext-configure \
       gd --with-png-dir=/usr/include/ --with-jpeg-dir=/usr/include/ --with-webp-dir=/usr/include/ --with-freetype-dir=/usr/include/ \
    && docker-php-ext-install -j$(getconf _NPROCESSORS_ONLN) \
       # intl iconv mcrypt gd pdo_mysql zip soap json xsl mbstring simplexml xml opcache
       gd mcrypt xsl intl pdo_mysql mysqli zip soap \
    && rm -rf /tmp/* 
    # Install composer globally
RUN echo "memory_limit=-1" > "$PHP_INI_DIR/conf.d/memory-limit.ini" \
    && curl -sS https://getcomposer.org/installer | \
        php -- --install-dir=/usr/bin/ --filename=composer

# Create entrypoint for custom shell commands
RUN mkdir /docker-entrypoint-initphp.d
COPY docker-entrypoint.sh /docker-entrypoint.sh
ENTRYPOINT ["/docker-entrypoint.sh"]

CMD ["php-fpm"]

#RUN  dpkg-reconfigure -f noninteractive tzdata
RUN  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
