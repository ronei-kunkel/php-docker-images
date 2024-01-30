FROM php:8.2-fpm-alpine

USER root

WORKDIR /

RUN apk --no-cache add \
  build-base \
  openssl \
  freetype-dev \
  libjpeg-turbo-dev \
  libpng-dev \
  libwebp-dev \
  zlib-dev \
  libzip-dev \
  nano \
  unzip \
  curl \
  git \
  jpegoptim \
  optipng \
  pngquant \
  gifsicle \
  oniguruma-dev \
  gmp-dev \
  libsodium-dev \
  pcre-dev \
  bzip2-dev \
  icu-dev \
  tzdata \
  linux-headers \
  libwebp-dev \
  autoconf \
  && echo 'America/Sao_Paulo' > /etc/timezone \
  && ln -sf /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime \
  && rm -rf /var/cache/apk/* \
  && apk del build-base

RUN docker-php-ext-configure gd \
  --with-freetype=/usr/include/ \
  --with-jpeg=/usr/include/ \
  --with-webp=/usr/include/

COPY --from=mlocati/php-extension-installer /usr/bin/install-php-extensions /usr/local/bin/
RUN install-php-extensions uopz gd gmp pdo_mysql mbstring pdo exif sockets sodium bcmath zip intl pcntl bz2

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

EXPOSE 9000

CMD sh -c "php-fpm"
