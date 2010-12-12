

CREATE INDEX titles_idx ON wikipedia_titles USING gin(to_tsvector('english', title));


knowsql_examples=# select * from wikipedia_titles where to_tsvector('english', title) @@ to_tsquery('english', 'puppy');
                 title                 
---------------------------------------
 102_Dalmatians:_Puppies_to_the_Rescue
 102_Dalmatians_Puppies_to_the_Rescue
(2 rows)

Highlighting: 
SELECT ts_headline('english',
  'The most common type of search
is to find all documents containing given query terms
and return them in order of their similarity to the
query.',
  to_tsquery('query & similarity'));
                        ts_headline                         
------------------------------------------------------------
 containing given <b>query</b> terms
 and return them in order of their <b>similarity</b> to the
 <b>query</b>.


From http://www.postgresql.org/docs/9.0/static/textsearch-controls.html#TEXTSEARCH-RANKING


Statistics:

select * from ts_stat(E'select to_tsvector(''english'', title) from wikipedia_titles') order by nentry desc limit 25;

     word     | ndoc | nentry 
--------------+------+--------
 season       | 8322 |   8324
 championship | 3557 |   3557
 2007         | 3441 |   3443
 world        | 3281 |   3285
 footbal      | 2795 |   2795


Takes ~1s, so you should cache it. 


100,000 wikipedia article titles (max 255 chars)

Searched on 98326 words in 157.337225s
625 searches per second (1.6ms per query)
(on a netbook)

