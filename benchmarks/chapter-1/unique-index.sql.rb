#!/usr/bin/env ruby
require File.join(File.dirname(__FILE__), '..', 'helper.rb')

sql %{
  drop table if exists random_numbers;
  drop sequence if exists random_numbers_id_seq;

  create sequence random_numbers_id_seq;
  create table random_numbers (
    id integer primary key default nextval('random_numbers_id_seq'),
    number integer not null
  );
  create index random_numbers_idx on random_numbers(number);
}

class RandomNumber < ActiveRecord::Base
end

10000.times do |i|
  sql %{insert into random_numbers (number) values (#{i.to_s});}
end

pg_duplicates = bench do
  1000.times do |i|
    begin
      sql %{insert into random_numbers values (#{i.to_s});}
    rescue ActiveRecord::StatementInvalid
    end
  end
end

ar_duplicates = bench do
  1000.times do |i|
    begin
      RandomNumber.create(:number => i)
    rescue ActiveRecord::StatementInvalid
    end
  end
end


sql %{
  delete from random_numbers;
  create unique index random_numbers_unique_idx on random_numbers(number);
}

pg_duplicates_unique = bench do
  1000.times do |i|
    begin
      sql %{insert into random_numbers values (#{i.to_s});}
    rescue ActiveRecord::StatementInvalid
    end
  end
end

class RandomNumberUnique < ActiveRecord::Base
  set_table_name 'random_numbers'
  validates_uniqueness_of :number
end

ar_duplicates_unique = bench do
  1000.times do |i|
    RandomNumberUnique.create(:number => i)
  end
end

require 'redis'
redis = Redis.new

10000.times do |i|
  redis.set i.to_s, true
end

redis_normal = bench do
  1000.times do |i|
    redis.set i.to_s, i.to_s
  end
end

redis_unique = bench do
  1000.times do |i|
    redis.setnx i.to_s, i.to_s
  end
end


puts "PG: #{pg_duplicates}"
puts "PU: #{pg_duplicates_unique}"
puts "AR: #{ar_duplicates}"
puts "AU: #{ar_duplicates_unique}"
puts "RN: #{redis_normal}"
puts "RU: #{redis_unique}"
