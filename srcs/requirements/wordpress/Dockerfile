FROM debian:bullseye

RUN apt-get update && apt-get upgrade -y

RUN apt-get install -y curl php php7.4-fpm php-mysql mariadb-client netcat
# This command installs essential packages for a WordPress container:
# - curl: Used for making HTTP requests, essential for downloading and interacting with external resources.
# - php: The core PHP package needed to run WordPress.
# - php7.4-fpm: PHP FastCGI Process Manager, which handles PHP requests efficiently, crucial for performance.
# - php-mysql: PHP extension that enables PHP to communicate with MySQL/MariaDB databases, allowing WordPress to access and manage its database.
# - mariadb-client: A client for connecting to MariaDB/MySQL databases, useful for database management and verification.
# - netcat: A networking utility used to check the connectivity to the MariaDB container, ensuring the database is up before starting WordPress.

# copy the config executable to the root
COPY /conf/wp_conf.sh /

RUN chmod +x wp_conf.sh

# script to run when the container is made 
ENTRYPOINT ["/bin/bash", "./wp_conf.sh"]
