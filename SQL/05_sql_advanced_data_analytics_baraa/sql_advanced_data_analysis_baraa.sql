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

-- yearly performance by product, compared to average sales
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
	current_sales - AVG(current_sales) OVER (PARTITION BY product_name) AS diff_avg,
	CASE WHEN current_sales - AVG(current_sales) OVER (PARTITION BY product_name) > 0 THEN 'Above Avg'
		 WHEN current_sales - AVG(current_sales) OVER (PARTITION BY product_name) < 0 THEN 'Below Avg'
		 ELSE 'Avg'
	END avg_change
FROM yearly_product_sales
ORDER BY product_name, order_year;

-- yearly performance by product, compared to previous year sales
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
-- Year-over-Year analysis 
SELECT
	order_year,
	product_name,
	current_sales,
	AVG(current_sales) OVER (PARTITION BY product_name) AS avg_sales,
	current_sales - AVG(current_sales) OVER (PARTITION BY product_name) AS diff_avg,
	CASE 
		 WHEN current_sales - AVG(current_sales) OVER (PARTITION BY product_name) > 0 THEN 'Above Avg'
		 WHEN current_sales - AVG(current_sales) OVER (PARTITION BY product_name) < 0 THEN 'Below Avg'
		 ELSE 'Avg'
	END avg_change,
	LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year) py_sales, 
	current_sales - LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year) as diff_py,
	CASE 
		 WHEN current_sales - LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year) > 0 THEN 'Increase'
		 WHEN current_sales - LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year) < 0 THEN 'Decrease'
		 ELSE 'No change'
	END py_change
FROM yearly_product_sales
ORDER BY product_name, order_year;


-- yearly performance by product, compared to previous month sales 
WITH yearly_product_sales AS (
  SELECT
    YEAR(s.order_date) AS order_year,
    MONTH(s.order_date) AS order_month,
    p.product_name,
    SUM(s.sales_amount) AS current_sales
  FROM [gold.fact_sales] s
  LEFT JOIN [gold.dim_products] p
    ON s.product_key = p.product_key
  WHERE s.order_date IS NOT NULL
  GROUP BY YEAR(s.order_date), MONTH(s.order_date), p.product_name
)
-- Month-over-Month analysis 
SELECT
	order_year,
	order_month,
	product_name,
	current_sales,
	AVG(current_sales) OVER (PARTITION BY product_name) AS avg_sales,
	current_sales - AVG(current_sales) OVER (PARTITION BY product_name) AS diff_avg,
	CASE 
		 WHEN current_sales - AVG(current_sales) OVER (PARTITION BY product_name) > 0 THEN 'Above Avg'
		 WHEN current_sales - AVG(current_sales) OVER (PARTITION BY product_name) < 0 THEN 'Below Avg'
		 ELSE 'Avg'
	END avg_change,
	LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_month) prevmonth_sales, 
	current_sales - LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_month) as diff_prevmonth,
	CASE 
		 WHEN current_sales - LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_month) > 0 THEN 'Increase'
		 WHEN current_sales - LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_month) < 0 THEN 'Decrease'
		 ELSE 'No change'
	END py_change
FROM yearly_product_sales
ORDER BY product_name, order_month, order_year;


--------------------------------------------------------------------- Part-to-Whole, % (Proportional Analysis) ------------------------------------------------------------------------------------------------------------

-- total sales by each category
SELECT
	p.category,
	SUM(s.sales_amount) as total_sales
FROM [gold.fact_sales] s
LEFT JOIN [gold.dim_products] p
ON p.product_key = s.product_key
GROUP BY p.category
ORDER BY total_sales DESC;

-- which categories contribute the most to overall sales
WITH category_sales AS (
SELECT
	p.category,
	SUM(s.sales_amount) as total_sales
FROM [gold.fact_sales] s
LEFT JOIN [gold.dim_products] p
ON p.product_key = s.product_key
GROUP BY p.category
)
SELECT 
	category,
	total_sales,
	SUM (total_sales) OVER () as overall_sales,
	CONCAT(ROUND((CAST(total_sales as FLOAT) / SUM (total_sales) OVER ())*100, 2), '%') as persentage_of_total
