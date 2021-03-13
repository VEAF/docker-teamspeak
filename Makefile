.PHONY: help

## Display this help text
help:
	$(info ---------------------------------------------------------------------)
	$(info -                        Available targets                          -)
	$(info ---------------------------------------------------------------------)
	@awk '/^[a-zA-Z\-\_0-9]+:/ {                                                \
	nb = sub( /^## /, "", helpMsg );                                            \
	if(nb == 0) {                                                               \
		helpMsg = $$0;                                                      \
		nb = sub( /^[^:]*:.* ## /, "", helpMsg );                           \
	}                                                                           \
	if (nb)                                                                     \
		printf "\033[1;31m%-" width "s\033[0m %s\n", $$1, helpMsg;          \
	}                                                                           \
	{ helpMsg = $$0 }'                                                          \
	$(MAKEFILE_LIST) | column -ts:

## Pull docker images used in docker-compose config
pull: autoconfig
	docker-compose pull

# auto configure .env
.env:
	cp .env.dist .env

# autoconfig
autoconfig: .env

## Start all services
start: autoconfig
	docker-compose up -d

## Stop all services
stop:
	docker-compose stop

## Check stack status
ps:
	docker-compose ps

## Check logs
logs:
	docker-compose logs --tail=1000 -f

## Upgrade the stack
upgrade: pull start

