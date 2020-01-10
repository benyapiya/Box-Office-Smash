--Custom slugify function for PostgreSQL for use in fuzzy title matching between sources
--Function code take from website listed below on 10/26/19, modified to delete spaces and unwated characters
--instead of replacing with hyphens
--https://medium.com/adhawk-engineering/using-postgresql-to-generate-slugs-5ec9dd759e88

CREATE EXTENSION IF NOT EXISTS "unaccent";

CREATE OR REPLACE FUNCTION slugify("value" TEXT)
RETURNS TEXT AS $$
  -- removes accents (diacritic signs) from a given string --
  WITH "unaccented" AS (
    SELECT unaccent("value") AS "value"
  ),
  -- lowercases the string
  "lowercase" AS (
    SELECT lower("value") AS "value"
    FROM "unaccented"
  ),
  -- removes anything that's not a letter, number, hyphen('-'), or underscore('_')
  "hyphenated" AS (
    SELECT regexp_replace("value", '[^a-z0-9\\-_]+', '', 'gi') AS "value"
    FROM "lowercase"
  ),
  -- trims hyphens('-') if they exist on the head or tail of the string
  "trimmed" AS (
    SELECT regexp_replace(regexp_replace("value", '\\-+$', ''), '^\\-', '') AS "value"
    FROM "hyphenated"
  )
  SELECT "value" FROM "trimmed";
$$ LANGUAGE SQL STRICT IMMUTABLE;