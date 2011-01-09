!SLIDE
# Chapter 5
## Join, Aggregate, View

!SLIDE bullets
# Example Schema
* User [id, name]
* Product [id, name, price]
* Order [user_id, date]
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
* O queries for products
* O queries for users

!SLIDE
# First, join the tables
    @@@ sql
    SELECT users.name as user_name,
           orders.date as order_date,
           products.price as product_price,
    FROM orders
      join orders_products on (orders_products.order_id = order.id)
      join products on (orders_products.product_id = products.id)
      join users on (orders.user_id = users.id)

    RESULTS

!SLIDE
# Aggregate the product prices
    @@@ sql
    SELECT users.name as user_name,
           orders.date as order_date,
           sum(products.price) as total_cost,
    FROM orders
      join orders_products on (orders_products.order_id = order.id)
      join products on (orders_products.product_id = products.id)
      join users on (orders.user_id = users.id)
    GROUP BY orders.id

    RESULTS

!SLIDE bullets
# Aggregation requires grouping
* Tell SQL how to make a group
* Here, each order is our group
* Thus, prices are summed per-order

!SLIDE
# For ease of abstraction, make it a View
    @@@ sql
    CREATE VIEW order_costs AS
      SELECT users.name as user_name,
             orders.date as order_date,
             sum(products.price) as total_cost,
      FROM orders
        join orders_products on (orders_products.order_id = order.id)
        join products on (orders_products.product_id = products.id)
        join users on (orders.user_id = users.id)
      GROUP BY orders.id

!SLIDE
# Now we can use the view in Rails
    @@@ ruby
    class OrderCost < ActiveRecord::Base ; end
    OrderCost.all.each do |order_cost|
      puts order_cost.user_name
      puts order_cost.order_date
      puts order_cost.total_cost
    end







