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

CREATE OR REPLACE PROCEDURE update_table_opensky()
LANGUAGE SQL
AS $BODY$
TRUNCATE TABLE opensky_raw;
COPY opensky_raw (data) FROM '/var/lib/postgresql/scripts/opensky.jsonl' CSV QUOTE e'\x01' DELIMITER e'\x02';
INSERT INTO opensky(
  SELECT *
  FROM opensky_raw, jsonb_populate_record(
    null::type_opensky,
    data));
UPDATE opensky SET geom = ST_SetSRID(ST_Makepoint(lon,lat),4326);
$BODY$;

CALL update_table_opensky();
--SELECT cron.schedule('* * * * *', $$CALL update_table_opensky()$$);

