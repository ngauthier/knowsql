!SLIDE
# Unique Index
## Database Validation

!SLIDE
# Unique Index
### During record insertion, collision raises error

!SLIDE
# Unique Index
### Fast because it's performed during the insert

!SLIDE
# ActiveRecord
## validates_uniqueness_of

!SLIDE
# ActiveRecord
### Performs a select before the insert

!SLIDE
# ActiveRecord
### Double Query

!SLIDE
# Insert 10,000 numbers

!SLIDE
# Try to insert 1,000 duplicates

!SLIDE
# Can't compare PG to AR
## Compare to themselves

!SLIDE
# Results
## PostgreSQL
    @@@
               no index   0.891351
               with index 0.849832

!SLIDE
# Results
## PostgreSQL
### Faster, because it doesn't need to do anything

!SLIDE
# Results
## ActiveRecord
    @@@      
               no index   4.493282
               with index 7.240643

!SLIDE
# Results
## ActiveRecord
### Slower, because select is slower than insert
