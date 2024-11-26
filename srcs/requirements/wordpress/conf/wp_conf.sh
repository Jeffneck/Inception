#!/bin/bash

# Download the WP-CLI phar file
curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar

# Make the WP-CLI file executable
chmod +x wp-cli.phar

# Move the WP-CLI file to a directory in the system path
mv wp-cli.phar /usr/local/bin/wp

# Navigate to the WordPress installation directory
cd /var/www/wordpress

# Set permissions to 755 for all files and directories (read, write, execute)
chmod -R 755 /var/www/wordpress/

# Change ownership of the WordPress directory to the web server user and group
chown -R www-data:www-data /var/www/wordpress

# Function to check if the MariaDB container is up and listening on port 3306
ping_mariadb_container() {
	nc -zv mariadb 3306 > /dev/null  # Use netcat to check connectivity
	return $?  # Return the exit status of the netcat command
}

# Set the start time for the wait loop
start_time=$(date +%s)
# Set the timeout duration (60 seconds)
end_time=$((start_time + 60))

# Loop until the timeout is reached, checking if MariaDB is up
while [ $(date +%s) -lt $end_time ]; do
	ping_mariadb_container
	if [ $? -eq 0 ]; then
		echo "WORDPRESS CONTAINER: [===== MARIA DB IS READY =====]"  # Success message
		break
	else
		echo "WORDPRESS CONTAINER: [===== WAITING FOR MARIA DB =====]"  # Waiting message
		sleep 1  # Wait for 1 second before retrying
	fi
done

# Check if the loop reached the timeout without success
if [ $(date +%s) -ge $end_time ]; then
	echo "WORDPRESS CONTAINER: [=====MARIADB IS NOT RESPONDING=====]"  # Timeout message
fi

# Download the WordPress core files
wp core download --allow-root

# Generate the WordPress configuration file with database details
wp core config --dbhost=mariadb:3306 --dbname="$MYSQL_DB" --dbuser="$MYSQL_USER" --dbpass="$MYSQL_PASSWORD" --allow-root

# Install WordPress with the specified site details and admin credentials
wp core install --url="$DOMAIN_NAME" --title="$WP_TITLE" --admin_user="$WP_ADMIN_N" --admin_password="$WP_ADMIN_P" --admin_email="$WP_ADMIN_E" --allow-root

# Create an additional WordPress user with specified credentials and role
wp user create "$WP_U_NAME" "$WP_U_EMAIL" --user_pass="$WP_U_PASS" --role="$WP_U_ROLE" --allow-root

# Update the PHP-FPM configuration to listen on port 9000 instead of a Unix socket
sed -i '36 s@/run/php/php7.4-fpm.sock@9000@' /etc/php/7.4/fpm/pool.d/www.conf

# Create the PHP-FPM runtime directory if it doesn't exist
mkdir -p /run/php

# Start PHP-FPM in the foreground
/usr/sbin/php-fpm7.4 -F



# 1. What is wp-cli.phar?
# wp-cli.phar is an executable file of the WP-CLI (WordPress Command Line Interface) tool, 
# which lets you manage a WordPress site via command-line commands. 
# It's a stand-alone PHP archive (phar) that contains all the code needed to run WP-CLI. 
# With this tool, you can perform various tasks such as installing WordPress, 
# managing plugins and themes, creating users, updating the site, and much more, 
# in an automated and scripted way, without having to go through the GUI.

# 2. Meaning of --allow-root
# The --allow-root option in WP-CLI allows you to run WP-CLI commands with root privileges. 
# By default, WP-CLI prevents the execution of commands as root for security reasons, 
# as this can increase the risk of executing scripts with elevated privileges and compromising server security. 
# However, when using WP-CLI in a controlled environment, 
# such as in an installation script or a Docker container where it is necessary to manage WordPress as root,
# this option allows you to bypass this limitation.

# 3. Why change the owner group to www-data?
# www-data is the default user and group used by many web servers such as Apache and NGINX to run processes. 
# Changing the owner group from /var/www/wordpress to www-data ensures that the web server has the necessary permissions to access, 
# read and write the WordPress directory. This ensures that WordPress can :
# -Load and serve files correctly to visitors.
# -Record downloads, create cache files, and perform other read/write operations.

# Failure to define the owner group in this way could lead to authorization problems 
# that prevent the site from functioning properly, as the web server may not have the required 
# rights to interact with WordPress files.
