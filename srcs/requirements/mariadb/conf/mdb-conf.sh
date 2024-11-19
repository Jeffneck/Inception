#!/bin/bash

# Start the MariaDB service
service mariadb start
# Wait for 5 seconds to ensure the service is fully up and running
sleep 5

# Create the database if it doesn't already exist
mariadb -e "CREATE DATABASE IF NOT EXISTS \`${MYSQL_DB}\`;"

# Create a new user if it doesn't already exist, with the provided username and password
mariadb -e "CREATE USER IF NOT EXISTS \`${MYSQL_USER}\`@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';"

# Grant all privileges on the specified database to the newly created user
mariadb -e "GRANT ALL PRIVILEGES ON ${MYSQL_DB}.* TO \`${MYSQL_USER}\`@'%';"

# Refresh the privilege tables to apply changes
mariadb -e "FLUSH PRIVILEGES"

# Shut down the MariaDB service gracefully using the root password
mysqladmin -u root -p$MYSQL_ROOT_PASSWORD shutdown

# Start MariaDB in a safe mode with specified port and binding to all network interfaces
mysqld_safe --port=3306 --bind-address=0.0.0.0 --datadir='/var/lib/mysql'
