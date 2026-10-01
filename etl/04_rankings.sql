-- =====================================================================
-- Step 4 - Retrieve the two station rankings compared in the study.
-- =====================================================================

-- 4.1  Descriptive statistics for the integrated variables (Table 2).
SELECT
    COUNT(*)                              AS n,
    MIN(subsidence_rate)                  AS los_min,
    MAX(subsidence_rate)                  AS los_max,
    AVG(subsidence_rate)                  AS los_mean,
    STDDEV_POP(subsidence_rate)           AS los_sd,
    MIN(population)                       AS pop_min,
    MAX(population)                       AS pop_max,
    AVG(population)                       AS pop_mean,
    STDDEV_POP(population)                AS pop_sd
FROM metro_station_integrated;

-- 4.2  Five stations with the highest absolute LOS velocity (Table 3).
SELECT
    name_en,
    subsidence_rate,
    population
FROM metro_station_integrated
ORDER BY ABS(subsidence_rate) DESC
LIMIT 5;

-- 4.3  Five highest-priority stations under the exposure-weighted score (Table 4).
SELECT
    name_en,
    subsidence_rate,
    population,
    ewps
FROM metro_station_integrated
ORDER BY ewps DESC
LIMIT 5;
