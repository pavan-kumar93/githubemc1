-- Part-to-Whole Analysis (Category Contribution)
-- ====================================================
-- Problem Statement:
-- The company needs to understand how much each product category contributes to total revenue to focus on key business drivers.

-- Business Questions:
-- What percentage of total sales does each category contribute?
-- Which categories are the major revenue contributors?

select 
category,
sales_per_category,
sum(sales_per_category) over() as total_sales,
concat(round(sales_per_category / sum(sales_per_category) over() *100,2),'%') as percentage_of_whole
from(
	select 
	p.category as category,
	sum(s.sales_amount) as sales_per_category
	from gold.fact_sales as s
	inner join gold.dim_products as p
	on p.product_key = s.product_key
	group by p.category) as t
	
-- Logic / Approach:
-- Calculated total sales by category.
-- Used window function SUM() OVER() to compute overall sales.
-- Derived contribution percentages by dividing category sales by total sales.