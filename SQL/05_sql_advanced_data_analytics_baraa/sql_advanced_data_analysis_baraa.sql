USE DataWarehouseAnalytics;

SELECT Top 10 *
FROM [gold.dim_customers];

SELECT Top 10 *
FROM [gold.dim_products];

SELECT Top 10 *
FROM [gold.fact_sales];

--------------------------------------------------------------------- Change-Over-Time ------------------------------------------------------------------------------------------------------------

-- Analyze Sales Performance Over Time

--by day 
SELECT
	order_date,
	SUM(sales_amount) as total_amount
FROM [gold.fact_sales]
WHERE order_date is not NULL
GROUP BY order_date
ORDER BY order_date;

-- by year
SELECT
	YEAR(order_date) as order_year,
	SUM(sales_amount) as total_amount
FROM [gold.fact_sales]
WHERE order_date is not NULL
GROUP BY YEAR(order_date) 
ORDER BY YEAR(order_date);

-- by year, with customers and quantity data
SELECT
	YEAR(order_date) as order_year,
	SUM(sales_amount) as total_amount,
	COUNT(DISTINCT customer_key) as total_customers,
	SUM(quantity) as total_quantity
FROM [gold.fact_sales]
WHERE order_date is not NULL
GROUP BY YEAR(order_date) 
ORDER BY YEAR(order_date);

-- by month, with customers and quantity data
SELECT
	MONTH(order_date) as order_year,
	SUM(sales_amount) as total_amount,
	COUNT(DISTINCT customer_key) as total_customers,
	SUM(quantity) as total_quantity
FROM [gold.fact_sales]
WHERE order_date is not NULL
GROUP BY MONTH(order_date) 
ORDER BY MONTH(order_date);

-- by year and month, with customers and quantity data
SELECT
	YEAR(order_date) as order_year,
	MONTH(order_date) as order_month,
	SUM(sales_amount) as total_amount,
	COUNT(DISTINCT customer_key) as total_customers,
	SUM(quantity) as total_quantity
FROM [gold.fact_sales]
WHERE order_date is not NULL
GROUP BY YEAR(order_date), MONTH(order_date) 
ORDER BY YEAR(order_date), MONTH(order_date);