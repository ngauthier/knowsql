!SLIDE
# Chapter 3
## Geospatial

!SLIDE center
# Not your typical index
![K-D Tree](kdtree.png)
#### [http://en.wikipedia.org/wiki/K-d\_tree](http://en.wikipedia.org/wiki/K-d_tree)

!SLIDE center
# PostGIS
## Geospatial indexing and querying for PostgreSQL

!SLIDE
# Easy Ubuntu Install
### Add PPA ppa:ubuntugis/ubuntugis-unstable
### Install postgresql-8.4-postgis

!SLIDE
# Setup the language
    @@@ sql
    createdb my_db
    createlang plpgsql my_db
    psql -d my_db -f /usr/share/postgresql/8.4/
      contrib/postgis-1.5/postgis.sql
    psql -d my_db -f /usr/share/postgresql/8.4/
      contrib/postgis-1.5/spatial_ref_sys.sql
    psql -d my_db -f /usr/share/postgresql/8.4/
      contrib/postgis_comments.sql

!SLIDE
# Setup your database
    @@@ sql
    CREATE sequence points_id_seq;
    CREATE TABLE points (
      id integer PRIMARY KEY
      DEFAULT NEXTVAL('points_id_seq')
    );
    SELECT AddGeometryColumn(
      'points', 'location', 4326, 'POINT', 2
    );
    CREATE INDEX points_location_idx 
      ON points USING GIST ( location );
 
!SLIDE
# Create a point
    @@@ sql
    INSERT INTO points(location) VALUES (
      ST_GeomFromText(
        'POINT(-76.615657 39.327052)'
      )
    );
 
!SLIDE
# Find points in a radius
    @@@ sql
    SELECT * FROM points
    WHERE ST_Distance(
      location,
      ST_GeomFromText('POINT(-76 39)')
    ) < 1;

!SLIDE
# In Rails
## GeoRuby
### [http://georuby.rubyforge.org/](http://georuby.rubyforge.org/)
## Spatial Adapter
### [http://github.com/fragility/spatial\_adapter](http://github.com/fragility/spatial_adapter)

!SLIDE
# Will it blend?

!SLIDE
# 8,000,000 points

!SLIDE
# 5 years of data

!SLIDE
# Single EC2 Large @ 400rpm

!SLIDE
# Query: "What happened on my block last week?"

!SLIDE
# Avg 23ms response time
## Database: 2.0ms
## ActiveRecord: 6.8ms
## Controller action + JSON: 14ms

!SLIDE center
# Remember compound indices from chapter 1?
## Compound index on space and time
![Spacetime](spacetime.png)
#### [http://en.wikipedia.org/wiki/Spacetime](http://en.wikipedia.org/wiki/Spacetime)

!SLIDE
# There's more
### Lines and polygons
### Intersection operations
### Partial and full containment
### Distance calculation
### Area computation

!SLIDE
# Can't touch this
### MongoDB: flat earth model, only distance calculation
### MySQL: containment via rectangles, no compound indexing
### SQL Server: pretty good ... just icky
### Sphinx + Solr: additional layer and pretty immature
