CREATE OR REPLACE FUNCTION mvt_divisions(divisiontype text, relation text, z integer, x integer, y integer)
RETURNS text
LANGUAGE plpgsql
AS $$
DECLARE
    mvt_output text;
BEGIN
    WITH 
    -- Define the bounds of the tile using the provided Z, X, Y coordinates
    bounds AS (
        SELECT ST_TileEnvelope(z, x, y) AS geom
    ),
    -- Transform the geometries from EPSG:4326 to EPSG:3857 and clip them to the tile bounds
    mvtgeom AS (
        SELECT 
            -- include the name and id only at zoom 13 to make low-zoom tiles smaller
            id,
            division_id,
            ST_AsMVTGeom(
                ST_Transform(wkb_geometry, 3857), -- Transform the geometry to Web Mercator
                bounds.geom,
                4096, -- The extent of the tile in pixels (commonly 256 or 4096)
                0,    -- Buffer around the tile in pixels
                true  -- Clip geometries to the tile extent
            ) AS geom
        FROM 
            "overture"."division_area", bounds
        WHERE 
            ST_Intersects(ST_Transform(wkb_geometry, 3857), bounds.geom)
    )
    -- Generate the MVT from the clipped geometries
    SELECT INTO mvt_output encode(ST_AsMVT(mvtgeom, relation, 4096, 'geom'),'base64')
    FROM mvtgeom
    JOIN  "overture"."division" divs ON divs.id = mvtgeom.division_id
    WHERE divs.subtype = divisiontype;

    RETURN mvt_output;
END;
$$
SET statement_timeout TO '5min'; -- set custom timeout