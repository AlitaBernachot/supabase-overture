# overturemaps-downloader

Is a docker image with:
- `overturemaps-py` to download Overture Maps parquet locally,
- and `gdal` utility to transform sownloaded geojson into sql file.

#### To improve
- remove duplicate apt-install 
- install gdal with pip if possible?
(needs `ulimits` option in `docker-compose.yaml`, otherwise won't work)
