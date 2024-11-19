# Use Debian Bullseye as the base image
FROM debian:bullseye

# Update and upgrade the system packages
RUN apt-get update && apt-get upgrade -y

# Install NGINX and OpenSSL for running the web server and generating SSL certificates
RUN apt-get install -y nginx openssl

# Create a directory for storing SSL certificates
RUN mkdir -p /etc/nginx/ssl

# Generate a self-signed SSL certificate (not certified) and key with specified details
RUN openssl req -x509 -nodes -out /etc/nginx/ssl/inception.crt -keyout \
    /etc/nginx/ssl/inception.key -subj "/C=FR/ST=ARA/L=LYON/O=42/OU=42/CN=hanglade.42.fr/UID=hanglade42"

# Copy the NGINX configuration file from the host to the container
COPY /conf/nginx.conf /etc/nginx/nginx.conf

# Create the WordPress directory where files will be served
RUN mkdir -p /var/www/wordpress

# Change ownership of the WordPress directory to the NGINX user for proper permissions
RUN chown -R www-data:www-data /var/www/wordpress

# cmd used when container start NGINX in the foreground to keep the container running
CMD ["nginx", "-g", "daemon off;"]
