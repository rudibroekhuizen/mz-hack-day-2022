--
CREATE EXTENSION postgis;

CREATE TYPE type_opensky AS 
  (icao24 TEXT,
   callsign TEXT,
   origin_country TEXT,
   time_position TIMESTAMPTZ,
   last_contact TIMESTAMPTZ,
   longitude FLOAT,
   latitude FLOAT,
   -- not in source 
   geom geometry(Point,4326)
  );

--CREATE TABLE faunabit_locations OF type_faunabit_locations (
--    PRIMARY KEY (id)
--);

CREATE UNLOGGED TABLE opensky_raw (
  data JSONB
  );

CREATE TABLE opensky AS
SELECT *
FROM opensky_raw, jsonb_populate_record(
    null::type_opensky,
    data
  );

CREATE OR REPLACE PROCEDURE update_table_faunabit_locations()
LANGUAGE SQL
AS $BODY$
TRUNCATE TABLE faunabit_locations_raw;
COPY faunabit_locations_raw (data) FROM '/mnt/share/faunabit_locations.json' CSV QUOTE e'\x01' DELIMITER e'\x02';
TRUNCATE TABLE faunabit_locations;
INSERT INTO faunabit_locations(
  SELECT *
  FROM faunabit_locations_raw, jsonb_populate_record(
    null::type_faunabit_locations,
    data));
UPDATE faunabit_locations SET geom = ST_SetSRID(ST_Makepoint(lon,lat),4326);
$BODY$;

CALL update_table_faunabit_locations();
SELECT cron.schedule('* * * * *', $$CALL update_table_faunabit_locations()$$);

