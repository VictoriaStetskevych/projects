USE DataWarehouseAnalytics;

SELECT Top 10 *
FROM [gold.dim_customers];

SELECT Top 10 *
FROM [gold.dim_products];

SELECT Top 10 *
FROM [gold.fact_sales];

SELECT *
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'gold.dim_customers';

------------------------------------------------------------------------------------------------------------------------------------

-- country 
SELECT DISTINCT country
FROM [gold.dim_customers];

-- category
SELECT DISTINCT category
FROM [gold.dim_products];

-- category, subcategory
SELECT DISTINCT category, subcategory
FROM [gold.dim_products];

-- category, subcategory, product_name
SELECT DISTINCT category, subcategory, product_name
FROM [gold.dim_products];

-- gender
SELECT gender,
	   COUNT (*) as gender_count
FROM [gold.dim_customers]
GROUP BY gender;

-- gender and marital status
SELECT gender,
       marital_status,
       COUNT(*) AS gender_count
FROM [gold.dim_customers]
GROUP BY gender, marital_status;

-- max/min age
SELECT MAX(birthdate) AS youngest
FROM [gold.dim_customers];

SELECT MIN(birthdate) AS oldest
FROM [gold.dim_customers];

SELECT
MIN(birthdate) as oldest_birthday,
DATEDIFF(year, MIN(birthdate), GETDATE()) as oldest_age,
MAX(birthdate) as youngest_birthday,
DATEDIFF(year, MAX(birthdate), GETDATE()) as youngest_age
FROM [gold.dim_customers];


-- amount of customers
SELECT COUNT(DISTINCT customer_id) AS distinct_customers_count
FROM [gold.dim_customers];

-- age and age category
WITH AgeCalculatiion AS (
SELECT *,
    DATEDIFF(YEAR, birthdate, GETDATE()) 
    - CASE 
        WHEN MONTH(birthdate) > MONTH(GETDATE()) 
             OR (MONTH(birthdate) = MONTH(GETDATE()) AND DAY(birthdate) > DAY(GETDATE()))
        THEN 1 
        ELSE 0 
      END AS age
FROM [gold.dim_customers]
)
SELECT *,
CASE 
    WHEN age <= 29 THEN 'Young'
    WHEN age BETWEEN 30 AND 55 THEN 'Middle'
    ELSE 'Old'
END AS [age_category]
FROM AgeCalculatiion;

-- max/min prices
SELECT TOP 1 
    s.price AS max_price,
    p.category,
    p.subcategory,
    p.product_name
FROM [gold.fact_sales] s
JOIN [gold.dim_products] p
    ON s.product_key = p.product_key
ORDER BY s.price DESC;

SELECT TOP 1 
    s.price AS min_price,
    p.category,
    p.subcategory,
    p.product_name
FROM [gold.fact_sales] s
JOIN [gold.dim_products] p
    ON s.product_key = p.product_key
ORDER BY s.price ASC;

SELECT MIN(order_date) as first_order 
FROM [gold.fact_sales];

SELECT MAX(order_date) as last_order 
FROM [gold.fact_sales];

SELECT MIN(order_date) as first_order, 
	   MAX(order_date) as last_order,
	   DATEDIFF(year, MIN(order_date), MAX(order_date)) as order_range_years
FROM [gold.fact_sales];

---------------------------------------------------------------------------------------------------------------------------

-- sales table
SELECT Top 10 *
FROM [gold.fact_sales];

-- total sales
SELECT 
	SUM(sales_amount) as total_sales
FROM [gold.fact_sales];

-- total quantity (items sold)
SELECT 
	SUM(quantity) as total_quantity
FROM [gold.fact_sales];

-- average price
SELECT 
	AVG(price) as avg_price
FROM [gold.fact_sales];

-- total number of orders
SELECT 
	COUNT(DISTINCT order_number) as total_orders
FROM [gold.fact_sales];

-- total number of product
SELECT 
	COUNT(product_key) as total_products
FROM [gold.dim_products];

-- total number of customers that has placed an order
SELECT 
	COUNT(DISTINCT customer_key) as total_customers_who_ordered
FROM [gold.fact_sales];

----------------------------------- Generate a report ----------------------------------------------------------------------------------

SELECT 'Total Sales' as measure_name, SUM(sales_amount) as measure_value FROM [gold.fact_sales]
UNION ALL 
SELECT 'Total Quantity' as  measure_name, SUM(quantity) as  measure_value FROM [gold.fact_sales]
UNION ALL
SELECT 'Average Price'  as  measure_name, AVG(price) as measure_value FROM [gold.fact_sales]
UNION ALL
SELECT 'Total Nr Orders' as  measure_name, COUNT(DISTINCT order_number) as measure_value FROM [gold.fact_sales]
UNION ALL
SELECT 'Total Nr Product' as  measure_name, COUNT(product_key) as measure_value FROM [gold.dim_products]
UNION ALL
SELECT 'Total Nr Customers' as  measure_name, COUNT(DISTINCT customer_key) as measure_value FROM [gold.fact_sales];

----------------------------------- Magnitude Analysis ----------------------------------------------------------------------------------

-- customers by country
SELECT country,
	   COUNT(customer_key) as total_customers
