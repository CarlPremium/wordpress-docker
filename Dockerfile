FROM php:8.2-fpm

# Install required packages
RUN apt-get update && apt-get install -y \
    nginx \
    curl \
    unzip \
 && rm -rf /var/lib/apt/lists/*

# PHP extensions required by WordPress
RUN docker-php-ext-install mysqli pdo pdo_mysql

# Remove ALL default nginx configs and welcome page
RUN rm -rf /etc/nginx/sites-enabled \
           /etc/nginx/sites-available \
           /usr/share/nginx/html \
 && mkdir -p /etc/nginx/conf.d

# Copy our single nginx config
COPY nginx.conf /etc/nginx/conf.d/wordpress.conf

# Install WordPress
WORKDIR /var/www/html
RUN curl -fsSL https://wordpress.org/latest.tar.gz \
 | tar -xz --strip-components=1

# Permissions
RUN chown -R www-data:www-data /var/www/html

EXPOSE 80

# Start services
CMD ["sh", "-c", "php-fpm -D && nginx -g 'daemon off;'"]









