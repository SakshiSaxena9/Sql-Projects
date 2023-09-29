create database pizza_db;

#Import Csv File for pizza_sales 

USE pizza_db;

													#PIZZA SALES SQL QUERIES
#A. KPI’s

#1. Total Revenue:

select sum(total_price) as Total_Revenue from pizza_sales;

#2. Average Order Value:

select sum(total_price)/count(distinct order_id) as Average_Order_Value
from pizza_sales;

#3. Total Pizzas Sold:

select sum(quantity) as Total_Pizza_Sold from pizza_sales;

#4. Total Orders:

select count(distinct order_id) as Total_Orders from pizza_sales;

#5. Average Pizzas Per Order:

select round(sum(quantity)/count(distinct order_id),2) as Average_Pizza_Sold from pizza_sales;

#B. Daily Trend for Total Orders:

select dayname(order_date) as Day_Name , count(distinct order_id) as Total_Orders from pizza_sales
group by Day_Name
order by Total_Orders desc;

#C. Hourly Trend for Orders:

select hour(order_time) as Hour_ , count(distinct order_id) as Total_Orders from pizza_sales
group by Hour_
order by Hour_ ;

#D. % of Sales by Pizza Category:

select pizza_category, cast(sum(total_price) as decimal(10,2)) as Total_Revenue,
cast(sum(total_price)*100/(select sum(total_price) from pizza_sales) as decimal(10,2)) as Percent_Of_Total
from pizza_sales
group by pizza_category ;

#E. % of Sales by Pizza Size:

select pizza_size, cast(sum(total_price) as decimal(10,2)) as Total_Revenue,
cast(sum(total_price)*100/(select sum(total_price) from pizza_sales) as decimal(10,2)) as Percent_Of_Total
from pizza_sales
group by pizza_size 
order by Percent_Of_Total desc;

#F. Total Pizzas Sold by Pizza Category:

select pizza_category, Sum(quantity) as Total_Pizzas_Sold
from pizza_sales
group by pizza_category
order by Total_Pizzas_Sold desc;

#G. Top 5 Best Sellers by Total Pizzas Sold:

select Pizza_name, Sum(quantity) as Total_Pizzas_Sold
from pizza_sales
group by Pizza_name
order by Total_Pizzas_Sold desc
limit 5;

#H. Bottom 5 Best Sellers by Total Pizzas Sold:

select Pizza_name, Sum(quantity) as Total_Pizzas_Sold
from pizza_sales
group by Pizza_name
order by Total_Pizzas_Sold
limit 5
