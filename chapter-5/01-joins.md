!SLIDE
# Chapter 5
## Join, Aggregate, View

!SLIDE bullets
# Example Schema
* User [id, name]
* Product [id, name, price]
* Order [id, user_id, date]
* OrderProduct [product_id, order_id]

!SLIDE bullets
# Order Report Page
* Show all orders sorted by total cost
* Show the user name, date, and total cost

!SLIDE
# Basic ActiveRecord
    @@@ ruby
    orders = Order.all
    orders.sort! do |a,b|
      a.products.inject(0){|p,s| s + p.price} <=>
        b.products.inject(0){|p,s| s + p.price}
    end
    orders = orders[0..10]
    orders.map do |order|
      {
        :user_name => order.user.name,
        :user_date => order.date,
        :total_cost => order.products.inject(0){|p,s| s + p.price}
      }
    end

!SLIDE bullets
# Clearly not the best solution
* 1 query for orders
* O(orders) queries for products
* O(orders) queries for users

!SLIDE
# First, join the tables
    @@@ sql
    SELECT users.name AS user_name,
           orders.id AS order_id,
           orders.date AS order_date,
           products.id AS product_id,
           products.price AS product_price

    FROM orders
      JOIN orders_products ON
        (orders_products.order_id = orders.id)
      JOIN products ON
        (orders_products.product_id = products.id)
      JOIN users ON
        (orders.user_id = users.id)

!SLIDE
# First, join the tables
    @@@ text 
     user_name | order_id | order_date | p_id | price 
    -----------+----------+------------+------+------
     alice     |        1 | 2010-01-01 |    1 |    10
     alice     |        1 | 2010-01-01 |    2 |     7
     alice     |        2 | 2010-01-05 |    3 |    35
     alice     |        2 | 2010-01-05 |    3 |    35
     bob       |        3 | 2010-01-08 |    1 |    10
     bob       |        3 | 2010-01-08 |    2 |     7
     bob       |        3 | 2010-01-08 |    3 |    35


!SLIDE
# Aggregate the product prices and sort
    @@@ sql
    SELECT users.name AS user_name,
           orders.date AS order_date,
           sum(products.price) AS total_cost

    FROM orders
      JOIN orders_products ON
        (orders_products.order_id = orders.id)
      JOIN products ON
        (orders_products.product_id = products.id)
      JOIN users ON
        (orders.user_id = users.id)

    GROUP BY orders.id, users.name, orders.date
    ORDER BY total_cost DESC

!SLIDE
# Aggregate the product prices and sort
    @@@ text
     user_name |     order_date      | total_cost 
    -----------+---------------------+------------
     alice     | 2010-01-05 00:00:00 |         70
     bob       | 2010-01-08 00:00:00 |         52
     alice     | 2010-01-01 00:00:00 |         17




!SLIDE bullets
# Aggregation requires grouping
* Tell SQL how to make a group
* Here, each order is our group
* Thus, prices are summed per-order

!SLIDE
# For ease of abstraction, make it a View
    @@@ sql
    CREATE VIEW order_costs AS
      SELECT users.name AS user_name,
             orders.date AS order_date,
             sum(products.price) AS total_cost
      FROM orders
        JOIN orders_products ON
          (orders_products.order_id = orders.id)
        JOIN products ON
          (orders_products.product_id = products.id)
        JOIN users ON
          (orders.user_id = users.id)
      GROUP BY orders.id, users.name, orders.date
      ORDER BY total_cost DESC

!SLIDE
# Now we can use the view in Rails
    @@@ ruby
    class OrderCost < ActiveRecord::Base
    end

    OrderCost.all.each do |order_cost|
      puts order_cost.user_name
      puts order_cost.order_date
      puts order_cost.total_cost
    end