FROM category_sales
ORDER BY total_sales DESC;

--------------------------------------------------------------------- Data Segmentation  ------------------------------------------------------------------------------------------------------------

-- segment products into cost range

SELECT
	product_key,
	product_name, 
	cost,
	CASE WHEN cost < 100 THEN 'Below 100'
	WHEN cost BETWEEN 100 and 500 THEN '100-500'
	WHEN cost BETWEEN 500 and 1000 THEN '500-1000'
	ELSE 'Above 1000'
	END cost_range
FROM [gold.dim_products];

-- count how many products fall into each segment
WITH product_segment AS (
SELECT
	product_key,
	product_name, 
	cost,
	CASE WHEN cost < 100 THEN 'Below 100'
	WHEN cost BETWEEN 100 and 500 THEN '100-500'
	WHEN cost BETWEEN 500 and 1000 THEN '500-1000'
	ELSE 'Above 1000'
	END cost_range
FROM [gold.dim_products]
)
SELECT 
	cost_range,
	COUNT (product_key) as total_products
FROM product_segment
GROUP BY cost_range
ORDER BY total_products DESC;


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

-- count customers age categories
;WITH AgeCalculatiion AS (
SELECT *,
    DATEDIFF(YEAR, birthdate, GETDATE()) 
    - CASE 
        WHEN MONTH(birthdate) > MONTH(GETDATE()) 
             OR (MONTH(birthdate) = MONTH(GETDATE()) AND DAY(birthdate) > DAY(GETDATE()))
        THEN 1 
        ELSE 0 
      END AS age
FROM [gold.dim_customers]
),
	total_age_categories AS (
SELECT *,
CASE 
    WHEN age <= 29 THEN 'Young'
    WHEN age BETWEEN 30 AND 55 THEN 'Middle'
    ELSE 'Old'
END AS [age_category]
FROM AgeCalculatiion
)
SELECT 
	age_category,
	COUNT(customer_key) as total_customers
FROM total_age_categories
GROUP BY age_category
ORDER BY total_customers DESC;

SELECT 
COUNT(DISTINCT(customer_id))
FROM [gold.dim_customers];

-- customers that bought
SELECT *
FROM [gold.dim_customers];

SELECT *
FROM [gold.fact_sales];

SELECT 
	COUNT(customer_key) as total_customers
FROM [gold.fact_sales];

SELECT 
	SUM(sales_amount)
FROM [gold.fact_sales];

-- customers who bought: age category, sales, total_quantity % per each category
;WITH AgeCalculatiion AS (
SELECT *,
    DATEDIFF(YEAR, birthdate, GETDATE()) 
    - CASE 
        WHEN MONTH(birthdate) > MONTH(GETDATE()) 
             OR (MONTH(birthdate) = MONTH(GETDATE()) AND DAY(birthdate) > DAY(GETDATE()))
        THEN 1 
        ELSE 0 
      END AS age
FROM [gold.dim_customers]
),
	total_age_categories AS (
SELECT *,
CASE 
    WHEN age <= 29 THEN 'Young'
    WHEN age BETWEEN 30 AND 55 THEN 'Middle'
    ELSE 'Old'
END AS [age_category]
FROM AgeCalculatiion
),
	customer_categories AS (
SELECT 
	COUNT(s.customer_key) as total_customers_by_category,
	age_category,
	SUM(s.sales_amount) as total_category_sales
FROM total_age_categories a
LEFT JOIN [gold.fact_sales] s
ON a.customer_key = s.customer_key
GROUP BY age_category
), 
	customer_categories_2 AS (
SELECT 
	*,
    SUM(total_category_sales) OVER () AS total_sales,
	SUM(total_customers_by_category) OVER () AS total_customers
FROM customer_categories
) 
SELECT
	*,
	CONCAT(ROUND(CAST(total_category_sales AS FLOAT) / total_sales * 100, 2), ' %') AS percent_of_total_sales,
	CONCAT(ROUND(CAST(total_customers_by_category AS FLOAT) / total_customers * 100, 2), ' %') AS percent_of_total_customers
