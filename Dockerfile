FROM php:7.4-fpm

WORKDIR /var/www

#Install system depedencies
RUN apt-get update \
    && apt-get install --qoute --yes --no-install-recommends \
     git \
     curl \
     libpng-dev \
     libonig-dev \
     libxml2-dev \
     zip \
     unzip

# Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

#Install PHP extensions
RUN  docker-php-ext-install zip unzip pdo pdo_mysql \
      mbstring exif pcntl bcmath gd \
    && pecl install -o -f redis-5.1.1 \
    && docker-php-ext-enable redis \

# Get latest Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

#Adding user, groups and permissions

RUN groupadd --gid 1000 appuser \
    && useradd --uid 1000 -g appuser \
        -G wwww-data,root --shell /bin/bash \
        --create-home appuser \
COPY --chown=www:www . /var/www

USER appuser
