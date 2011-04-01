!SLIDE
# Chapter 6
## The Shoulders of Giants

!SLIDE
# Installation on Ubuntu
## Install postgresql-contrib
### OS X's postgresql comes with contrib

!SLIDE
# chkpass
## Encrypted column type designed for passwords
    @@@ bash
    psql database_name -f chkpass.sql

!SLIDE
# chkpass
    @@@ ruby
    def self.up
      create_table :users do |t|
        t.column :name,     :string
        t.column :password, :chkpass
        t.timestamps
      end
    end

!SLIDE
# chkpass
    @@@ ruby
    nick = User.create(
      :name => 'Nick', :password => 'monkey'
    )
    #<User name:"Nick", password:"monkey"> 
    nick.reload
    #<User name:"Nick", password:":E5m8WfMYmeo22">
    User.where(
      :name => 'Nick', :password => 'monkey'
    ).first
    #<User name:"Nick", password:":E5m8WfMYmeo22">

!SLIDE
# hstore
## Store and query hashes
    @@@ bash
    psql database_name -f hstore.sql

!SLIDE
# hstore
    @@@ ruby
    def self.up
      create_table :users do |t|
        t.column :name,    :string
        t.column :profile, :hstore
        t.timestamps
      end
    end

!SLIDE
# hstore
    @@@ ruby
    User.create(
      :name => 'Nick',
      :profile => %{
        "color"=>"blue", "music"=>"indie"
      }
    )
    User.create(
      :name => 'Joe',
      :profile => %{
        "color"=>"blue", "music"=>"rock"
      }
    )

!SLIDE
# hstore
    @@@ ruby
    User.where(%{profile::hstore->'color'='blue'})
    [#<User name:"Nick">, #<User name:"Joe">]

    User.where(%{profile::hstore->'music'='rock'})
    [#<User name:"Joe">]

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
### Post "cool code" has one two comments
### Post "lunch today" has one comment

!SLIDE
# Query
    @@@ ruby
    Post.select(%{
      xmlelement(
        name span,
        xmlattributes(
          count(comments.id) as "data-count"
        ),
        posts.name
      )
    }).joins(%{
      join comments on posts.id = comments.post_id
    }).group('posts.name')

!SLIDE
# Result
    @@@ text
                   xmlelement                
    -----------------------------------------
     <span data-count="1">lunch today</span>
     <span data-count="2">cool code</span>
    (2 rows)

