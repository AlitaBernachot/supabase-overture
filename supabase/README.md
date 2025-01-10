# Supabase seeds & migrations

## Supabase migrations

These migration files contain: 
- `postgis` extension activation
- table creation 
- and some insert samples.

**Only samples are committed for now**, as data comming from parquet may generate large files.
To insert samples, remove **SAMPLES** in `20250110090000SAMPLES_insert_places_table.sql`, this will enable the Supabase cli to read the file.

Usage

```sh
pnpm supabase migration new create_places_table
```

And apply migration

```sh
pnpm supabase db push
```


##### Documentation

https://supabase.com/docs/guides/local-development/overview

## Supabase seeds

All files in `supabase/seeds` folder or `seed.sql` (depending on the `congif.toml`) will be processed by Supabase cli at each `supabase start` or `supabase db reset`.

These seeds files contain vault declaration.

Usage

```sh
pnpm supabase db reset
```

##### Documentation

https://supabase.com/docs/guides/local-development/seeding-your-database