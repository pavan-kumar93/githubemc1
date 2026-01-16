-- Performance Analysis (Average & YoY Comparison)

-- ====================================================
-- Problem Statement:
-- The business wants to evaluate product performance by comparing current sales against historical averages and previous year results.

-- Business Questions:
-- Which products are performing above or below their historical average?
-- How has each product’s sales changed compared to the previous year?
-- Which products show consistent growth or decline?

with yearly_product_sales as(
	 select
	 extract(year from s.order_date) as order_year,
	 p.product_name,
	 sum(s.sales_amount) as total_sales
	 from gold.fact_sales as s
	 left join gold.dim_products as p
	 on p.product_key = s.product_key
	 where order_date is not null
	 group by extract(year from order_date),p.product_name
	 order by product_name,order_year) 

select 
order_year,
product_name,
total_sales,
round(avg(total_sales) over(partition by product_name),2) as avg_sales,
total_sales - round(avg(total_sales) over(partition by product_name),2) as diff_avg,
case 
	when total_sales - round(avg(total_sales) over(partition by product_name),2) >0  then 'Above Average'
	when total_sales - round(avg(total_sales) over(partition by product_name),2) <0 then 'Below Average'
	else 'Avg'
	end as avg_change,
lag(total_sales) over(partition by product_name order by order_year) as py_sales,
total_sales - lag(total_sales) over(partition by product_name order by order_year) as yoy_diff,
case 
	when total_sales - lag(total_sales) over(partition by product_name order by order_year)> 0 then 'Increase'
	when total_sales - lag(total_sales) over(partition by product_name order by order_year) < 0 then 'Decrease'
	else 'No Change'
	end as yoy_change
from yearly_product_sales

-- Logic / Approach:
-- Aggregated yearly sales by product using CTEs.
-- Calculated average sales per product using AVG() OVER (PARTITION BY product).
-- Used LAG() to retrieve previous year’s sales for Year-over-Year comparison.
-- Classified performance using CASE statements.