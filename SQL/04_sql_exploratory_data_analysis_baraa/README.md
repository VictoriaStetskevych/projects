# SQL Exploratory Data Analysis (EDA) Project

In Progress!

This project was made using Baraa Khatib Salkini's YouTube [tutorials](https://www.youtube.com/watch?v=6cJ5Ji8zSDg) that I found on Baraa's YouTube Channel ["Data with Baraa"](https://www.youtube.com/@DataWithBaraa).

# Process

## 1. Upload and Explore data.

In this project I was using three datasets 
- [gold.dim_customers.csv](https://github.com/VictoriaStetskevych/projects/blob/main/SQL/04_sql_exploratory_data_analysis_baraa/data/gold.dim_customers.csv)
- [gold.dim_products.csv](https://github.com/VictoriaStetskevych/projects/blob/main/SQL/04_sql_exploratory_data_analysis_baraa/data/gold.dim_products.csv), 
- [gold.fact_sales.csv](https://github.com/VictoriaStetskevych/projects/blob/main/SQL/04_sql_exploratory_data_analysis_baraa/data/gold.fact_sales.csv):

```sql
SELECT Top 10 *
FROM [gold.dim_customers];
```
Result:
01_customers

```sql
SELECT Top 10 *
FROM [gold.dim_products];
```
Result:
02_products

```sql
SELECT Top 10 *
FROM [gold.fact_sales];
```
Result:
03_sales.png

Additional way to explore data tables
```sql
SELECT *
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'gold.dim_customers';
```
Result:
04_explore.png

## 2. Dimensions Exploration 

Goal: Identify the unique values (or categories) in each dimensions. Recognize how data might be grouped or segmented. 

- the countries customers come from.
```sql
SELECT DISTINCT country
FROM [gold.dim_customers];
```
Result: 6 countries
05_countries.png

- product categories 
```sql
SELECT DISTINCT category
FROM [gold.dim_products];
```
Result: 4 categories
06_categories.png

- product subcategories
```sql
SELECT DISTINCT category, subcategory
FROM [gold.dim_products];
```
Result: 36 subcategories
07_subcategories.png

- products
```sql
SELECT DISTINCT category, subcategory, product_name
FROM [gold.dim_products];
```
Result: 295 positions 
08_products.png

- min / max prices
```sql
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
```
Result:
14_max_min_price.png

## 3. Date Exploration

Goal: to identify the earliest and the latest dates. Understand the scoop of data and the timespan.

- date of the first and last orders
```sql
SELECT MIN(order_date) as first_order 
FROM [gold.fact_sales];

SELECT MAX(order_date) as last_order 
FROM [gold.fact_sales];

SELECT MIN(order_date) as first_order, 
	   MAX(order_date) as last_order,
	   DATEDIFF(year, MIN(order_date), MAX(order_date)) as order_range_years
FROM [gold.fact_sales];
```
Result:
15_first_last_order.png

- youngest and oldest customer's age
```sql
SELECT
MIN(birthdate) as oldest_birthday,
DATEDIFF(year, MIN(birthdate), GETDATE()) as oldest_age,
MAX(birthdate) as youngest_birthday,
DATEDIFF(year, MAX(birthdate), GETDATE()) as youngest_age
FROM [gold.dim_customers];
```
Result:
11_age.png

-- age and age category
```sql
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
```
Result:
13_age_category.png

## 3. Measures Exploration

Goal: calculate the key metrics of the business (Big Numbers). Highest level of Aggregation / Lowest levels of Details. (SUM, AVERAGE, COUNT)

- total sales 
```sql
SELECT 
	SUM(sales_amount) as total_sales
FROM [gold.fact_sales];
```
Result: 16_total_sales.png

- total quantity (items sold)
```sql
SELECT 
	SUM(quantity) as total_quantity
FROM [gold.fact_sales];
```
Result: 17_total_quantity.png

- average price
```sql
SELECT 
	AVG(price) as avg_price
FROM [gold.fact_sales];
```
Result: 18_average_price.png

- total number of orders
```sql
SELECT 
	COUNT(DISTINCT order_number) as total_orders
FROM [gold.fact_sales];
```
Result: 19_total_orders.png

- total number of product
```sql
SELECT 
	COUNT(product_key) as total_products
FROM [gold.dim_products];
```
Result: 20_total_products.png

- total amount of customers
```sql
SELECT COUNT(DISTINCT customer_id) AS distinct_customers_count
FROM [gold.dim_customers];
```
Result: 18484
12_total_customers.png

- total number of customers that has placed an order
```sql
SELECT 
	COUNT(DISTINCT customer_key) as total_customers_who_ordered
FROM [gold.fact_sales];
```
Result: 21_customers_who_ordered.png

## 4. Generate a report that shows all key metrics of the business

```sql
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
```
Result: 22_report.png

## 4. Magnitude Analysis 

Goal: Compare the measure values by categories. 

-- customers by country
```sql
SELECT country,
	   COUNT(customer_key) as total_customers
FROM [gold.dim_customers]
GROUP BY country
ORDER BY total_customers DESC;
```
Result: 23_customers_country.png

- gender 
```sql
SELECT gender,
	   COUNT (*) as gender_count
FROM [gold.dim_customers]
GROUP BY gender;
```
Result:
09_gender.png

- gender and marital status
```sql
SELECT gender,
       marital_status,
       COUNT(*) AS gender_count
FROM [gold.dim_customers]
GROUP BY gender, marital_status;
```
Result:
10_marital_status.png

- total products by category
```sql
SELECT
	category,
	COUNT(product_key) as total_product
FROM [gold.dim_products]
GROUP BY category
ORDER BY total_product DESC;
```
Result:24_products_category.png

- average cost in each category
```sql
SELECT
	category,
	COUNT(product_key) as total_product,
		AVG(cost) as avg_cost
FROM [gold.dim_products]
GROUP BY category
ORDER BY avg_cost DESC;
```
Result: 25_category_avg_cost.png

- total revenue for each category
```sql
SELECT
	p.category,
	SUM(s.sales_amount) as total_revenue
FROM [gold.fact_sales] s
LEFT JOIN [gold.dim_products] p
ON p.product_key = s.product_key
GROUP BY category
ORDER BY total_revenue DESC;
```
Result: 26_total_revenue.png

- total revenue by each customer
```SQL
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
```
Result:27_customers_total_revenue.png

- sold items across countries 
```sql
SELECT 
	c.country,
	SUM(s.quantity) as total_sold_items 
FROM [gold.fact_sales] s
LEFT JOIN [gold.dim_customers] c
ON c.customer_key = s.customer_key
GROUP BY c.country
ORDER BY total_sold_items  DESC;
```
Result: 28_country_sold_items.png

## 5. Ranking Analysis 

Goal: order the values of dimensions by measure to identify top and bottom performers

- top 5 products. The highest revenue
```sql 
SELECT TOP 5
	p.product_name,
	SUM(s.sales_amount) as total_revenue 
FROM [gold.fact_sales] s
LEFT JOIN [gold.dim_products] p
ON p.product_key = s.product_key
GROUP BY p.product_name
ORDER BY total_revenue DESC;
```
Result: 29_top_products.png

- bottom 5 products. The lowest revenue
```sql 
SELECT TOP 5
	p.product_name,
	SUM(s.sales_amount) as total_revenue 
FROM [gold.fact_sales] s
LEFT JOIN [gold.dim_products] p
ON p.product_key = s.product_key
GROUP BY p.product_name
ORDER BY total_revenue ASC; 
```
Result: 30_bottom_products.png

- top 5 subcategories. The highest revenue
```sql
SELECT TOP 5
	p.subcategory,
	SUM(s.sales_amount) as total_revenue 
FROM [gold.fact_sales] s
LEFT JOIN [gold.dim_products] p
ON p.product_key = s.product_key
GROUP BY p.subcategory
ORDER BY total_revenue DESC;
```
Result:31_top_subcategory.png

- bottom 5 subcategories. The highest revenue
```sql 
SELECT TOP 5
	p.subcategory,
	SUM(s.sales_amount) as total_revenue 
FROM [gold.fact_sales] s
LEFT JOIN [gold.dim_products] p
ON p.product_key = s.product_key
GROUP BY p.subcategory
ORDER BY total_revenue ASC;
```
Result: 32_bottom_subcategory.png

- product ranking
```sql
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
```
Result: 33_product_rank.png

- top 10 customers with the highest revenue
```sql
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
```
Result: 34_customers_rank.png

- top 11 customers with the fewest Nr of Orders
```sql
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
```
Result: 35_customers_low_orders.png
