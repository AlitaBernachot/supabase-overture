
DOCKER_RUN_CMD = docker compose run --rm --user=`id -u`:`id -g` overturemaps-downloader
DATA_PATH = /data/places.geojson
SQL_FILE = /data/places.sql
bbox ?= -5.144,47.2778,-1.0157,49.1133 # FR-BRE

-include local.mk

default: help

.PHONY: help
help: ## Display this help message
	@echo "Usage: make <target>"
	@echo
	@echo "Possible targets:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "    %-20s%s\n", $$1, $$2}'

data-download: ## Download Overture Maps data with given BBOX (FR-BRE by default) as geojson
	@echo "\033[42m[overturemaps-downloader]\033[0m Downloading Overture Maps data with BBOX $(bbox) as geojson"
	$(DOCKER_RUN_CMD) overturemaps download --bbox=$(bbox) -f geojson -o $(DATA_PATH) --type=place

data-to-sql: ## Prepare geojson as sql file
	@echo "\033[42m[overturemaps-downloader]\033[0m Converting geojson as sql dump file"
	$(DOCKER_RUN_CMD) ogr2ogr -f pgdump $(SQL_FILE) $(DATA_PATH)

data-move: ## Move sql file to supabase migrations folder
	@echo "\033[42m[supabase-overture]\033[0m Move sql file to supabase migrations folder"
	$(eval TIMESTAMP := $(shell date +%Y%m%d%H%M%S))
	mv data/places.sql supabase/migrations/$(TIMESTAMP)_insert_places_table.sql

data: data-download data-to-sql data-move ## Run download Overture Maps data and convert downloaded data to sql

.PHONY: data data-to-sql data-download data-move
