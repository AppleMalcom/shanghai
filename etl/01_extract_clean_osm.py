#!/usr/bin/env python3
"""
Step 1 - Extract and clean OpenStreetMap metro station records.

Reads the raw OpenStreetMap export of Shanghai metro/subway station features
and produces a cleaned, de-duplicated station table used as the vector base
layer for the integration (see etl/README.md for the full workflow).

Cleaning rules (reduces 769 raw records to 495 cleaned stations; a single
station without a valid line-of-sight velocity pixel is subsequently dropped
during the deformation join in step 3, leaving the 494 integrated stations):
  1. Drop records missing any required field
     (element, id, name, name:en, lat, lon).
  2. Drop exact duplicate OSM ids (keeping the first occurrence).
  3. Drop duplicate English station names (keeping the first occurrence),
     so that each station is represented once.

Input : shanghai_metro_stations_raw.csv   (OSM export)
Output: shanghai_metro_stations_fixed.csv  (station_id, name_cn, name_en, lat, lon)
"""

import argparse
import csv
import sys

REQUIRED_FIELDS = ["element", "id", "name", "name:en", "lat", "lon"]


def clean(rows):
    """Apply the three cleaning rules in order and return cleaned rows."""
    # Rule 1: drop records with any missing required field.
    complete = [r for r in rows if all((r.get(f) or "").strip() for f in REQUIRED_FIELDS)]

    # Rule 2: drop exact duplicate OSM ids (first occurrence wins).
    seen_ids = set()
    unique_ids = []
    for r in complete:
        if r["id"] not in seen_ids:
            seen_ids.add(r["id"])
            unique_ids.append(r)

    # Rule 3: drop duplicate English station names (first occurrence wins).
    seen_names = set()
    cleaned = []
    for r in unique_ids:
        if r["name:en"] not in seen_names:
            seen_names.add(r["name:en"])
            cleaned.append(r)

    return cleaned


def main():
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("--input", default="shanghai_metro_stations_raw.csv")
    ap.add_argument("--output", default="shanghai_metro_stations_fixed.csv")
    args = ap.parse_args()

    with open(args.input, encoding="utf-8-sig") as f:
        rows = list(csv.DictReader(f))

    cleaned = clean(rows)

    with open(args.output, "w", encoding="utf-8", newline="") as f:
        writer = csv.writer(f)
        writer.writerow(["station_id", "name_cn", "name_en", "lat", "lon"])
        for r in cleaned:
            writer.writerow([r["id"], r["name"], r["name:en"], r["lat"], r["lon"]])

    print(f"Read {len(rows)} raw records; wrote {len(cleaned)} cleaned stations "
          f"to {args.output}", file=sys.stderr)


if __name__ == "__main__":
    main()
