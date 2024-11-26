# Define the paths for persistent data storage
WP_DATA = /home/hanglade/data/wordpress  # Path for WordPress data
DB_DATA = /home/hanglade/data/mariadb  # Path for MariaDB data

# Define the Docker Compose command with the correct file location
DOCKER_COMPOSE = docker compose -f srcs/docker-compose.yml  # Command to run Docker Compose with the specific file

# Default target: start the application by bringing up the containers
all: up  # The default action is to run the 'up' target

# Target to bring up the containers
up: build  # First, build the images before bringing up the containers
	@mkdir -p $(WP_DATA)  # Create the WordPress data directory if it doesn't exist
	@mkdir -p $(DB_DATA)  # Create the MariaDB data directory if it doesn't exist
	$(DOCKER_COMPOSE) up -d  # Use Docker Compose to start the containers in detached mode

# Target to build the Docker images defined in the Docker Compose file
build:
	$(DOCKER_COMPOSE) build  # Build the images using the Docker Compose file

# Target to start the containers without rebuilding
start:
	$(DOCKER_COMPOSE) start  # Start the containers that are already created but stopped

# Target to stop the running containers without removing them
stop:
	$(DOCKER_COMPOSE) stop  # Stop the running containers without removing them

# Target to bring down the entire Docker Compose setup (stops and removes containers)
down:
	$(DOCKER_COMPOSE) down  # Stop and remove containers, networks, and volumes defined in the Compose file

# Target to clean up stopped containers, unused images, and data directories
clean:
	@docker stop $$(docker ps -qa) || true  # Stop all containers (ignore errors if no containers are running)
	@docker rm $$(docker ps -qa) || true  # Remove all containers (ignore errors if no containers exist)
	@docker rmi -f $$(docker images -qa) || true  # Remove all images (forcefully, even if they are used by a container)
	@rm -rf $(WP_DATA) || true  # Remove the WordPress data directory (ignore errors if it doesn't exist)
	@rm -rf $(DB_DATA) || true  # Remove the MariaDB data directory (ignore errors if it doesn't exist)

# Target to clean up and prune unused Docker resources
prune: clean  # First clean up, then prune unused resources
	@docker system prune -a --volumes -f  # Remove all unused containers, networks, images, and volumes (forcefully)

# Target to re-build and restart everything
re: clean up  


.PHONY: all up down stop start build clean re prune 
