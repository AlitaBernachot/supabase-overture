CREATE SCHEMA overture;

GRANT USAGE ON SCHEMA overture TO PUBLIC;
GRANT SELECT ON ALL TABLES IN SCHEMA overture TO PUBLIC;
ALTER DEFAULT PRIVILEGES IN SCHEMA overture GRANT SELECT ON TABLES TO PUBLIC;