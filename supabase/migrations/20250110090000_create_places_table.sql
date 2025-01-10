CREATE TABLE places (
    ogc_fid SERIAL PRIMARY KEY,
    wkb_geometry geometry(POINT, 4326),
    id VARCHAR,
    version INTEGER,
    sources JSON,
    names JSON,
    categories JSON,
    confidence FLOAT8,
    websites VARCHAR[],
    socials VARCHAR[],
    phones VARCHAR[],
    brand JSON,
    addresses JSON
);

CREATE INDEX places_wkb_geometry_geom_idx ON places USING GIST ("wkb_geometry");