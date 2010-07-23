# KnowSQL

## Goal
1. you don't know what you don't know
   awareness > complete comprehension
   open the fire hydant: you don't have to drink it all, but I will soak you
1. Easier

## Chapter 1: Indexing
 * Basic index (bench - show seq vs idx)
 * unique index (faster than rails - bench)
 * index on expressions (w/ unique)
   * mathematical operators and functions
   * email verification regex
 * compound (multi-type indexing - Gist & GIN)
 * foreign keys
   * polymorphic foreign keys

## Chapter 2: Fancy Queries
 * Joins w/ :include and :select for single query access
 * complex aggregation (partition)
 * nested queries (Subquery)
 * pattern matching (LIKE and also regex)
 * views (like for search, or for a twitter timeline)

## Chapter 3: Full Text Search
 * Simple single column
 * Show in rails (simpler setup than any external indexer)
 * Multi-column
 * Cross table
 * pretty results
 * does stemming for you
 * synonyms through dict_xsyn http://www.postgresql.org/docs/8.4/static/dict-xsyn.html
 * multilingual
 * Fast (wikipedia?)
 * Fast (bench vs mongo? http://www.mongodb.org/display/DOCS/Full+Text+Search+in+Mongo )
 * Fast (bench vs solr? http://lucene.apache.org/solr/features.html )

## Chapter 4: Geospatial
 * Setup PostGIS (w/ ubuntu repo)
 * Easy migration to add a point to something
 * Geospatial index
 * Compound index w/ geospatial
 * Searching within polygons, radii, etc
 * Fast (twitter? earthquakes?)
 * Fast (bench vs mongo geospatial? http://www.mongodb.org/display/DOCS/Geospatial+Indexing ) 

## Chapter 5: Shoulders of Giants
 * auto_explain (like slow query log) http://www.postgresql.org/docs/8.4/static/auto-explain.html
 * chkpass (leave pw encryption to db) http://www.postgresql.org/docs/8.4/static/chkpass.html
   * plus there is pgcrypto for tons of other cryptography functions
 * hstore (hashes in db #> easy search and index) http://www.postgresql.org/docs/8.4/static/hstore.html
 * intarray (arrays in db) http://www.postgresql.org/docs/8.4/static/intarray.html
 * isn (isbn, upc, ismn, issn ... validation, check bits, etc) http://www.postgresql.org/docs/8.4/static/isn.html
 * ltree (tree structure - useful for category names) http://www.postgresql.org/docs/8.4/static/ltree.html
 * xml2 (xml validation and xpath querying) http://www.postgresql.org/docs/8.4/static/xml2.html


## Chapter 6


 * rails structure loading?
 * maybe transactions and locking?
