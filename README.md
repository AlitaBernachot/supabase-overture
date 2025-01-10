# supabase-overture

How to start the project:

1. launch Supabase locally
```sh
pnpm supabase start
```
2. download the data locally and prepare as sql file
```sh
make data
```
3. push data to Supabase

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