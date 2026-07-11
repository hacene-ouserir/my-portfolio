# Use the official PHP image as the base image
FROM php:8.3-apache
# Install Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer
# Enable Apache mod_rewrite
RUN a2enmod rewrite
# Copy the project
COPY . /var/www/html
# Change Apache DocumentRoot to /public
ENV APACHE_DOCUMENT_ROOT=/var/www/html/public
# Update the Apache configuration to use the new DocumentRoot
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' \
    /etc/apache2/sites-available/*.conf \
    /etc/apache2/apache2.conf \
    /etc/apache2/conf-available/*.conf
# Set the ownership of the files to www-data user and group
RUN chown -R www-data:www-data /var/www/html
# Expose port 80 for the web server
EXPOSE 80