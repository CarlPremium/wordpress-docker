FROM php:8.2-fpm

# Install deps
RUN apt-get update && apt-get install -y \
    nginx \
    curl \
    unzip \
 && rm -rf /var/lib/apt/lists/*

# PHP extensions
RUN docker-php-ext-install mysqli pdo pdo_mysql

# REMOVE all default nginx configs + disable sites-enabled entirely
RUN rm -rf /etc/nginx/sites-enabled /etc/nginx/sites-available \
 && mkdir -p /etc/nginx/conf.d

# Copy our only nginx config
COPY nginx.conf /etc/nginx/conf.d/wordpress.conf

# WordPress
WORKDIR /var/www/html
RUN curl -fsSL https://wordpress.org/latest.tar.gz \
 | tar -xz --strip-components=1

RUN chown -R www-data:www-data /var/www/html

EXPOSE 80

CMD ["sh", "-c", "php-fpm -D && nginx -g 'daemon off;'"]







