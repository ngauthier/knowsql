#!/usr/bin/env ruby
require File.join(File.dirname(__FILE__), '..', 'helper.rb')

text_lines = File.read(File.join(File.dirname(__FILE__), '..', '..', 'data', 'romeo_and_juliet.txt')).split("\n")

data = []
text_lines.each_with_index do |content, line|
  data << {:line => line, :content => content}
end

total_lines = data.size


sql %{
  drop table if exists romeo_and_juliet_lines;

  create table romeo_and_juliet_lines ( 
    line_no integer,
    contents varchar(256) 
  );
}

data.each do |row|
  sql %{insert into romeo_and_juliet_lines (line_no, contents) values (
    #{row[:line]}, #{ActiveRecord::Base.connection.quote(row[:content])}
  );}
end

puts "Inserted Romeo and Juliet"

puts "Performing 1000 finds without an index"
without_index = bench do
  1000.times do
    sql %{select * from romeo_and_juliet_lines where line_no = #{rand(total_lines)}}
  end
end

sql %{
  create index romeo_and_juliet_lines_line_no_idx on romeo_and_juliet_lines(line_no);
}

puts "Performing 1000 find with an index"
with_index = bench do
  1000.times do
    sql %{select * from romeo_and_juliet_lines where line_no = #{rand(total_lines)}}
  end
end


puts %{
without index #{without_index}
with index    #{with_index}
speedup       #{((without_index / with_index) * 100).to_i}
}

