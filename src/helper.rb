require 'rubygems'
require 'active_record'

def bench
  start = Time.now
  yield
  finish = Time.now
  finish - start
end

def sql(query)
  ActiveRecord::Base.connection.execute(query)
end

ActiveRecord::Base.establish_connection({
  :database => 'knowsql_examples', :adapter => 'postgresql'
})

