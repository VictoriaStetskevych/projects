# SQL Analysis. Part 2 - Advanced Data Analytics

IN PROGRESS!

The project consists of two parts:<br>
Part 1: Exploratory Data Analysis (EDA)<br>
Part 2: Advanced Data Analytics<br>

This page presents Part 2 - Advanced Data Analytics.<br>
To return to Part 1 of the analysis, please visit the following [link](https://github.com/VictoriaStetskevych/projects/tree/main/SQL/04_sql_exploratory_data_analysis_baraa).

# Part 2 <br>

This project was made using Baraa Khatib Salkini's YouTube [tutorials](https://www.youtube.com/watch?v=2jGhQpbzHes&t=113s) that I found on Baraa's YouTube Channel ["Data with Baraa"](https://www.youtube.com/@DataWithBaraa).

## Steps and Goals of Part 2 of the Project<br>

<table>
   <thead>
      <th>Step</th>
      <th>Goal</th>
   </thead>
<tr>
<td>
1. Change-Over-Time
</td>
<td>
- Analyze how a measure evolves over time.<br>
- Track trends and identify seasonality in the data.<br>
(by Year, by Month)<br>
</td>
</tr>
</table>

# Process

## 1. Change-Over-Time

In [Part 1](https://github.com/VictoriaStetskevych/projects/tree/main/SQL/04_sql_exploratory_data_analysis_baraa), I discovered that the dataset contains information from December 29, 2010 to January 28, 2014.
![](https://raw.githubusercontent.com/VictoriaStetskevych/projects/refs/heads/main/SQL/04_sql_exploratory_data_analysis_baraa/images/15_first_last_order.png?raw=true)

- Sales Performance Over Time

<table>
<hr>
</table>

- by day 
```sql
SELECT
	order_date,
	SUM(sales_amount) as total_amount
FROM [gold.fact_sales]
WHERE order_date is not NULL
GROUP BY order_date
ORDER BY order_date;
```
Result: <br>
![](https://github.com/VictoriaStetskevych/projects/blob/main/SQL/05_sql_advanced_data_analytics_baraa/images/01_sales_daily.png?raw=true)

<table>
<hr>
</table>

- by year
```sql
SELECT
	YEAR(order_date) as order_year,
	SUM(sales_amount) as total_amount
FROM [gold.fact_sales]
WHERE order_date is not NULL
GROUP BY YEAR(order_date) 
ORDER BY YEAR(order_date);
```
Result: <br>
![](https://github.com/VictoriaStetskevych/projects/blob/main/SQL/05_sql_advanced_data_analytics_baraa/images/02_sales_yearly.png?raw=true)

<table>
<hr>
</table>

-- by year, with customers and quantity data
```sql
SELECT
	YEAR(order_date) as order_year,
	SUM(sales_amount) as total_amount,
	COUNT(DISTINCT customer_key) as total_customers,
	SUM(quantity) as total_quantity
FROM [gold.fact_sales]
WHERE order_date is not NULL
GROUP BY YEAR(order_date) 
ORDER BY YEAR(order_date);
```
Result: <br>
![](https://github.com/VictoriaStetskevych/projects/blob/main/SQL/05_sql_advanced_data_analytics_baraa/images/03_sales_yearly_customers_quant.png?raw=true)

<table>
<hr>
</table>

- by month, with customers and quantity data
```sql
SELECT
	MONTH(order_date) as order_year,
	SUM(sales_amount) as total_amount,
	COUNT(DISTINCT customer_key) as total_customers,
	SUM(quantity) as total_quantity
FROM [gold.fact_sales]
WHERE order_date is not NULL
GROUP BY MONTH(order_date) 
ORDER BY MONTH(order_date);
```
Result: <br>
![](https://github.com/VictoriaStetskevych/projects/blob/main/SQL/05_sql_advanced_data_analytics_baraa/images/04_sales_monthly_customers_quant.png?raw=true)

<table>
<hr>
</table>

- by year and month, with customers and quantity data
```SQL
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
```
Result: <br>
![](https://github.com/VictoriaStetskevych/projects/blob/main/SQL/05_sql_advanced_data_analytics_baraa/images/05_year_month_sales.png?raw=true)

<table>
<hr>
</table>

- order_date together year_month
```sql
SELECT 
	DATETRUNC(month, order_date) as order_date,
	SUM(sales_amount) as total_sales,
	COUNT(DISTINCT customer_key) as total_customers,
	SUM(quantity) as total_quantity
FROM [gold.fact_sales]
WHERE order_date is not NULL
GROUP BY DATETRUNC(month, order_date)
ORDER BY DATETRUNC(month, order_date);
```
Result: <br>
![](https://github.com/VictoriaStetskevych/projects/blob/main/SQL/05_sql_advanced_data_analytics_baraa/images/06_together_year_month_sales.png?raw=true)

<table>
<hr>
</table>

## 2. Cumulative Analysis

Goal: aggregate the data progressively over time to understand whether the business is growing or declining

<table>
<hr>
</table>

- calculate the total sales per month and the running total of sales over time 

```sql
SELECT 
	DATETRUNC(month, order_date) as order_date,
	SUM(sales_amount) as total_sales
FROM [gold.fact_sales]
WHERE order_date is not NULL
GROUP BY DATETRUNC(month, order_date)
ORDER BY DATETRUNC(month, order_date);
```
Result: <br>
![](https://github.com/VictoriaStetskevych/projects/blob/main/SQL/05_sql_advanced_data_analytics_baraa/images/07_sales_per_month.png?raw=true)

<table>
<hr>
</table>

- with running totals
```sql
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
```
Result: <br>
![](https://github.com/VictoriaStetskevych/projects/blob/main/SQL/05_sql_advanced_data_analytics_baraa/images/08_running_totals.png?raw=true)

<table>
<hr>
</table>

- running totals by year  / month
```sql
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
```
Result: <br>
![](https://github.com/VictoriaStetskevych/projects/blob/main/SQL/05_sql_advanced_data_analytics_baraa/images/09_running_totals_by_year_month.png?raw=true)

<table>
<hr>
</table>

- running total sales accumulated by year
```sql
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
```
Result: <br>
![](https://github.com/VictoriaStetskevych/projects/blob/main/SQL/05_sql_advanced_data_analytics_baraa/images/10_running_total_sales_by_year.png?raw=true)

<table>
<hr>
</table>

- moving average of the price
```sql
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
```
Result: <br>
![](https://github.com/VictoriaStetskevych/projects/blob/main/SQL/05_sql_advanced_data_analytics_baraa/images/11_moving_avg_price.png?raw=true)

<table>
<hr>
</table>

## 3. Performance Analysis

Goal: 
- compare the current value to a target value to measure success and compare performance
- analyze the yearly performance of products by comparing each product sales to both its average sales and the previous year's sales 

- yearly performance by product
```sql
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
```
Result: <br>
![](https://github.com/VictoriaStetskevych/projects/blob/main/SQL/05_sql_advanced_data_analytics_baraa/images/12_yearly_performance_by_product.png?raw=true)

<table>
<hr>
</table>

- yearly performance by product, compared to average sales
```sql
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
```
Result: <br>
![](https://github.com/VictoriaStetskevych/projects/blob/main/SQL/05_sql_advanced_data_analytics_baraa/images/13_product_sales_performance.png?raw=true)

<table>
<hr>
</table>

- yearly performance by product, compared to previous year sales
```sql
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
```
Result: <br>
![](https://github.com/VictoriaStetskevych/projects/blob/main/SQL/05_sql_advanced_data_analytics_baraa/images/14_product_sales_performance_vs_py.png?raw=true)

<table>
<hr>
</table>

## 4. Part-to-Whole, % (Proportional Analysis)

Goal: analyze how an individual part is performing compared to overall, to understand which category has the greatest impact on the business 

- total sales by each category
```sql
SELECT
	p.category,
	SUM(s.sales_amount) as total_sales
FROM [gold.fact_sales] s
LEFT JOIN [gold.dim_products] p
ON p.product_key = s.product_key
GROUP BY p.category
ORDER BY total_sales DESC;
```
Result: <br>
![](https://github.com/VictoriaStetskevych/projects/blob/main/SQL/05_sql_advanced_data_analytics_baraa/images/15_sales_by_each_category.png?raw=true)

<table>
<hr>
</table>

- which categories contribute the most to overall sales
```sql
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
```
Result: <br>
![](https://github.com/VictoriaStetskevych/projects/blob/main/SQL/05_sql_advanced_data_analytics_baraa/images/16_categories_percentage.png?raw=true)

<table>
<hr>
</table>

## 5. Data Segmentation 

Goal: group data based on a specific range to understand the correlation between two measures 

- segment products into cost range
```sql
SELECT
	product_key,
	product_name, 
	cost,
	CASE WHEN cost < 100 THEN 'Below 100'
	WHEN cost BETWEEN 100 and 500 THEN '100-500'
	WHEN cost BETWEEN 500 and 1000 THEN '500-1000'
	ELSE 'Above 1000'
	END cost_range
FROM [gold.dim_products];;
```
Result: <br>
![](https://github.com/VictoriaStetskevych/projects/blob/main/SQL/05_sql_advanced_data_analytics_baraa/images/17_cost_range.png?raw=true)

<table>
<hr>
</table>

- count how many products fall into each segment
```sql
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
```
Result: <br>
![](https://github.com/VictoriaStetskevych/projects/blob/main/SQL/05_sql_advanced_data_analytics_baraa/images/18_cost_range_total.png?raw=true)

<table>
<hr>
</table>

- age and age category
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
Result:<br>
![](https://raw.githubusercontent.com/VictoriaStetskevych/projects/refs/heads/main/SQL/04_sql_exploratory_data_analysis_baraa/images/13_age_category.png?raw=true)

<table>
<hr>
</table>

- count age categories
```sql
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
```
Result:<br>
![](https://github.com/VictoriaStetskevych/projects/blob/main/SQL/05_sql_advanced_data_analytics_baraa/images/19_age_categories_total.png?raw=true)

<table>
<hr>
</table>

- count customers, items bought by categories, total sales, % sales by each age category
```sql
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
```
Result:<br>
![](https://github.com/VictoriaStetskevych/projects/blob/main/SQL/05_sql_advanced_data_analytics_baraa/images/20_age_categories_bought.png?raw=true)

<table>
<hr>
</table>

- group customers into three segment based on their spending behavior:<br>
	- VIP: at least 12 months of history and spending more than 5000 Euro
	- Regular: at least 12 months of history and spending more than 5000 Euro or less
	- New: lefespan less than 12 months
```sql
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
```
Result:<br>
![](https://github.com/VictoriaStetskevych/projects/blob/main/SQL/05_sql_advanced_data_analytics_baraa/images/21_customers_lifespan_categories.png?raw=true)
![](https://github.com/VictoriaStetskevych/projects/blob/main/SQL/05_sql_advanced_data_analytics_baraa/images/21_customers_lifespan_categories.png?raw=true)

<table>
<hr>
</table>

- total number customers by each group
```sql
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
```
Result:<br>
![](https://github.com/VictoriaStetskevych/projects/blob/main/SQL/05_sql_advanced_data_analytics_baraa/images/23_customers_lifespan_categories_total.png?raw=true)

<table>
<hr>
</table>

- % -- total number customers by each group
```sql
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
```
Result:<br>
![](https://github.com/VictoriaStetskevych/projects/blob/main/SQL/05_sql_advanced_data_analytics_baraa/images/24_customers_lifespan_categories_percent.png?raw=true)

<table>
<hr>
</table>

## 6. Customer Report

Purpose:
- This report consolidates key customer metrics and behavior

Highlights:
1. Gather essential fields, such as names, ages, and transaction details
2. Segment customers into categories (VIP, Regular, New) and age groups.
3. Aggregate customer level metrics: 
- total orders
- total sales
- total quantity purchased
- total products
- lifespan(months)
4. Calculate valuable KPIs:
- recency (months since last order)
- average order value
- average monthly spending 

<table>
<hr>
</table>

```sql
CREATE VIEW report AS 
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
```
Result:<br>
![](https://github.com/VictoriaStetskevych/projects/blob/main/SQL/05_sql_advanced_data_analytics_baraa/images/26_report_customers.png?raw=true)


## 7. Product Report

Purpose: consolidate key product metrics and behaviors

Highlights:
1. Gather essential fields as product_name, category, subcategory, and cost
2. Segment products by revenue to identify high-performers, mid-range, or low-performers
3. Aggregate product-level metrics:
	- total orders,
	- total sales,
	- total quantity sold,
	- total customers (unique),
	- lifespan (in month)
4. Aggregate valuable KPIs:
	- recency (months since last order)
	- average order value
	- average monthly spending 

```sql
-- Base query: core columns from [gold.fact_sales] and [gold.dim_products]
WITH q1 AS (
    SELECT
        s.order_number,
        s.order_date,
        s.customer_key,
        s.sales_amount,
        s.quantity,
        p.product_name,
        p.product_key,
        p.category,
        p.subcategory,
        p.cost
    FROM [gold.fact_sales] s
    LEFT JOIN [gold.dim_products] p
        ON p.product_key = s.product_key
    WHERE s.order_date IS NOT NULL
),
-- Aggregation product-level metrics (total sales, orders, quantity, lifespan)
q2 AS (
    SELECT 
        COUNT(DISTINCT order_number) AS total_orders,
        DATEDIFF(MONTH, MIN(order_date), MAX(order_date)) AS lifespan_months,
        MAX(order_date) AS last_sale_date,
        COUNT(DISTINCT customer_key) AS total_customers,
        SUM(sales_amount) AS total_sales,
        SUM(quantity) AS total_quantity,	
        product_name,
        product_key,
        category,
        subcategory,
        cost,
        ROUND(AVG(CAST(sales_amount AS FLOAT) / NULLIF(quantity, 0)), 1) AS avg_selling_price
    FROM q1
    GROUP BY
        product_name,
        product_key,
        category,
        subcategory,
        cost
)
-- Final Query
SELECT 
	product_name,
    product_key,
    category,
    subcategory,
    cost,
	last_sale_date,
	-- recency (months since last order)
	DATEDIFF(month, last_sale_date, GETDATE()) as recency ,
	CASE 
		WHEN total_sales > 50000 THEN 'High-Performer'
		WHEN total_sales >= 10000 THEN 'Mid-Performer'
		ELSE 'Low-Performer'
	END product_segment,
	lifespan_months,
	total_customers,
	total_sales,
	total_quantity,
	total_orders,
	avg_selling_price,
	-- average order revenue (AOR)
	CASE WHEN total_orders = 0 THEN 0 
		 ELSE total_sales/total_orders 
	END AS avg_order_value,
	-- average monthly revenue 
	CASE WHEN lifespan_months = 0 THEN 0
		 ELSE total_sales/lifespan_months
	END AS avg_monthly_revenue
FROM q2;
```

Result:<br>
![](https://github.com/VictoriaStetskevych/projects/blob/main/SQL/05_sql_advanced_data_analytics_baraa/images/27_report_product.png?raw=true)

<table>
<hr>
</table>


In Progress!