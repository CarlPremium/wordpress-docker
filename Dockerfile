FROM php:8.2-apache

# Remove all MPMs first (important)
RUN rm -f /etc/apache2/mods-enabled/mpm_*.load

# Enable ONLY prefork (PHP mod_php requires this)
RUN a2enmod mpm_prefork

# PHP extensions
RUN docker-php-ext-install mysqli pdo pdo_mysql

# Apache rewrite
RUN a2enmod rewrite

# Install WordPress
WORKDIR /var/www/html
RUN curl -fsSL https://wordpress.org/latest.tar.gz \
 | tar -xz --strip-components=1

# Permissions
RUN chown -R www-data:www-data /var/www/html

EXPOSE 80


