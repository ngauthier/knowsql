#!/usr/bin/env ruby

text_lines = File.read(File.join(File.dirname(__FILE__), '..', '..', 'data', 'romeo_and_juliet.txt')).split("\n")

data = []
text_lines.each_with_index do |content, line|
  data << {:line => line, :content => content}
end


def bench(query)
  puts %{
    delete from benchmark;
    insert into benchmark (stamp) values (NOW());
    #{query}
    insert into benchmark (stamp) values (NOW());
    select (finish.stamp - start.stamp) as duration from
      (select stamp from benchmark limit 1) as start,
      (select stamp from benchmark limit 1 offset 1) as finish;
  }
end

puts %{
  drop table if exists romeo_and_juliet;
  drop table if exists benchmark;
  create table romeo_and_juliet ( line_no integer, contents varchar(256) );
  create index line_no_idx on romeo_and_juliet(line_no);
  create table benchmark ( stamp timestamp );

  insert into romeo_and_juliet (line_no, contents) values
    #{data.collect{|row| "(#{row[:line]}, E'#{row[:content].gsub("'", "''")}')"}.join(",\n")}
  ;

}
bench(%{
  select * from romeo_and_juliet where line_no = 4001;
  select * from romeo_and_juliet where line_no = 4101;
  select * from romeo_and_juliet where line_no = 4201;
  select * from romeo_and_juliet where line_no = 4301;
  select * from romeo_and_juliet where line_no = 4401;
  select * from romeo_and_juliet where line_no = 4501;
  select * from romeo_and_juliet where line_no = 4601;
  select * from romeo_and_juliet where line_no = 4701;
  select * from romeo_and_juliet where line_no = 4801;
  select * from romeo_and_juliet where line_no = 4901;
})




