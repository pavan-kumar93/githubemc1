-- Customer Segmentation
-- ====================================================
-- Problem Statement:
-- The business wants to segment customers based on their purchasing behavior and relationship duration for targeted marketing and retention.

-- Business Questions:
-- How many customers fall into VIP, Regular, and New segments?
-- Which segment contributes the most revenue?
-- How does customer tenure relate to spending behavior?

with order_col as(
	select 
	c.customer_key as customer_key,
	sum(s.sales_amount) as total_sales,
	min(order_date) as first_order_date,
	max(order_date) as latest_order_date,
	extract (year from (age(max(order_date),min(order_date)))) *12 +
	extract (month from (age (max(order_date),min(order_date)))) as month_diff
	from gold.fact_sales as s
	left join gold.dim_customers as c
	on c.customer_key = s.customer_key
	group by c.customer_key
	order by c.customer_key
)
select customer_segment,
count(customer_key) 
from(
	select 
	customer_key,
	case 
		when total_sales > 5000 and month_diff >=12 then 'VIP'
		when total_sales <= 5000 and month_diff>=12 then 'Regular'
		else 'New'
	end as customer_segment
	from order_col) as t
where customer_segment is not null
group by customer_segment

-- Logic / Approach:
-- Calculated customer-level metrics: total spend, first order date, last order date, and tenure in months.
-- Applied business rules using CASE to classify customers into segments.
-- Aggregated customers by segment to analyze distribution.