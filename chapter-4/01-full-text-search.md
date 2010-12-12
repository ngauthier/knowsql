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
    @@@ text
           Table "public.wikipedia_titles"
     Column |          Type          | Modifiers 
    --------+------------------------+-----------
     title  | character varying(256) | 


!SLIDE
# Full text search query:
    @@@ sql
    select * from wikipedia_titles
    where to_tsvector( 'english', title   ) @@
          to_tsquery(  'english', 'puppy' );
## => 
    @@@ text
                     title                 
    ---------------------------------------
     102_Dalmatians:_Puppies_to_the_Rescue
     102_Dalmatians_Puppies_to_the_Rescue
    (2 rows)

!SLIDE
# Index it!
    @@@ sql
    CREATE INDEX titles_idx ON wikipedia_titles
    USING gin(to_tsvector('english', title));

!SLIDE
# Results highlighting
    @@@ sql
    SELECT ts_headline('english',
      'The most common type of search
    is to find all documents containing given
    query terms and return them in order of
    their similarity to the query.',
      to_tsquery('query & similarity'));

!SLIDE
# Results highlighting
    @@@ text
                 ts_headline                   
    ---------------------------------------
     containing given <b>query</b> terms
     and return them in order of their
     <b>similarity</b> to the <b>query</b>.
    
#### http://www.postgresql.org/docs/9.0/static/textsearch-controls.html#TEXTSEARCH-RANKING

!SLIDE
# Statistics
    @@@ sql
    select * from ts_stat(E'
      select to_tsvector(''english'', title)
      from wikipedia_titles
    ') order by nentry desc limit 25;
## =>
    @@@ text
         word     | ndoc | nentry 
    --------------+------+--------
     season       | 8322 |   8324
     championship | 3557 |   3557
     2007         | 3441 |   3443
     world        | 3281 |   3285

!SLIDE bullets
# Statistics
* Takes ~1s, so you should cache it. 
* Would make a great tag cloud
* (after converting lexemes to tokens)

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

