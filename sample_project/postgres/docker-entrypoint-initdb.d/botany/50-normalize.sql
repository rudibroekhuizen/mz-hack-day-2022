START TRANSACTION;

CREATE TABLE explore.recordedby (
  id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  name text UNIQUE
);

INSERT INTO explore.recordedby (name) SELECT DISTINCT recordedby FROM explore.gbif_enriched;
ALTER TABLE explore.gbif_enriched ADD COLUMN recordedby_id bigint;
UPDATE explore.gbif_enriched set recordedby_id = recordedby.id FROM explore.recordedby WHERE gbif_enriched.recordedby = recordedby.name;
ALTER TABLE explore.gbif_enriched ADD CONSTRAINT "recordedby_id_fkey" FOREIGN KEY (recordedby_id) REFERENCES explore.recordedby(id);
CREATE INDEX ON explore.recordedby (name);
CREATE INDEX ON explore.gbif_enriched (recordedby_id);
CREATE EXTENSION IF NOT EXISTS pg_trgm;
CREATE INDEX ON explore.recordedby USING gin(name gin_trgm_ops);

-- SELECT * FROM explore.gbif_enriched a LEFT JOIN explore.recordedby b ON a.recordedby_id = b.id WHERE b.id IN (2850,2851);
-- SELECT * FROM explore.gbif_enriched a LEFT JOIN explore.recordedby b ON a.recordedby_id = b.id WHERE b.name IN ('Levaillant F.','Bernstein H.A.');


CREATE TABLE explore.scientificname (
  id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  name text UNIQUE
);

INSERT INTO explore.scientificname (name) SELECT DISTINCT scientificname FROM explore.gbif_enriched;
ALTER TABLE explore.gbif_enriched ADD COLUMN scientificname_id bigint;
UPDATE explore.gbif_enriched set scientificname_id = scientificname.id FROM explore.scientificname WHERE gbif_enriched.scientificname = scientificname.name;
ALTER TABLE explore.gbif_enriched ADD CONSTRAINT "scientificname_id_fkey" FOREIGN KEY (scientificname_id) REFERENCES explore.scientificname(id);
CREATE INDEX ON explore.scientificname (name);
CREATE INDEX ON explore.gbif_enriched (scientificname_id);
CREATE EXTENSION IF NOT EXISTS pg_trgm;
CREATE INDEX ON explore.scientificname USING gin(name gin_trgm_ops);

-- SELECT * FROM explore.gbif_enriched a LEFT JOIN explore.scientificname b ON a.scientificname_id = b.id WHERE b.name IN ('Levaillant F.','Bernstein H.A.');
-- SELECT * FROM explore.gbif_enriched a LEFT JOIN explore.scientificname b ON a.scientificname_id = b.id WHERE b.id IN (2850,2851);

COMMIT;
