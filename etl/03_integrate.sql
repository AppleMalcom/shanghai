-- =====================================================================
-- Step 3 - Integrate deformation and population onto the station points
--          and compute the exposure-weighted priority score (EWPS).
--
-- This is the representative spatial query of the workflow: for every
-- cleaned station it samples the LOS velocity raster and the WorldPop
-- raster at the station location, keeps only stations that fall on a
-- valid velocity pixel, and evaluates
--
--     EWPS = |v_LOS| * log10(population + 1)
--
-- producing the integrated station-level table used for the rankings.
-- =====================================================================

DROP TABLE IF EXISTS metro_station_integrated CASCADE;

CREATE TABLE metro_station_integrated AS
SELECT
    s.station_id,
    s.name_en,
    s.name_cn,
    s.lat,
    s.lon,
    s.geom,
    -- Sample the LOS velocity raster at the station point (mm yr-1).
    ST_Value(v.rast, s.geom)                               AS subsidence_rate,
    -- Sample the WorldPop raster at the station point; treat an absent
    -- population pixel as zero residents.
    COALESCE(ST_Value(p.rast, s.geom), 0)                  AS population,
    -- Exposure-weighted priority score.
    ABS(ST_Value(v.rast, s.geom))
        * LOG(10.0, COALESCE(ST_Value(p.rast, s.geom), 0) + 1) AS ewps
FROM        metro_station s
-- Spatial join to the LOS raster tile covering each station.
JOIN        los_velocity v ON ST_Intersects(v.rast, s.geom)
-- Spatial join to the population raster tile (LEFT: population may be absent).
LEFT JOIN   population     p ON ST_Intersects(p.rast, s.geom)
-- Keep only stations that fall on a valid (non-NULL) velocity pixel.
WHERE ST_Value(v.rast, s.geom) IS NOT NULL;

ALTER TABLE metro_station_integrated ADD PRIMARY KEY (station_id);
CREATE INDEX metro_station_integrated_geom_gix
    ON metro_station_integrated USING GIST (geom);

-- Sanity check: expected to return 494.
-- SELECT COUNT(*) FROM metro_station_integrated;
