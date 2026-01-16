-- Cumulative Analysis
-- ====================================================
-- Problem Statement:
-- Management wants to track the overall growth of the business by observing how revenue accumulates over time.

-- Business Questions:
-- How does cumulative sales grow year by year (or month by month)?
-- Is the business showing steady growth or periods of decline?

select 
order_year,
total_sales,
round(sum(total_sales) over(order by order_year),2) as cumulative_sales,
round(avg(avg_sales) over(order by order_year),1) as cumulative_avg,
round(avg_sales,2) as avg_sales
from
   (SELECT 
        cast(date_trunc('year',order_date) as date) AS order_year,
        SUM(sales_amount) AS total_sales,
		avg(sales_amount) as avg_sales
    FROM gold.fact_sales
    WHERE order_date IS NOT NULL
    GROUP BY date_trunc('year',order_date)
   )  as t

-- Logic / Approach:
-- Aggregated sales at the required time level (year/month).
-- Used window functions SUM() OVER (ORDER BY date) to calculate running totals.
-- Ordered data by time to compute cumulative progression.
