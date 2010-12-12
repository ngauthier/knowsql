#!/usr/bin/env ruby
require File.expand_path(File.join(File.dirname(__FILE__), '..', 'helper.rb'))

# Before running this script, run:
# data/wikipedia_titles.sql
# To create the db and insert the data.

# The data insertion SQL is generated from
# the wikipedia titles dump and the following code.
# Then only the first 100,000 titles were used.

# wikipedia_titles = File.read(File.join(File.dirname(__FILE__), '..', '..', 'data', 'enwiki-20080103-all-titles-in-ns0')).split("\n")
# wikipedia_titles.shift
# 
# File.open("wikipedia_titles.sql", "w") do |f|
#   f.write %{
#     drop table if exists wikipedia_titles;
# 
#     create table wikipedia_titles (
#       title varchar(256)
#     );
#   }
#   wikipedia_titles.each do |t|
#     f.write %{insert into wikipedia_titles (title) values}
#     f.write "("+ActiveRecord::Base.connection.quote(t)+");\n"
#   end
# end



# Now the benchmark

# words = File.read('/usr/share/dict/words').split("\n")
# 
# all_words = bench do
#   words.each do |w|
#     sql(%{select * from wikipedia_titles where to_tsvector('english', title) @@ to_tsquery('english', #{ActiveRecord::Base.connection.quote w});})
#   end
# end
# 
# puts "Searched on #{words.size} words in #{all_words}s"


# Tag cloud

