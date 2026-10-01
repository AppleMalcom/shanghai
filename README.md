# Shanghai Metro — Deformation and Population Integration (Spatial ETL)

Reproducible spatial ETL pipeline and derived datasets supporting the study:

> *Geospatial Data Infrastructure for Urban AI: A PostGIS-Based Exploratory Study of
> Shanghai Metro Deformation and Population Exposure.*

The workflow integrates OpenStreetMap metro station locations, COMET-LiCSAR
line-of-sight (LOS) deformation velocity and WorldPop 2020 residential population
estimates for Shanghai into a single queryable PostGIS table, and compares two
station rankings (absolute LOS velocity and an exposure-weighted priority score).

## Repository contents

```
etl/
  01_extract_clean_osm.py   Clean the raw OSM export (769 -> 495 records)
  02_load_postgis.sql       Create the PostGIS schema and load the layers
  03_integrate.sql          Spatial join + exposure-weighted score (495 -> 494)
  04_rankings.sql           Descriptive statistics and the two rankings
  README.md                 Detailed workflow description and diagram
  workflow_diagram.png      Spatial ETL workflow (Figure 1 in the paper)
  workflow_diagram.svg      Vector source of the workflow diagram

shanghai_metro_stations_raw.csv     OSM export (input to step 1)
shanghai_metro_stations_fixed.csv   Cleaned stations (output of step 1)
shanghai_metro_risk_data.csv        Stations with LOS velocity joined
shanghai_metro_risk_final.csv       Integrated stations with LOS + population
```

## Workflow summary

1. **Clean** the raw OpenStreetMap export — remove records with missing required
   fields and resolve duplicate identifiers and duplicate English station names
   (769 → 495 records).
2. **Load** the cleaned stations into PostGIS as WGS 84 (EPSG:4326) point
   geometries, alongside the LOS velocity and WorldPop population rasters.
3. **Integrate** — sample both rasters at each station with `ST_Value`, join with
   `ST_Intersects`, keep only stations on a valid LOS pixel (495 → 494), and compute
   the exposure-weighted priority score `EWPS = |v_LOS| × log10(population + 1)`.
4. **Rank** — retrieve the descriptive statistics and the two station rankings.

See [`etl/README.md`](etl/README.md) for the full description, data provenance
table and workflow diagram.

## Running

```bash
# Step 1: clean the OSM export (pure Python, no dependencies)
python3 etl/01_extract_clean_osm.py \
    --input shanghai_metro_stations_raw.csv \
    --output shanghai_metro_stations_fixed.csv

# Steps 2-4: load and integrate in PostGIS (requires the PostGIS extension)
psql -d shanghai -f etl/02_load_postgis.sql
psql -d shanghai -f etl/03_integrate.sql
psql -d shanghai -f etl/04_rankings.sql
```

## Data sources

| Dataset | Source | Reference period | Version / Frame |
|---------|--------|------------------|-----------------|
| Metro stations | OpenStreetMap | Retrieved Jan 2026 | — |
| Deformation | COMET-LiCSAR (Sentinel-1) | Sentinel-1 observations | Frame 171A_05926_131310, ascending |
| Population | WorldPop | 2020 | Release R2025A v1 (China, 100 m) |

All layers use the WGS 84 geographic coordinate reference system (EPSG:4326).
Negative LOS velocity denotes motion away from the satellite and is consistent
with subsidence.
