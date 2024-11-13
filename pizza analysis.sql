create database pizzahut;

Use pizzahut;

create table orders(
order_id int not null,
order_date date not null,
order_time time not null,
primary key(order_id)
);


create table order_details(
order_details_id int not null,
order_id int not null,
pizza_id text not null,
quantity int not null,
primary key(order_details_id)
);
SELECT * FROM pizzahut.pizzas;

SELECT * FROM pizzahut.pizza_types;

SELECT * FROM pizzahut.orders;

SELECT * FROM pizzahut.order_details;



#Basic:

#1.Retrieve the total number of orders placed.

SELECT 
    COUNT(*) AS total_number_of_orders
FROM
    orders;

#2.Calculate the total revenue generated from pizza sales.

SELECT 
    ROUND(SUM(p.price * od.quantity), 2) AS total_revenue
FROM
    pizzas AS p
        JOIN
    order_details AS od ON p.pizza_id = od.pizza_id
;

#3.Identify the highest-priced pizza.

SELECT 
    pz.name AS name, p.price AS price
FROM
    pizza_types AS pz
        JOIN
    pizzas AS p ON pz.pizza_type_id = p.pizza_type_id
ORDER BY price DESC
LIMIT 1;

#4.Identify the most common pizza size ordered.

SELECT 
    p.size AS size, COUNT(od.order_details_id) AS total_count
FROM
    pizzas AS p
        JOIN
    order_details AS od ON p.pizza_id = od.pizza_id
GROUP BY size
ORDER BY total_count DESC
LIMIT 1;

#5.List the top 5 most ordered pizza types along with their quantities.

SELECT 
    pt.name AS name, SUM(od.quantity) AS total_quantity
FROM
    pizza_types AS pt
        JOIN
    pizzas AS p ON pt.pizza_type_id = p.pizza_type_id
        JOIN
    order_details AS od ON od.pizza_id = p.pizza_id
GROUP BY name
ORDER BY total_quantity DESC
LIMIT 5;

#Intermediate:
#6.Join the necessary tables to find the total quantity of each pizza category ordered.

SELECT 
    pt.category AS category, SUM(od.quantity) AS total_quantity
FROM
    pizza_types AS pt
        JOIN
    pizzas AS p ON pt.pizza_type_id = p.pizza_type_id
        JOIN
    order_details AS od ON od.pizza_id = p.pizza_id
GROUP BY category
ORDER BY total_quantity DESC;

#7.Determine the distribution of orders by hour of the day.

SELECT 
    HOUR(order_time) AS hours, COUNT(order_id) AS total_order_count
FROM
    orders
GROUP BY HOUR(order_time);

#8.Join relevant tables to find the category-wise distribution of pizzas.

SELECT 
    category, COUNT(name) AS total
FROM
    pizza_types
GROUP BY category;

#9.Group the orders by date and calculate the average number of pizzas ordered per day.

SELECT 
    ROUND(AVG(quantity), 0) AS avg_pizzas_ordered_per_day
FROM
    (SELECT 
        o.order_date AS dates, SUM(od.quantity) AS quantity
    FROM
        orders AS o
    JOIN order_details AS od ON o.order_id = od.order_id
    GROUP BY dates) AS order_quantity;

#10.Determine the top 3 most ordered pizza types based on revenue.

SELECT 
    pt.name AS names, SUM(od.quantity * p.price) AS revenue
FROM
    pizza_types AS pt
        JOIN
    pizzas AS p ON pt.pizza_type_id = p.pizza_type_id
        JOIN
    order_details AS od ON od.pizza_id = p.pizza_id
GROUP BY names
ORDER BY revenue DESC
LIMIT 3;

#Advanced:
#11.Calculate the percentage contribution of each pizza type to total revenue.

SELECT 
    pt.category AS category,
    ROUND(SUM(od.quantity * p.price) / (SELECT 
                    ROUND(SUM(p.price * od.quantity), 2) AS total_revenue
                FROM
                    pizzas AS p
                        JOIN
                    order_details AS od ON p.pizza_id = od.pizza_id) * 100,
            2) AS revenue
FROM
    pizza_types AS pt
        JOIN
    pizzas AS p ON pt.pizza_type_id = p.pizza_type_id
        JOIN
    order_details AS od ON od.pizza_id = p.pizza_id
GROUP BY category
ORDER BY revenue DESC;

#12.Analyze the cumulative revenue generated over time.

select order_date,
sum(revenue)over(order by order_date)as cum_revenue
from
(select o.order_date,SUM(od.quantity * p.price)as revenue
from order_details as od
join pizzas as p on
od.pizza_id=p.pizza_id
join orders as o
on o.order_id=od.order_id
group by  o.order_date) as sales;

#13.Determine the top 3 most ordered pizza types based on revenue for each pizza category.

select name,revenue 
from
(select category,name,revenue,
rank()over(partition by category order by  revenue desc )as rn
from
(select pt.category ,pt.name ,SUM(od.quantity * p.price)as revenue
from pizza_types as pt 
join pizzas as p
on pt.pizza_type_id=p.pizza_type_id
join order_details as od
on od.pizza_id=p.pizza_id
group by pt.category ,pt.name)as a)as b
where rn<=3;

#showcase ,canva.com ,search, pizza sales ppt(free),customize 


















