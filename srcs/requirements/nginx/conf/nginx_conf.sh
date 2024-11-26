#!/bin/bash

# Function to check if MariaDB is up (on port 3306)
ping_mariadb_container() {
    nc -zv mariadb 3306 > /dev/null 2>&1  # Using netcat to check connectivity
    return $?  # Return the exit status of the netcat command (0 if successful)
}

# Function to check if WordPress is ready (by making an HTTP request)
check_wp_ready() {
    curl -s http://wordpress:80 > /dev/null  # Check if WordPress responds on port 80
    return $?  # Return the exit status of the curl command (0 if WordPress is up)
}

# Set the start time for the wait loop
start_time=$(date +%s)
# Set the timeout duration (60 seconds)
end_time=$((start_time + 60))  # Wait for up to 60 seconds maximum

# Loop to check if both MariaDB and WordPress are ready
while [ $(date +%s) -lt $end_time ]; do
    ping_mariadb_container
    if [ $? -eq 0 ]; then
        echo "NGINX CONTAINER: [===== MARIA DB IS READY =====]"
        
        check_wp_ready
        if [ $? -eq 0 ]; then
            echo "NGINX CONTAINER: [===== WORDPRESS IS READY =====]"
            break
        else
            echo "NGINX CONTAINER: [===== WAITING FOR WORDPRESS TO BE READY =====]"
        fi
    else
        echo "NGINX CONTAINER: [===== WAITING FOR MARIA DB =====]"
    fi
    sleep 5  # Wait for 5 seconds before retrying
done

# If the timeout is reached and WordPress is still not ready
if [ $(date +%s) -ge $end_time ]; then
    echo "NGINX CONTAINER: [===== TIMEOUT REACHED, WORDPRESS IS NOT READY =====]"
    exit 1  # Exit with an error code if the timeout is reached
fi

# Start NGINX after WordPress is ready
echo "NGINX CONTAINER: [===== STARTING NGINX =====]"

# Nginx will be executed in the foreground (necessary to keep the container active) instead of in the background (= not in daemon mode)
nginx -g "daemon off;"
