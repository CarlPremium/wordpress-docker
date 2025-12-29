FROM php:8.2-fpm

# Install system deps
RUN apt-get update && apt-get install -y \
    nginx \
    curl \
    unzip \
 && rm -rf /var/lib/apt/lists/*

# PHP extensions required by WordPress
RUN docker-php-ext-install mysqli pdo pdo_mysql

# Nginx config
RUN rm /etc/nginx/sites-enabled/default
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Install WordPress
WORKDIR /var/www/html
RUN curl -fsSL https://wordpress.org/latest.tar.gz \
 | tar -xz --strip-components=1

# Permissions
RUN chown -R www-data:www-data /var/www/html

EXPOSE 80

# Start PHP-FPM + Nginx
CMD ["sh", "-c", "php-fpm -D && nginx -g 'daemon off;'"]




