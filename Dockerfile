FROM php:8.2-apache

# Enable required PHP extensions
RUN docker-php-ext-install mysqli pdo pdo_mysql

# Enable Apache rewrite
RUN a2enmod rewrite

# Disable conflicting MPMs, force prefork
RUN a2dismod mpm_event mpm_worker || true
RUN a2enmod mpm_prefork

# Download WordPress
WORKDIR /var/www/html
RUN curl -o wordpress.tar.gz https://wordpress.org/latest.tar.gz \
 && tar -xzf wordpress.tar.gz --strip-components=1 \
 && rm wordpress.tar.gz

# Fix permissions
RUN chown -R www-data:www-data /var/www/html

EXPOSE 80
