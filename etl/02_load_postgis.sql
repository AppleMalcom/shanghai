-- =====================================================================
-- Step 2 - Create the PostGIS schema and load the source layers.
--
-- Run against a database with PostGIS enabled:
--     CREATE EXTENSION IF NOT EXISTS postgis;
--
-- The staging tables are loaded from the CSV outputs of the ETL steps and
-- from the raster/vector sources. Point geometries are built from the
-- WGS 84 longitude/latitude columns (EPSG:4326).
-- =====================================================================

CREATE EXTENSION IF NOT EXISTS postgis;

-- ---------------------------------------------------------------------
-- 2.1  Cleaned metro stations (output of step 1, 495 cleaned records).
-- ---------------------------------------------------------------------
DROP TABLE IF EXISTS metro_station CASCADE;
CREATE TABLE metro_station (
    station_id  BIGINT PRIMARY KEY,
    name_cn     TEXT,
    name_en     TEXT,
    lat         DOUBLE PRECISION NOT NULL,
    lon         DOUBLE PRECISION NOT NULL,
    geom        GEOMETRY(Point, 4326)
);

-- Load from the cleaned CSV (psql \copy keeps the path client-side):
-- \copy metro_station (station_id, name_cn, name_en, lat, lon) \
--      FROM 'shanghai_metro_stations_fixed.csv' WITH (FORMAT csv, HEADER true);

-- Build point geometry from longitude/latitude.
UPDATE metro_station
   SET geom = ST_SetSRID(ST_MakePoint(lon, lat), 4326);

CREATE INDEX metro_station_geom_gix ON metro_station USING GIST (geom);

-- ---------------------------------------------------------------------
-- 2.2  LiCSAR line-of-sight (LOS) velocity raster.
--      Loaded with raster2pgsql, e.g.:
--      raster2pgsql -s 4326 -I -C -t 100x100 \
--          Shanghai_velocity_line_of_sight.tif los_velocity | psql
-- The resulting table "los_velocity" holds a tiled raster column "rast"
-- in mm yr-1, where negative values denote motion away from the satellite.
-- ---------------------------------------------------------------------

-- ---------------------------------------------------------------------
-- 2.3  WorldPop 2020 residential population raster (China, 100 m, R2025A v1).
--      Loaded with raster2pgsql, e.g.:
--      raster2pgsql -s 4326 -I -C -t 100x100 \
--          worldpop_chn_2020_100m.tif population | psql
-- The resulting table "population" holds a tiled raster column "rast"
-- giving residential population per 100 m cell.
-- ---------------------------------------------------------------------
