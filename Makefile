WP_DATA = /home/hanglade/data/wordpress
DB_DATA = /home/hanglade/data/mariadb
DOCKER_COMPOSE = docker-compose -f srcs/docker-compose.yml

all:up

up: build
	@mkdir -p $(WP_DATA)
	@mkdir -p $(DB_DATA)
	$(DOCKER_COMPOSE) up -d

build:
	$(DOCKER_COMPOSE) build

start:
	$(DOCKER_COMPOSE) start

stop:
	$(DOCKER_COMPOSE) stop

down:
	$(DOCKER_COMPOSE) down


clean:
	@docker stop $$(docker ps -qa) || true
	@docker rm $$(docker ps -qa) || true
	@docker rmi -f $$(docker images -qa) || true
	@rm -rf $(WP_DATA) || true
	@rm -rf $(DB_DATA) || true

prune: clean
	@docker system prune -a --volumes -f

re: clean up


.PHONY: all up down stop start build clean re prune
