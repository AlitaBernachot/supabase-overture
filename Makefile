.PHONY: data data-to-sql data-download data-move

DOCKER_RUN_OVERTURE = docker compose run --rm --user=`id -u`:`id -g` overturemaps-downloader
DOCKER_RUN_GDAL = docker compose run --rm --user=`id -u`:`id -g` gdal

bbox ?= -5.144,47.2778,-1.0157,49.1133 # FR-BRE
type ?= place
SCHEMA = overture
DATA_FILE = data/$(type).geojson
SQL_FILE = data/$(type).sql
SQL_MIGRATION_FILE = supabase/migrations/$(TIMESTAMP)_create_ovmap_$(type)_table.sql

-include local.mk

default: help

.PHONY: help
help: ## Display this help message
	@echo "Usage: make <target>"
	@echo
	@echo "Possible targets:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "    %-20s%s\n", $$1, $$2}'

data-download: ## Download Overture Maps data with given BBOX (FR-BRE by default) as geojson, choose a type, eg. "place", "building", "division_area", ...
	@echo "\033[42m[overturemaps-downloader]\033[0m Downloading Overture Maps data with BBOX $(bbox) as geojson"
	$(DOCKER_RUN_OVERTURE) overturemaps download --bbox=$(bbox) -f geojson -o /$(DATA_FILE) --type=$(type)

data-to-sql: ## Prepare geojson as sql file
	@echo "\033[42m[gdal]\033[0m Converting geojson as sql dump file"
	$(DOCKER_RUN_GDAL) ogr2ogr -f pgdump /$(SQL_FILE) /$(DATA_FILE) -lco SCHEMA=$(SCHEMA)

data-move: ## Move sql file to supabase migrations folder
	@echo "\033[42m[supabase-overture]\033[0m Move sql file to supabase migrations folder"
	$(eval TIMESTAMP := $(shell date +%Y%m%d%H%M%S))
	sed -i '/CREATE SCHEMA/d' $(SQL_FILE)
	mv $(SQL_FILE) $(SQL_MIGRATION_FILE)
	echo 'ALTER TABLE "$(SCHEMA)"."$(type)" ENABLE ROW LEVEL SECURITY;' >> $(SQL_MIGRATION_FILE)
	echo 'CREATE POLICY "Enable read access for all users" ON "$(SCHEMA)"."$(type)" FOR SELECT USING (true);' >> $(SQL_MIGRATION_FILE)

data: data-download data-to-sql data-move ## Run download Overture Maps data and convert downloaded data to sql

data-all:
	$(MAKE) data type="place"
	$(MAKE) data type="building" bbox="-4.58471,48.340945,-4.369962,48.451618"
	$(MAKE) data type="division"
	$(MAKE) data type="division_area"
