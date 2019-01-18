FROM php:7.1.4-fpm-alpine

RUN apk update && apk add --no-cache \
git \
mysql-client \
curl \
mc \
libmcrypt \
libmcrypt-dev \
libxml2-dev \
freetype \
freetype-dev \
libpng \
libpng-dev \
libjpeg-turbo \
libjpeg-turbo-dev g++ make autoconf

RUN docker-php-ext-install mcrypt pdo_mysql soap \
&& rm -rf /tmp/*

RUN docker-php-ext-configure gd \
--with-gd \
--with-freetype-dir=/usr/include/ \
--with-png-dir=/usr/include/ \
--with-jpeg-dir=/usr/include/ \
&& docker-php-ext-install gd \
&& apk del --no-cache freetype freetype-dev libpng libpng-dev libjpeg-turbo libjpeg-turbo-dev \
&& rm -rf /tmp/*

# Install composer globally
RUN echo "Install composer globally"
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin/ --filename=composer

COPY php.ini /usr/local/etc/php/
ADD www.conf /usr/local/etc/php-fpm.d/

USER www-data

WORKDIR /var/www/html

CMD ["php-fpm"]

#RUN  dpkg-reconfigure -f noninteractive tzdata
RUN  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*