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

--order_date together year_month
SELECT 
	DATETRUNC(month, order_date) as order_date,
	SUM(sales_amount) as total_sales,
	COUNT(DISTINCT customer_key) as total_customers,
	SUM(quantity) as total_quantity
FROM [gold.fact_sales]
WHERE order_date is not NULL
GROUP BY DATETRUNC(month, order_date)
ORDER BY DATETRUNC(month, order_date);


--------------------------------------------------------------------- Cumulative Analysis ------------------------------------------------------------------------------------------------------------

-- calculate the total sales per month and the running total of sales over time 
SELECT 
	order_date,
	sales_amount
FROM [gold.fact_sales];

SELECT 
	DATETRUNC(month, order_date) as order_date,
	SUM(sales_amount) as total_sales
FROM [gold.fact_sales]
WHERE order_date is not NULL
GROUP BY DATETRUNC(month, order_date)
ORDER BY DATETRUNC(month, order_date);

-- with running totals
SELECT 
	order_date,
	total_sales,
	SUM(total_sales) OVER (ORDER BY order_date) AS running_total_sales
FROM
(
SELECT 
	DATETRUNC(month, order_date) as order_date,
	SUM(sales_amount) as total_sales
FROM [gold.fact_sales]
WHERE order_date is not NULL
GROUP BY DATETRUNC(month, order_date)
) t

-- running totals by year  / month

SELECT 
	order_date,
	total_sales,
	SUM(total_sales) OVER (PARTITION BY DATETRUNC(year, order_date) ORDER BY order_date) AS running_total_sales
FROM
(
SELECT 
	DATETRUNC(month, order_date) as order_date,
	SUM(sales_amount) as total_sales
FROM [gold.fact_sales]
WHERE order_date is not NULL
GROUP BY DATETRUNC(month, order_date)
) t

-- running total sales accumulated by year

SELECT 
	order_date,
	total_sales,
	SUM(total_sales) OVER (ORDER BY order_date) AS running_total_sales
FROM
(
SELECT 
	DATETRUNC(year, order_date) as order_date,
	SUM(sales_amount) as total_sales
FROM [gold.fact_sales]
WHERE order_date is not NULL
GROUP BY DATETRUNC(year, order_date)
) t

-- moving average of the price

SELECT 
	order_date,
	total_sales,
	SUM(total_sales) OVER (ORDER BY order_date) AS running_total_sales,
	AVG(avg_price) OVER (ORDER BY order_date) AS moving_avg_price
FROM
(
SELECT 
	DATETRUNC(year, order_date) as order_date,
	SUM(sales_amount) as total_sales,
	AVG(price) as avg_price
FROM [gold.fact_sales]
WHERE order_date is not NULL
GROUP BY DATETRUNC(year, order_date)
) t

--------------------------------------------------------------------- Performance Analysis ------------------------------------------------------------------------------------------------------------

-- yearly performance by product
SELECT
	YEAR(s.order_date) as order_year,
	p.product_name,
	SUM(s.sales_amount) as current_sales
FROM [gold.fact_sales] s
LEFT JOIN [gold.dim_products] p
ON s.product_key = p.product_key
WHERE s.order_date is not NULL
GROUP BY YEAR(s.order_date), p.product_name
ORDER BY order_year, p.product_name;

-- yearly performance by product, compared to avd_sales
WITH yearly_product_sales AS (
  SELECT
    YEAR(s.order_date) AS order_year,
    p.product_name,
    SUM(s.sales_amount) AS current_sales
  FROM [gold.fact_sales] s
  LEFT JOIN [gold.dim_products] p
    ON s.product_key = p.product_key
  WHERE s.order_date IS NOT NULL
  GROUP BY YEAR(s.order_date), p.product_name
)
SELECT
  order_year,
  product_name,
  current_sales,
  AVG(current_sales) OVER (PARTITION BY product_name) AS avg_sales,
  current_sales - AVG(current_sales) OVER (PARTITION BY product_name) AS diff_avg
FROM yearly_product_sales
ORDER BY product_name, order_year;