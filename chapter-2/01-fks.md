!SLIDE
# Chapter 2
## Foreign Keys

!SLIDE
# Foreign Key
## Validates a Relationship

!SLIDE
# Foreign Key
## Comment belongs to Post
### comment.post\_id => post.id

!SLIDE
# Rails
    @@@ ruby
    class Comment < ActiveRecord::Base
      belongs_to :post
      validates_presence_of :post
      validates_presence_of :post_id
      validates_numericality_od :post_id
    end

!SLIDE
# Rails
    @@@ ruby
    p = Post.new
    c = Comment.new(:post => p)
    p.destroy
     => true
    c.reload; c.valid?
     => false
    # but it's in the DB!

!SLIDE bullets
# Rails 
## Validations are run when valid? is called
### And they're really slow!

!SLIDE
# Database
## Foreign key validations are always maintained
    @@@ sql
    delete from posts where id = 5;
     => Error!

!SLIDE bullets incremental
# Rails validations are broken:
* .save(:validations => false)
* .delete
* .update\_all
* .connection.execute
* db console

!SLIDE bullets incremental
# DB validations are broken:
* ...
* raw editing database files on the file system?

!SLIDE
# DB validations are fast

!SLIDE
# Foreigner Gem
### [http://github.com/matthuhiggins/foreigner](http://github.com/matthuhiggins/foreigner)
    @@@ ruby

    gem 'matthuhiggins-foreigner', 
        :require => 'foreigner'

    create_table :comments do |t|
      t.references :posts, :foreign_key => true
    end

!SLIDE
# Foreign Keys
## What's your excuse?
