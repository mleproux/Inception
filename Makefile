VOLUMES_DIR="/home/mleproux/data"

all: build start

build:
	sudo mkdir -p ${VOLUMES_DIR}/wordpress ${VOLUMES_DIR}/mariadb
	docker compose -f srcs/docker-compose.yml build

start: build
	docker compose -f srcs/docker-compose.yml up -d

down:
	docker compose -f srcs/docker-compose.yml down

fclean: down clean
	if [ -n "$$(docker ps -aq)" ]; then docker rm -f $$(docker ps -aq); fi
	if [ -n "$$(docker images -aq)" ]; then docker rmi -f $$(docker images -aq); fi
	sudo rm -rf /home/mleproux/data/mariadb /home/mleproux/data/wordpress
	sudo mkdir -p /home/mleproux/data/mariadb /home/mleproux/data/wordpress

status:
	docker ps -a

re: down start

logs:
	docker compose -f srcs/docker-compose.yml logs -f

.PHONY: all build clean down start fclean status re logs