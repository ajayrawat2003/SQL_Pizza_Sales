Drop database if exists Pizza_Sales_db;
create database Pizza_Sales_db;

Drop Table if exists Orders;
Create Table Orders (
  order_id int PRIMARY KEY,
  Order_date Date not null,
  Order_time time not null );
   
Drop Table if exists Orders_Details;
Create Table Orders_Details (
  order_details_id int Primary Key,
  order_id int not null,
  pizza_id	varchar(15),
  quantity int not null );
  
-- Retrieve the total number of orders placed.

select count(order_id) 
from orders as Order_Placed;

-- Calculate the total revenue generated from pizza sales.

select round(sum(od.quantity * pz.price),2) as Total_Sales 
  from pizzas pz join orders_details od
  on pz.pizza_id = od.pizza_id;

-- Identify the highest-priced pizza.

select pt.name, pz.price from pizza_types pt 
  join pizzas pz on pt.pizza_type_id = pz.pizza_type_id
  order by 2 desc
  limit 1 ;

-- Identify the most common pizza size ordered.

select pz.size,count(od.quantity) as Order_Count 
  from pizzas pz join orders_details od
  group by 1
  order by 2 desc;
 

-- List the top 5 most ordered pizza types along with their quantities.

select pt.name,count(od.quantity) as Order_Count from pizza_types pt 
  join pizzas pz on pt.pizza_type_id = pz.pizza_type_id 
  join orders_details od on od.pizza_id =  pz.pizza_id 
  group by 1
  order by 2 desc
  limit 5;

-- Intermediate:
-- Join the necessary tables to find the total quantity of each pizza category ordered.

select pt.category, sum(od.quantity) as orders from pizza_types pt 
  join pizzas pz on pt.pizza_type_id = pz.pizza_type_id 
  join orders_details od on od.pizza_id = pz.pizza_id
  group by category;

-- Determine the distribution of orders by hour of the day.

select hour(order_time) as Hours,count(order_id)as Orders
  from orders
  group by 1;

-- Join relevant tables to find the category-wise distribution of pizzas.

select category, count(name) as Pizzas_Types from pizza_types
group by 1;

-- Group the orders by date and calculate the average number of pizzas ordered per day.

select round(avg(quantity),0) as Avg_order from (select os.order_date, sum(od.quantity) as quantity
  from orders os join orders_details od
  on os.order_id = od.order_id
  group by 1) as order_quantity;

-- Determine the top 3 most ordered pizza types based on revenue

select pt.name, round(sum(od.quantity * pz.price),2) as revenue
  from orders_details od join pizzas pz
  on od.pizza_id = pz.pizza_id
  join pizza_types pt 
  on pt.pizza_type_id = pz.pizza_type_id
  group by 1
  order by 2 desc
  limit 3;

-- Advanced:
-- Analyze the cumulative revenue generated over time.
select order_date, sum(revenue) over (order by order_date) as cum_revenue 
  from
  (select os.order_date, sum(od.quantity * pz.price) as revenue
  from orders os join orders_details od
  on os.order_id = od.order_id
  join pizzas pz
  on pz.pizza_id = od.pizza_id 
  group by 1 ) as a;

