!SLIDE
# Chapter 4
## Full Text Search

!SLIDE
# Many Solutions

!SLIDE bullets
# Desired attributes:
* Fast (enough)
* Easy

!SLIDE bullets
# Full text search features
* Linguistic support
* Results ranking
* Tokens => Lexemes

!SLIDE
# Sample Data
## 100,000 wikipedia english article titles

!SLIDE
# Full text search query:
    @@@ ruby
    Title.where({
      to_tsvector('english', title) @@
      to_tsquery( 'english', 'puppy')
    })

####  

    @@@ text
                     title                 
    ---------------------------------------
     102_Dalmatians:_Puppies_to_the_Rescue
     102_Dalmatians_Puppies_to_the_Rescue
    (2 rows)

!SLIDE
# Texticle
    @@@ ruby
    class Title < ActiveRecord::Base
      index do
        title
      end
    end

    Title.search('puppy')

!SLIDE
# Index it!
    @@@ sql
    CREATE INDEX titles_idx ON
      wikipedia_titles
    USING gin(
      to_tsvector('english', title)
    );

## or

    @@@ sh
    rake texticle:migration

!SLIDE
# Results highlighting
    @@@ ruby
    Title.search('puppy').select(%{
      ts_headline('english', title,
        to_tsquery('english', 'puppy')
      ) as headline
    }).first.headline
    =>
    "102_Dalmatians:<b>Puppies</b>_to_the_Rescue"
### [http://www.postgresql.org/docs/9.0/static/textsearch-controls.html#TEXTSEARCH-RANKING](http://www.postgresql.org/docs/9.0/static/textsearch-controls.html#TEXTSEARCH-RANKING)

!SLIDE
# Statistics
    @@@ sql
    select * from ts_stat(E'
      select
      to_tsvector(''english'', title)
      from wikipedia_titles
    ') order by nentry desc limit 25;
### =>
    @@@ text
         word     | ndoc | nentry 
    --------------+------+--------
     season       | 8322 |   8324
     championship | 3557 |   3557
     2007         | 3441 |   3443
     world        | 3281 |   3285

!SLIDE
# Performance
### 100,000 article titles
### 98,326 words in /usr/share/dict/words

    @@@ text
    for word in words
      search all articles for word

!SLIDE bullets incremental
# Performance
* 98,326 words in 157s
* 625 w/s (1.6ms per query)
* (on a netbook)

!SLIDE
# Performance
## Fast enough

