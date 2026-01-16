-- Trend Analysis (Change Over Time)
-- ====================================================
-- Problem Statement:
-- The business wants to understand how sales, customer activity, and order volume
-- evolve over time in order to identify growth patterns, seasonality, and peak periods.

-- Business Questions:
-- 1) How do total sales and customer count change year over year and month over month?
-- 2) Are there seasonal trends in sales across months?
-- 3) Which days of the week generate the highest revenue and customer activity?

SELECT 
    DATE(DATE_TRUNC('month', order_date)) AS month_start,
    SUM(sales_amount) AS total_sales,
    SUM(quantity) AS total_quantity,
    COUNT(DISTINCT customer_key) AS total_customers
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY DATE_TRUNC('month', order_date)
ORDER BY month_start;

-- ----------------------------------------------------
-- Logic / Approach
-- ----------------------------------------------------
-- 1) Used DATE_TRUNC to bucket transactions at monthly level.
-- 2) Aggregated sales, quantity, and distinct customers.
-- 3) Ordered by month to analyze seasonality and growth trend.