FROM customer_categories_2
ORDER BY total_customers_by_category DESC;


-- group customers into three segment based on their spending behaviour,
	-- VIP: at least 12 months of history and spending more than 5000 Euro
	-- Regular: at least 12 months of history and spending more than 5000 Euro or less
	-- New: lefespan less than 12 months

WITH customer_spending AS
(
SELECT
	c.customer_key,
	SUM(s.sales_amount) as total_spending,
	MIN(order_date) as first_order,
	MAX(order_date) as last_order, 
	DATEDIFF(MONTH, MIN(order_date), MAX(order_date)) as lifespan_months
FROM [gold.fact_sales] s
LEFT JOIN [gold.dim_customers] c
ON s.customer_key = c.customer_key
GROUP BY c.customer_key
)
SELECT
	customer_key,
	total_spending,
	lifespan_months,
	CASE WHEN lifespan_months >= 12 AND total_spending > 5000 THEN 'VIP'
		 WHEN lifespan_months >= 12 AND total_spending <= 5000 THEN 'Regular'
	ELSE 'New'
	END customer_segement
FROM customer_spending
ORDER BY total_spending DESC;

-- total number customers by each group
;WITH customer_spending AS
(
SELECT
	c.customer_key,
	SUM(s.sales_amount) as total_spending,
	MIN(order_date) as first_order,
	MAX(order_date) as last_order, 
	DATEDIFF(MONTH, MIN(order_date), MAX(order_date)) as lifespan_months
FROM [gold.fact_sales] s
LEFT JOIN [gold.dim_customers] c
ON s.customer_key = c.customer_key
GROUP BY c.customer_key
),
customer_spending_2 as (
SELECT
	customer_key,
	total_spending,
	lifespan_months,
	CASE WHEN lifespan_months >= 12 AND total_spending > 5000 THEN 'VIP'
		 WHEN lifespan_months >= 12 AND total_spending <= 5000 THEN 'Regular'
	ELSE 'New'
	END customer_segment
FROM customer_spending
)
SELECT 
	COUNT(customer_key) as customers, 
	SUM(total_spending) as spending,
	customer_segment
FROM customer_spending_2 
GROUP BY customer_segment
ORDER BY SUM(total_spending) DESC;


-- % -- total number customers by each group
;WITH customer_spending AS
(
SELECT
	c.customer_key,
	SUM(s.sales_amount) as total_spending,
	MIN(order_date) as first_order,
	MAX(order_date) as last_order, 
	DATEDIFF(MONTH, MIN(order_date), MAX(order_date)) as lifespan_months
FROM [gold.fact_sales] s
LEFT JOIN [gold.dim_customers] c
ON s.customer_key = c.customer_key
GROUP BY c.customer_key
),
customer_spending_2 as (
SELECT
	customer_key,
	total_spending,
	lifespan_months,
	CASE WHEN lifespan_months >= 12 AND total_spending > 5000 THEN 'VIP'
		 WHEN lifespan_months >= 12 AND total_spending <= 5000 THEN 'Regular'
	ELSE 'New'
	END customer_segment
FROM customer_spending
), 
customer_spending_3 as (
SELECT 
	COUNT(customer_key) as customers, 
	SUM(total_spending) as spending,
	customer_segment
FROM customer_spending_2 
GROUP BY customer_segment
)
SELECT
	*,
	SUM(spending) OVER() as total_spending,
	CONCAT(ROUND((CAST(spending as FLOAT)/(SUM(spending) OVER())*100),2), ' %') as percent_spending
FROM customer_spending_3 
ORDER BY spending DESC;


