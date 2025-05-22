USE DataWarehouseAnalytics;

SELECT Top 10 *
FROM [gold.dim_customers];

SELECT Top 10 *
FROM [gold.dim_products];

SELECT Top 10 *
FROM [gold.fact_sales];

--------------------------------------------------------------------- Report ------------------------------------------------------------------------------------------------------------

CREATE VIEW report_customers AS 
-- 1. Gather essential fields, such as names, ages, and transaction details
WITH q1 AS (
SELECT
	s.order_number,
	s.product_key,
	s.order_date,
	s.sales_amount,
	s.quantity,
	c.customer_key,
	c.customer_number,
	CONCAT (c.first_name, ' ', c.last_name) as customer_name,
	DATEDIFF(YEAR, c.birthdate, GETDATE()) - CASE 
        WHEN MONTH(c.birthdate) > MONTH(GETDATE()) 
             OR (MONTH(c.birthdate) = MONTH(GETDATE()) AND DAY(c.birthdate) > DAY(GETDATE()))
        THEN 1 
        ELSE 0 
		END as age
FROM [gold.fact_sales] s
LEFT JOIN [gold.dim_customers] c
ON c.customer_key = s.customer_key
WHERE s.order_date is not NULL
),
-- 3. Aggregate customer level metrics: 
-- - total orders
-- - total sales
-- - total quantity purchased
-- - total products
-- - lifespan(months)
q2 as (
SELECT 
	customer_key,
	customer_number,
	customer_name,
	age,
	COUNT(DISTINCT order_number) as total_orders,
	SUM(sales_amount) as total_sales,
	SUM(quantity) as total_quantity,
	COUNT(DISTINCT product_key) as total_products,
	MAX(order_date) as last_order_date,
	DATEDIFF(month, MIN(order_date), MAX(order_date)) as lifespan_months
FROM q1
GROUP BY
	customer_key,
	customer_number,
	customer_name,
	age
)
-- 2. Segment customers into categories (VIP, Regular, New) and age groups.
SELECT 
	customer_key,
	customer_number,
	customer_name,
	age,
	total_orders,
	total_sales,
	total_quantity,
	total_products,
	last_order_date,
	lifespan_months,
	CASE 
		WHEN lifespan_months >= 12 AND total_sales > 5000 THEN 'VIP'
		WHEN lifespan_months >= 12 AND total_sales <= 5000 THEN 'Regular'
		ELSE 'New'
	END customer_segement,
	CASE 
		WHEN age <= 20 THEN 'Under 20'
		WHEN age BETWEEN 20 AND 29 THEN '20-29'
		WHEN age BETWEEN 30 AND 39 THEN '30-39'
		WHEN age BETWEEN 40 AND 49 THEN '40-49'
		ELSE '50 and above'
	END AS age_category,
	-- recency (months since last order)
	DATEDIFF(month, last_order_date, GETDATE()) as recency ,
	-- average order value (AOV)
	CASE WHEN total_sales = 0 THEN 0 
		 ELSE total_sales/total_orders 
	END AS avg_order_value,
	-- average monthly spends 
	CASE WHEN lifespan_months = 0 THEN 0
		 ELSE total_sales/lifespan_months
	END AS avg_monthly_spends
FROM q2;

SELECT*
FROM report_customers;