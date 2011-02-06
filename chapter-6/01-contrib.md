!SLIDE
# Chapter 6
## The Shoulders of Giants

!SLIDE
# Installation
## Install postgresql-contrib

!SLIDE
# chkpass
## Encrypted column type designed for passwords
    @@@ bash
    psql database_name -f \ 
    /usr/share/postgresql/8.4/contrib/chkpass.sql

!SLIDE
# chkpass
    @@@ sql
    create table users 
      (name varchar(256), password chkpass);

    insert into users 
      (name, password) values ('nick', 'monkey');
    
    select * from users;
       name |    password    
      ------+----------------
       nick | :ggn3QyV4c5VKw

!SLIDE
# chkpass
    @@@ sql
    select * from users 
    where name = 'nick' and password = 'monkey';
      name |    password    
      ------+----------------
       nick | :ggn3QyV4c5VKw
      (1 row)

    select * from users 
    where name = 'nick' and password = 'secret';
       name | password 
      ------+----------
      (0 rows)

!SLIDE
# hstore
## Store and query hashes
    @@@ bash
    psql database_name -f \ 
    /usr/share/postgresql/8.4/contrib/hstore.sql

!SLIDE
# hstore
    @@@ sql
    create table user_profiles
      (name varchar(256), profile hstore);
    insert into user_profiles (name, profile)
      values
      ('nick', '"color"=>"blue", "music"=>"indie"'),
      ('joe', '"color"=>"blue", "music"=>"rock"');

    select * from user_profiles;
     name |                    profile                    
    ------+----------------------------------
     nick | "color"=>"blue", "music"=>"indie"
     joe  | "color"=>"blue", "music"=>"rock"
    (2 rows)

!SLIDE
# hstore
    @@@ sql
    select * from user_profiles 
    where profile::hstore->'color' = 'blue';
     name |              profile              
    ------+-----------------------------------
     nick | "color"=>"blue", "music"=>"indie"
     joe  | "color"=>"blue", "music"=>"rock"
    (2 rows)

    select * from user_profiles
    where profile::hstore->'music' = 'rock';
     name |             profile              
    ------+----------------------------------
     joe  | "color"=>"blue", "music"=>"rock"
    (1 row)


!SLIDE
# ltree
## Tree structure
### Examples from PostgreSQL docs (not mine)

!SLIDE
# ltree
    @@@ sql
    CREATE TABLE test (path ltree);
    INSERT INTO test VALUES
    ('Top'),
    ('Top.Science'),
    ('Top.Science.Astronomy'),
    ('Top.Science.Astronomy.Astrophysics'),
    ('Top.Science.Astronomy.Cosmology'),
    ('Top.Hobbies'),
    ('Top.Hobbies.Amateurs_Astronomy'),
    ('Top.Collections'),
    ('Top.Collections.Pictures'),
    ('Top.Collections.Pictures.Astronomy'),
    ('Top.Collections.Pictures.Astronomy.Stars'),
    ('Top.Collections.Pictures.Astronomy.Galaxies'),
    ('Top.Collections.Pictures.Astronomy.Astronauts');

!SLIDE
# ltree
    @@@ sql
    select path from test 
    where path <@ 'Top.Science';
                    path
    ------------------------------------
     Top.Science
     Top.Science.Astronomy
     Top.Science.Astronomy.Astrophysics
     Top.Science.Astronomy.Cosmology
    (4 rows)

!SLIDE
# ltree
    @@@ sql
    select path from test
    where path @ 'Astro*% & !pictures@';
                    path
    ------------------------------------
     Top.Science.Astronomy
     Top.Science.Astronomy.Astrophysics
     Top.Science.Astronomy.Cosmology
     Top.Hobbies.Amateurs_Astronomy
    (4 rows)


!SLIDE
# isn
## EAN13, UPC, ISBN (books), ISMN (music), and ISSN (serials)
### Auto validation + check bits
### Auto hyphenation on output

!SLIDE
# XML Functions
## Let's convert post names to tag cloud
## Based on number of comments

!SLIDE
# Setup some data
    @@@ sql
    create table posts
      (id int, name varchar(256), body text);
    create table comments
      (id int, post_id int, body text);
    insert into posts (id, name, body) values 
      (1, 'cool code', 'here is some cool code'),
      (2, 'lunch today', 'I ate a sandwich');
    insert into comments (id, post_id, body) values 
      (1, 1, 'that is cool'),
      (2, 1, 'pretty sweet'),
      (3, 2, 'sandwiches rule');

!SLIDE
# Query our cloud
    @@@ sql
    select posts.name, count(comments.id)
    from posts join comments on 
      posts.id = comments.post_id
    group by posts.name;
        name     | count 
    -------------+-------
     cool code   |     2
     lunch today |     1
    (2 rows)

!SLIDE
# Output XML
    @@@ sql
    select xmlelement(
      name span,
      xmlattributes(
        count(comments.id) as "data-count"
      ),
      posts.name
    )
    from posts join comments 
      on posts.id = comments.post_id
    group by posts.name;

                   xmlelement                
    -----------------------------------------
     <span data-count="1">lunch today</span>
     <span data-count="2">cool code</span>
    (2 rows)

