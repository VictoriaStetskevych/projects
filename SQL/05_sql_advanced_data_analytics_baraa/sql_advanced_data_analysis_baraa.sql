USE DataWarehouseAnalytics;

SELECT Top 10 *
FROM [gold.dim_customers];

SELECT Top 10 *
FROM [gold.dim_products];

SELECT Top 10 *
FROM [gold.fact_sales];

--------------------------------------------------------------------- Change-Over-Time ------------------------------------------------------------------------------------------------------------

-- Analyze Sales Performance Over Time
SELECT
	order_date,
	SUM(sales_amount) as total_amount
FROM [gold.fact_sales]
WHERE order_date is not NULL
GROUP BY order_date
ORDER BY order_date;