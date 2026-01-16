-- Customer Reporting (View Creation)
-- ====================================================
-- Problem Statement:
-- Stakeholders require a unified customer-level dataset containing key KPIs for reporting, dashboarding, and decision-making.

-- Business Questions:
-- What are the lifetime value, recency, frequency, and monetary metrics for each customer?
-- How can customers be categorized by age group and value segment?
-- Which customers are high-value but recently inactive?

create view gold.report_customers as
with base_query as(
select 
s.order_number,
s.product_key,
s.order_date,
s.sales_amount,
s.quantity,
c.customer_key,
c.customer_number,
concat(c.first_name,' ',c.last_name) as customer_name,
c.birthdate,
extract(year from age(current_date,birthdate)) as age
from gold.fact_sales as s
left join 
gold.dim_customers as c
on s.customer_key = c.customer_key
where s.order_date is not null)

,customer_aggregation as(
select 
customer_key,
customer_number,
customer_name,
age,
count(distinct order_number) as total_orders,
sum(sales_amount) as total_sales,
sum(quantity) as total_quantity,
max(order_date) as last_order_date,
extract(year from age(max(order_date),min(order_date))) * 12 +
extract (month from age(max(order_date),min(order_date))) as month_span,
count(distinct product_key) as total_products
from base_query
group by 
customer_key,
customer_number,
customer_name,
age
)
select 
customer_key,
customer_number,
customer_name,
age,
	case
		when age<20 then 'below 20'
		when age between 20 and 29 then '20 -29'
		when age between 30 and 39 then '30 -39'
		when age between 40 and 49 then '40 -49'
		else 'above 50'
	end as age_category,
	case 
 		when total_sales > 5000 and month_span >=12 then 'VIP'
 		when total_sales <= 5000 and month_span>=12 then 'Regular'
 		else 'New'
 	end as customer_segment,
total_orders,
total_sales,
total_quantity,
last_order_date,
month_span,
extract(year from (age(current_date,last_order_date))) *12 +
extract(month from (age(current_date,last_order_date))) as recency,
total_products,
case
	when total_orders = 0 then 0
	else
	total_sales/total_orders
end as  avg_order_value,
round(case 
		when month_span = 0 then total_sales
		else total_sales/month_span
      end,2) as avg_monthly_spend
from customer_aggregation

-- Logic / Approach:
-- Joined fact and dimension tables to create a base dataset.
-- Aggregated KPIs such as total orders, total sales, recency, tenure, and average order value.
-- Created derived fields (age group, customer segment, average monthly spend) using CASE and calculations.
-- Stored results in a SQL VIEW for easy reuse in BI tools.