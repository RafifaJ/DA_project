-- database
CREATE DATABASE IF NOT EXISTS walmartSales;

-- table
CREATE TABLE salessales(
 invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
 branch VARCHAR(5) NOT NULL,
 city VARCHAR(30) NOT NULL,
    customer_type VARCHAR(30) NOT NULL,
    gender VARCHAR(30) NOT NULL,
    product_line VARCHAR(100) NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    quantity INT NOT NULL,
    tax_pct FLOAT(6,4) NOT NULL,
    total DECIMAL(12, 4) NOT NULL,
    date DATETIME NOT NULL,
    time TIME NOT NULL,
    payment VARCHAR(15) NOT NULL,
    cogs DECIMAL(10,2) NOT NULL,
    gross_margin_pct FLOAT(11,9),
    gross_income DECIMAL(12, 4),
    rating FLOAT(2, 1)
);
select * from walmartsales.sales;
-- FEATURE ENGINEERING 
select 
 time,
 ( CASE 
    WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
    WHEN `time` BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
    ELSE "Evening"
    END
 ) AS time_of_day
from sales;

ALTER TABLE sales Add column time_of_day varchar(20);
SELECT * FROM SALES;
UPDATE sales
SET time_of_day =(
 CASE 
    WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
    WHEN `time` BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
    ELSE "Evening"
    END
);

-- adding day_name column
select 
 date, dayname(date) 
 from sales;
 
 alter table sales add column day_name varchar(10);

update sales
set day_name = dayname(date);

-- adding month name
select date, monthname(date) 
from sales;
 
alter table sales add column month_name varchar(10);

update sales 
set month_name = monthname(date);
-- unique city and branch
select distinct city, branch from sales;

select distinct product_line from sales;

-- What is most selling product line
select product_line, sum(quantity) as qty
 from sales
 group by product_line
 order by qty desc;
 
 -- what is the total revenue by month
 select
  month_name as month,
  sum(total) as total_revenue
 from sales
 group by month_name 
 order by total_revenue desc;
 
 -- what month had the largest cogs?
 select month_name as month, sum(cogs) AS cogs 
 from sales group by month_name order by cogs desc;
 
 -- what product line had the largest revenue?
 select product_line, 
  round(Sum(total),2) as total_revenue
 from sales
 group by product_line 
 order by total_revenue desc;
 -- which city has the largest revenue?
 select
 branch, city, sum(total) as total_revenue 
 from sales 
 group by city, branch 
 order by total_revenue; 
 -- which product line had the largest VAT?
 select product_line, avg(tax_pct) as avg_tax
 from sales group by product_line order by avg_tax desc;
 -- product line and average sale 
 select product_line, avg(quantity) as avg_qty,
 case
  when avg(quantity) > 5 then "GOOD"
  else "BAD"
 end as remark
 from sales group by product_line;
 
 -- which branch sold more products than average product sold?
 select branch, SUM(quantity) as qty
 from sales
 group by branch
 having SUM(quantity) > (SELECT avg(quantity) FROM sales);
 -- what is the most common product line by gender?
 select * from sales;
 select gender, product_line, count(gender) as total_cnt
 from sales 
 group by gender, product_line
 order by total_cnt desc;
 
 -- what is the average rating of each product line
 select product_line, round(avg(rating), 2) as avg_rating
 from sales group by product_line order by avg_rating desc;
 
 -- type of common customers
 select customer_type,
 COUNT(*) as count
from sales
group by customer_type
order by count desc;

-- which customer buys the most
select customer_type, COUNT(*)
from sales group by customer_type; 
-- which gender buys the most
select gender, count(*) as gender_cnt
from sales
group by gender 
order by gender_cnt desc;

-- what is the gender distribution per branch?
select gender, count(*) as gender_count, branch
from sales group by gender, branch order by gender_count desc;

-- Which time of the day do customers give most ratings?
select time_of_day, avg(rating) as avg_rating
from sales
group by time_of_day order by avg_rating desc;  

-- Which of the customer types brings the most revenue?
select customer_type, sum(total) as total_revenue
from sales 
group by customer_type
order by total_revenue desc;
-- Number of sales made in each time of the day per weekday
select time_of_day, count(*) as total_sales 
from sales
where day_name = "Monday"
group by time_of_day
order by total_sales desc;
 

