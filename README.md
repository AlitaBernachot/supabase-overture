# supabase-overture

How to start the project:

1. Start Supabase instance locally
```sh
pnpm supabase start
```
2. Download the data from Overture Maps locally and prepare as sql file
```sh
make data
```
3. Create Supabase database with Overture Maps data
```sh
pnpm supabase db reset
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