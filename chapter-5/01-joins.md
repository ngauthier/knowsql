!SLIDE
# Chapter 5
## Join, Aggregate, View

!SLIDE bullets
# Example Schema
* User [id, name]
* Product [id, name, price]
* Order [id, user\_id, date]
* OrderProduct [product\_id, order\_id]

!SLIDE bullets
# Order Report Page
* Show top ten orders sorted by total cost
* Show the user name, date, and total cost

!SLIDE
# Basic ActiveRecord
    @@@ ruby
    o = Order.all
    o.sort! do |a,b|
      a.products.sum(&:price) <=>
      b.products.sum(&:price)
    end
    o = o[0..10]
    o.map do |order|
      { :user_name => order.user.name,
        :user_date => order.date,
        :total_cost => 
          order.products.sum(&:price)
      }
    end

!SLIDE bullets
# Clearly not the best solution
* 1 query for orders
* O(orders) queries for products
* O(orders) queries for users

!SLIDE
# First, join the tables
    @@@ ruby
    Order.select(%{
      users.name as user_name,
      orders.id as order_id,
      orders.created_at as order_date,
      products.id as product_id,
      products.price as product_price
    }).joins(%{
      join order_products on
       order_products.order_id = orders.id
      join products on 
       order_products.product_id = products.id
      join users on orders.user_id = users.id
    })

!SLIDE
# First, join the tables
    @@@ text 
     u_name | o_id | order_date | p_id | price 
    --------+------+------------+------+------
     alice  |    1 | 2010-01-01 |    1 |    10
     alice  |    1 | 2010-01-01 |    2 |     7
     alice  |    2 | 2010-01-05 |    3 |    35
     alice  |    2 | 2010-01-05 |    3 |    35
     bob    |    3 | 2010-01-08 |    1 |    10
     bob    |    3 | 2010-01-08 |    2 |     7
     bob    |    3 | 2010-01-08 |    3 |    35


!SLIDE
# Aggregate and sort
    @@@ ruby
    Order.select(%{
      users.name as user_name,
      orders.created_at as order_date,
      sum(products.price) as total_cost
    }).joins(%{
      join order_products on
       order_products.order_id = orders.id
      join products on 
       order_products.product_id = products.id
      join users on orders.user_id = users.id
    }).group('orders.id, user_name, order_date').
    order('total_cost DESC')

!SLIDE
# Aggregate and sort
    @@@ text
     user_name | order_date | total_cost 
    -----------+------------+------------
     alice     | 2010-01-05 |         70
     bob       | 2010-01-08 |         52
     alice     | 2010-01-01 |         17




!SLIDE bullets
# Aggregation requires grouping
* Tell SQL how to make a group
* Here, each order is our group
* Thus, prices are summed per-order

!SLIDE
# Make a view
    @@@ ruby
    Order.select(%{
      users.name as user_name,
      orders.created_at as order_date,
      sum(products.price) as total_cost
    }).joins(%{
      join order_products on
       order_products.order_id = orders.id
      join products on 
       order_products.product_id = products.id
      join users on orders.user_id = users.id
    }).group('orders.id, user_name, order_date').
    order('total_cost DESC').to_sql # <----

!SLIDE
# Make a view
### Copy that SQL into a migration
    @@@ ruby
    execute %{
      CREATE VIEW order_costs AS
      SELECT 
        users.name as user_name,
        orders.created_at as order_date,
        sum(products.price) as total_cost
       FROM "orders" join order_products on
         order_products.order_id = orders.id
        join products on 
         order_products.product_id = products.id
        join users on orders.user_id = users.id GROUP BY orders.id, user_name, order_date ORDER BY total_cost DESC
    }

!SLIDE
# Views act like Models
## Read Only
    @@@ ruby
    class OrderCost < ActiveRecord::Base
    end

    OrderCost.all.each do |order_cost|
      puts order_cost.user_name
      puts order_cost.order_date
      puts order_cost.total_cost
    end

