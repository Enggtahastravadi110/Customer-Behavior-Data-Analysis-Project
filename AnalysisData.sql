-- create database customer_behavior; 
use customer_behavior;
-- select*from customer_table;

-- Q1. generate the total reveneu of male and female
-- select sum(purchase_amount),gender from customer_table as revenue group by gender;


-- Q2. which customer used a discount but still spent more than average purchase amount?
-- select * from customer_table 
-- where discount_applied = 'Yes' and purchase_amount >= (select avg(purchase_amount) from customer_table)

  
-- Q3. which are the top 5 products with the highest average review rating?
-- select item_purchased,round(avg(review_rating),2) 
-- as "Top Average Rating Product" 
-- from customer_table 
-- group by item_purchased 
-- order by avg(review_rating) desc 
-- limit 5; 


-- Q4. Compare the average purchase amounts beteen the standard and express shipping
-- select round(avg(purchase_amount),2), shipping_type 
-- from customer_table 
-- group by shipping_type 
-- having shipping_type = 'Express' or shipping_type = 'Standard'; 
-- OR
-- select round(avg(purchase_amount),2), shipping_type 
-- from customer_table 
-- where shipping_type in ('Standard','Express')
-- group by shipping_type


-- Q5.Do subscribed customers spent more? compare average spent and total revenue beteen subscribers and non-subscriber. 
-- select 
-- count(customer_id),
-- round(avg(purchase_amount),2) as "avg_purchase_amount", 
-- sum(purchase_amount) as "revenue" , 
-- subscription_status 
-- from customer_table 
-- group by subscription_status
-- order by revenue;


-- Q6. which 5 product have the highest percentage of purchases with discount applied?
-- select item_purchased as product,discount_applied, 
-- round(100 * sum(case when discount_applied = 'Yes' then 1 else 0 end)/count(*),2) as percentage_of_discount from customer_table
-- group by item_purchased
-- order by percentage_of_discount desc
-- limit 5;


-- Q7. segment customers count into new, returning , loyal based on their total number of previous purchase,and show the count of each segment.
-- alter table customer_table
-- add column segment varchar(50);
-- insert into cutomer_table(segment) case when previous_purchases > 35 then values("New") else   
-- delete segment from customer_table;
-- set sql_safe_updates = 0 ; 

-- update customer_table 
-- set segment = "New" 
-- where previous_purchases = 1 ;

-- update customer_table 
-- set segment = "Returning" 
-- where previous_purchases >= 2 and previous_purchases <= 10;

-- update customer_table 
-- set segment = "Loyal" 
-- where previous_purchases > 10 ;

-- select segment , count(*) from customer_table
-- group by segment;

-- with customer as (
-- select previous_purchases,
-- case
-- 	when previous_purchases = 1 then "New"
-- 	when previous_purchases between 2 and 10 then "Returning"
--     else "Loyal"
--     end as segment
-- from customer_table
-- )
-- select segment , count(*) as"Nomber of customer"
-- from customer_table
-- group by segment;
-- select*from customer_table;


-- Q8. what are the top 3 most purchased products within each category?
with item_counts as(
select item_purchased, 
category, 
count(customer_id), 
row_number() over(partition by category order by count(customer_id) desc)as item_rank
from customer_table
group by category,item_purchased
)
select item_rank, category, item_purchased
from item_counts
where item_rank <= 3;