# SQL Analysis. Part 2 - Advanced Data Analytics

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



In Progress!