FROM [gold.dim_customers]
GROUP BY country
ORDER BY total_customers DESC;

-- total products by category
SELECT
	category,
	COUNT(product_key) as total_product
FROM [gold.dim_products]
GROUP BY category
ORDER BY total_product DESC;

-- average cost in each category
SELECT
	category,
	COUNT(product_key) as total_product,
		AVG(cost) as avg_cost
FROM [gold.dim_products]
GROUP BY category
ORDER BY avg_cost DESC;

-- total revenue for each category
SELECT
	p.category,
	SUM(s.sales_amount) as total_revenue
FROM [gold.fact_sales] s
LEFT JOIN [gold.dim_products] p
ON p.product_key = s.product_key
GROUP BY category
ORDER BY total_revenue DESC;

-- total revenue by each customer
SELECT 
	s.customer_key as customer_key,
	SUM(s.sales_amount) as total_revenue,
	c.first_name,
	c.last_name
FROM [gold.fact_sales] s
LEFT JOIN [gold.dim_customers] c
ON c.customer_key = s.customer_key
GROUP BY s.customer_key, c.first_name, c.last_name
ORDER BY total_revenue DESC;

-- sold items across countries 
SELECT 
	c.country,
	SUM(s.quantity) as total_sold_items 
FROM [gold.fact_sales] s
LEFT JOIN [gold.dim_customers] c
ON c.customer_key = s.customer_key
GROUP BY c.country
ORDER BY total_sold_items  DESC;


----------------------------------- Ranking Analysis ----------------------------------------------------------------------------------

--top 5 products. The highest revenue
SELECT TOP 5
	p.product_name,
	SUM(s.sales_amount) as total_revenue 
FROM [gold.fact_sales] s
LEFT JOIN [gold.dim_products] p
ON p.product_key = s.product_key
GROUP BY p.product_name
ORDER BY total_revenue DESC;

--bottom 5 products. The lowest revenue
SELECT TOP 5
	p.product_name,
	SUM(s.sales_amount) as total_revenue 
FROM [gold.fact_sales] s
LEFT JOIN [gold.dim_products] p
ON p.product_key = s.product_key
GROUP BY p.product_name
ORDER BY total_revenue ASC; 

--top 5 subcategories. The highest revenue
SELECT TOP 5
	p.subcategory,
	SUM(s.sales_amount) as total_revenue 
FROM [gold.fact_sales] s
LEFT JOIN [gold.dim_products] p
ON p.product_key = s.product_key
GROUP BY p.subcategory
ORDER BY total_revenue DESC;

-- bottom 5 subcategories. The highest revenue
SELECT TOP 5
	p.subcategory,
	SUM(s.sales_amount) as total_revenue 
FROM [gold.fact_sales] s
LEFT JOIN [gold.dim_products] p
ON p.product_key = s.product_key
GROUP BY p.subcategory
ORDER BY total_revenue ASC;

-- product ranking. top 5 products 
SELECT *
FROM(
	SELECT
		p.product_name,
		SUM(s.sales_amount) as total_revenue,
		ROW_NUMBER() OVER (ORDER BY SUM (s.sales_amount) DESC) as rank_products
		FROM [gold.fact_sales] s
		LEFT JOIN [gold.dim_products] p
		ON p.product_key = s.product_key
		GROUP BY p.product_name) as rank_products
WHERE rank_products <= 5;

-- product ranking. bottom 5 products 
SELECT *
FROM(
	SELECT
		p.product_name,
		SUM(s.sales_amount) as total_revenue,
		ROW_NUMBER() OVER (ORDER BY SUM (s.sales_amount) ASC) as rank_products
		FROM [gold.fact_sales] s
		LEFT JOIN [gold.dim_products] p
		ON p.product_key = s.product_key
		GROUP BY p.product_name) as rank_products
WHERE rank_products <= 5;

-- top 10 customers with the highest revenue
SELECT *
FROM(
	SELECT 
		c.customer_key,
		c.first_name,
		c.last_name,
		SUM(s.sales_amount) AS total_sales,
		ROW_NUMBER() OVER (ORDER BY SUM(s.sales_amount) DESC) as rank_customers
	FROM [gold.dim_customers] c
	LEFT JOIN [gold.fact_sales] s
	ON c.customer_key = s.customer_key
	GROUP BY c.customer_key, c.first_name, c.last_name) as rank_customers
WHERE rank_customers <=10;

-- top 11 customers with the fewest Nr of Orders
SELECT *
FROM (
	SELECT 
		c.customer_key,
		c.first_name,
		c.last_name,
		COUNT(DISTINCT s.order_number) AS order_number,
		ROW_NUMBER() OVER (ORDER BY COUNT(DISTINCT s.order_number) ASC) AS rank_customers
	FROM [gold.dim_customers] c
	LEFT JOIN [gold.fact_sales] s
		ON c.customer_key = s.customer_key
	GROUP BY c.customer_key, c.first_name, c.last_name
) AS ranked_customers
WHERE rank_customers <= 11
ORDER BY customer_key;

SELECT *
FROM [gold.fact_sales]
WHERE customer_key = 16;

SELECT *
FROM [gold.dim_customers]
WHERE customer_key = 16;