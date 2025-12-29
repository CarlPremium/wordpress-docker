FROM php:8.2-fpm

# Install packages
RUN apt-get update && apt-get install -y \
    nginx \
    curl \
    unzip \
 && rm -rf /var/lib/apt/lists/*

# PHP extensions
RUN docker-php-ext-install mysqli pdo pdo_mysql

# Remove nginx site configs but KEEP core files like mime.types
RUN rm -rf /etc/nginx/sites-enabled \
           /etc/nginx/sites-available \
           /etc/nginx/conf.d


# Recreate nginx folders
RUN mkdir -p /etc/nginx/conf.d

# Copy OUR nginx configs
COPY nginx-main.conf /etc/nginx/nginx.conf
COPY nginx.conf /etc/nginx/conf.d/wordpress.conf

# Install WordPress
WORKDIR /var/www/html
RUN curl -fsSL https://wordpress.org/latest.tar.gz \
 | tar -xz --strip-components=1

RUN chown -R www-data:www-data /var/www/html

# Increase PHP upload limits
RUN echo "upload_max_filesize=200M" > /usr/local/etc/php/conf.d/uploads.ini \
 && echo "post_max_size=200M" >> /usr/local/etc/php/conf.d/uploads.ini \
 && echo "memory_limit=512M" >> /usr/local/etc/php/conf.d/uploads.ini \
 && echo "max_execution_time=300" >> /usr/local/etc/php/conf.d/uploads.ini


EXPOSE 80

CMD ["sh", "-c", "php-fpm -D && nginx -g 'daemon off;'"]















