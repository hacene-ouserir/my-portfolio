# Use the official PHP image with Apache
FROM php:8.3-apache
# Install system packages and PHP extensions
RUN apt-get update && apt-get install -y \
    unzip \
    libzip-dev \
    && docker-php-ext-install zip \
    && rm -rf /var/lib/apt/lists/*
# Install Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer
# Enable Apache rewrite
RUN a2enmod rewrite
# Set the working directory
WORKDIR /var/www/html
# Copy Composer files first (improves Docker cache)
COPY composer.json composer.lock ./
# Install PHP dependencies
RUN composer install \
    --no-dev \
    --optimize-autoloader \
    --no-interaction
# Copy the rest of the application
COPY . .
# Configure Apache to serve the public directory
ENV APACHE_DOCUMENT_ROOT=/var/www/html/public
# Update the Apache configuration to use the new document root
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' \
    /etc/apache2/sites-available/*.conf \
    /etc/apache2/apache2.conf \
    /etc/apache2/conf-available/*.conf
# Set the ownership of the files to www-data user and group
RUN chown -R www-data:www-data /var/www/html
# Expose port 80 for the web server
EXPOSE 80