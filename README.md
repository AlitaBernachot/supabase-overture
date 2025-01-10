# supabase-overture

How to start the project:

1. Start Supabase instance locally
```sh
pnpm supabase start
```
2. Download the data from Overture Maps locally and prepare as sql file
```sh
make data # will download place theme

# or
make data type=building bbox=-4.582084,48.353187,-4.394436,48.440983 # to download building data from Overture Maps
make data type=division_area # to download division_area data from Overture Maps
make data type=<the_type> # place, division, building, bathymetry, land, water, ...

# see Overture Maps doc on themes/types:
# https://docs.overturemaps.org/guides/
```
3. Create Supabase database with Overture Maps data
```sh
pnpm supabase db reset # !!! This will reset DB, if modifications were made outside migration files they will be lost
```

## Local development

Supabase has been initialized in this project with:
```sh
# Install the Supabase CLI
pnpm add supabase --save-dev
# Initialize the Supabase project
pnpm supabase init
```

To start Supabase, simply use:
```sh
# Start the Supabase stack
pnpm supabase start
```
This will start Supabase in a docker container, local Supabase instance is now accessible at http://localhost:54323

Stop Supabase
```sh
pnpm supabase stop
```

Find Supabase docker volume:
```sh
docker volume ls --filter label=com.supabase.cli.project=supabase-overture
```

## Overture Maps data