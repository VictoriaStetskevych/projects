# SQL Analysis. Part 1 - Exploratory Data Analysis (EDA) Project

The project consists of two parts:<br>
Part 1: Exploratory Data Analysis (EDA)<br>
Part 2: Advanced Data Analytics<br>

This page presents Part 1: Exploratory Data Analysis (EDA).<br>
To continue to Part 2 of the analysis, please visit the following [link](https://github.com/VictoriaStetskevych/projects/tree/main/SQL/05_sql_advanced_data_analytics_baraa).

# Part 1 <br>

This project was made using Baraa Khatib Salkini's YouTube [tutorials](https://www.youtube.com/watch?v=6cJ5Ji8zSDg) that I found on Baraa's YouTube Channel ["Data with Baraa"](https://www.youtube.com/@DataWithBaraa).

## Steps and Goals of This Part of the Project<br>

<table>
   <thead>
      <th>Task</th>
      <th>Goal</th>
   </thead>
<tr>
<td>
1. Upload and Explore Data
</td>
<td>
- Basic inspection of the dataset to understand its structure and contents.
</td>
</tr>
<tr>
<td>
1. Dimensions Exploration
</td>
<td>
- Identify the unique values (or categories) in each dimension<br>
- Recognize how data might be grouped or segmented<br>
</td>
</tr>
</table>


1. Upload and Explore Data<br>
- Basic inspection of the dataset to understand its structure and contents.<br>
2. Dimensions Exploration<br>
Goal:<br>
- Identify the unique values (or categories) in each dimension<br>
- Recognize how data might be grouped or segmented<br>
3. Date Exploration<br>
Goal:<br>
- Identify the earliest and latest dates<br>
- Understand the scope and timespan of the data<br>
4. Measures Exploration<br>
Goal:<br>
- Calculate the key business metrics (Big Numbers)<br>
- Explore data at different aggregation levels (e.g., SUM, AVERAGE, COUNT)<br>
- Identify both the highest-level summaries and the lowest-level details.<br>
5. Generate a Business Report<br>
Goal:<br>
- Create a report summarizing all key metrics identified in previous steps.<br>
6. Magnitude Analysis<br>
Goal:<br>
- Compare measure values across different categories to understand their relative scale.<br>
7. Ranking Analysis<br>
Goal:<br>
- Rank dimension values by measures to identify top and bottom performers.<br>

# Process

## 1. Upload and Explore data.

In this project I was using three datasets 
- [gold.dim_customers.csv](https://github.com/VictoriaStetskevych/projects/blob/main/SQL/04_sql_exploratory_data_analysis_baraa/data/gold.dim_customers.csv)
- [gold.dim_products.csv](https://github.com/VictoriaStetskevych/projects/blob/main/SQL/04_sql_exploratory_data_analysis_baraa/data/gold.dim_products.csv), 
- [gold.fact_sales.csv](https://github.com/VictoriaStetskevych/projects/blob/main/SQL/04_sql_exploratory_data_analysis_baraa/data/gold.fact_sales.csv):

<table>
<hr>
</table>

```sql
SELECT Top 10 *
FROM [gold.dim_customers];
```
Result:<br>
![](https://raw.githubusercontent.com/VictoriaStetskevych/projects/refs/heads/main/SQL/04_sql_exploratory_data_analysis_baraa/images/01_customers.png?raw=true)

<table>
<hr>
</table>

```sql
SELECT Top 10 *
FROM [gold.dim_products];
```
Result:<br>
![](https://raw.githubusercontent.com/VictoriaStetskevych/projects/refs/heads/main/SQL/04_sql_exploratory_data_analysis_baraa/images/02_products.png?raw=true)

<table>
<hr>
</table>

```sql
SELECT Top 10 *
FROM [gold.fact_sales];
```
Result:<br>
![](https://raw.githubusercontent.com/VictoriaStetskevych/projects/refs/heads/main/SQL/04_sql_exploratory_data_analysis_baraa/images/03_sales.png?raw=true)

<table>
<hr>
</table>

Additional way to explore data tables 
```sql
SELECT *
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'gold.dim_customers';
```
Result:<br>
![](https://raw.githubusercontent.com/VictoriaStetskevych/projects/refs/heads/main/SQL/04_sql_exploratory_data_analysis_baraa/images/04_explore.png?raw=true)

<table>
<hr>
</table>

## 2. Dimensions Exploration 

Goal: Identify the unique values (or categories) in each dimensions. Recognize how data might be grouped or segmented. 

<table>
<hr>
</table>

- the countries customers come from.
```sql
SELECT DISTINCT country
FROM [gold.dim_customers];
```
Result:<br> 6 countries
![](https://raw.githubusercontent.com/VictoriaStetskevych/projects/refs/heads/main/SQL/04_sql_exploratory_data_analysis_baraa/images/05_countries.png?raw=true)

<table>
<hr>
</table>

- product categories 
```sql
SELECT DISTINCT category
FROM [gold.dim_products];
```
Result:<br> 4 categories
![](https://raw.githubusercontent.com/VictoriaStetskevych/projects/refs/heads/main/SQL/04_sql_exploratory_data_analysis_baraa/images/06_categories.png?raw=true)

<table>
<hr>
</table>

- product subcategories
```sql
SELECT DISTINCT category, subcategory
FROM [gold.dim_products];
```
Result:<br> 36 subcategories
![](https://raw.githubusercontent.com/VictoriaStetskevych/projects/refs/heads/main/SQL/04_sql_exploratory_data_analysis_baraa/images/07_subcategories.png?raw=true)

<table>
<hr>
</table>

- products
```sql
SELECT DISTINCT category, subcategory, product_name
FROM [gold.dim_products];
```
Result:<br> 295 positions 
![](https://raw.githubusercontent.com/VictoriaStetskevych/projects/refs/heads/main/SQL/04_sql_exploratory_data_analysis_baraa/images/08_products.png?raw=true)

<table>
<hr>
</table>

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
Result:<br>
![](https://raw.githubusercontent.com/VictoriaStetskevych/projects/refs/heads/main/SQL/04_sql_exploratory_data_analysis_baraa/images/14_max_min_price.png?raw=true)

<table>
<hr>
</table>

## 3. Date Exploration

Goal: to identify the earliest and the latest dates. Understand the scoop of data and the timespan.

<table>
<hr>
</table>

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
Result:<br>
![](https://raw.githubusercontent.com/VictoriaStetskevych/projects/refs/heads/main/SQL/04_sql_exploratory_data_analysis_baraa/images/15_first_last_order.png?raw=true)

<table>
<hr>
</table>

- youngest and oldest customer's age
```sql
SELECT
MIN(birthdate) as oldest_birthday,
DATEDIFF(year, MIN(birthdate), GETDATE()) as oldest_age,
MAX(birthdate) as youngest_birthday,
DATEDIFF(year, MAX(birthdate), GETDATE()) as youngest_age
FROM [gold.dim_customers];
```
Result:<br>
![](https://raw.githubusercontent.com/VictoriaStetskevych/projects/refs/heads/main/SQL/04_sql_exploratory_data_analysis_baraa/images/11_age.png?raw=true)

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

## 4. Measures Exploration

Goal: calculate the key metrics of the business (Big Numbers). Highest level of Aggregation / Lowest levels of Details. (SUM, AVERAGE, COUNT)

<table>
<hr>
</table>

- total sales 
```sql
SELECT 
	SUM(sales_amount) as total_sales
FROM [gold.fact_sales];
```
Result:<br> ![](https://raw.githubusercontent.com/VictoriaStetskevych/projects/refs/heads/main/SQL/04_sql_exploratory_data_analysis_baraa/images/16_total_sales.png?raw=true)

<table>
<hr>
</table>

- total quantity (items sold)
```sql
SELECT 
	SUM(quantity) as total_quantity
FROM [gold.fact_sales];
```
Result:<br> ![](https://raw.githubusercontent.com/VictoriaStetskevych/projects/refs/heads/main/SQL/04_sql_exploratory_data_analysis_baraa/images/17_total_quantity.png?raw=true)

<table>
<hr>
</table>

- average price
```sql
SELECT 
	AVG(price) as avg_price
FROM [gold.fact_sales];
```
Result:<br> ![](https://raw.githubusercontent.com/VictoriaStetskevych/projects/refs/heads/main/SQL/04_sql_exploratory_data_analysis_baraa/images/18_average_price.png?raw=true)

<table>
<hr>
</table>

- total number of orders
```sql
SELECT 
	COUNT(DISTINCT order_number) as total_orders
FROM [gold.fact_sales];
```
Result:<br> ![](https://raw.githubusercontent.com/VictoriaStetskevych/projects/refs/heads/main/SQL/04_sql_exploratory_data_analysis_baraa/images/19_total_orders.png?raw=true)

<table>
<hr>
</table>

- total number of product
```sql
SELECT 
	COUNT(product_key) as total_products
FROM [gold.dim_products];
```
Result:<br> ![](https://raw.githubusercontent.com/VictoriaStetskevych/projects/refs/heads/main/SQL/04_sql_exploratory_data_analysis_baraa/images/20_total_products.png?raw=true)

<table>
<hr>
</table>

- total amount of customers
```sql
SELECT COUNT(DISTINCT customer_id) AS distinct_customers_count
FROM [gold.dim_customers];
```
Result: 18484<br>
![](https://raw.githubusercontent.com/VictoriaStetskevych/projects/refs/heads/main/SQL/04_sql_exploratory_data_analysis_baraa/images/12_total_customers.png?raw=true)

<table>
<hr>
</table>

- total number of customers that has placed an order
```sql
SELECT 
	COUNT(DISTINCT customer_key) as total_customers_who_ordered
FROM [gold.fact_sales];
```
Result:<br> ![](https://raw.githubusercontent.com/VictoriaStetskevych/projects/refs/heads/main/SQL/04_sql_exploratory_data_analysis_baraa/images/21_customers_who_ordered.png?raw=true)

<table>
<hr>
</table>

## 5. Generate a report that shows all key metrics of the business

<table>
<hr>
</table>

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
Result:<br> ![](https://raw.githubusercontent.com/VictoriaStetskevych/projects/refs/heads/main/SQL/04_sql_exploratory_data_analysis_baraa/images/22_report.png?raw=true)

<table>
<hr>
</table>

## 6. Magnitude Analysis 

Goal: Compare the measure values by categories. 

<table>
<hr>
</table>

- customers by country
```sql
SELECT country,
	   COUNT(customer_key) as total_customers
FROM [gold.dim_customers]
GROUP BY country
ORDER BY total_customers DESC;
```
Result:<br> ![](https://raw.githubusercontent.com/VictoriaStetskevych/projects/refs/heads/main/SQL/04_sql_exploratory_data_analysis_baraa/images/23_customers_country.png?raw=true)

<table>
<hr>
</table>

- gender 
```sql
SELECT gender,
	   COUNT (*) as gender_count
FROM [gold.dim_customers]
GROUP BY gender;
```
Result:<br> 
![](https://raw.githubusercontent.com/VictoriaStetskevych/projects/refs/heads/main/SQL/04_sql_exploratory_data_analysis_baraa/images/09_gender.png?raw=true)

<table>
<hr>
</table>

- gender and marital status
```sql
SELECT gender,
       marital_status,
       COUNT(*) AS gender_count
FROM [gold.dim_customers]
GROUP BY gender, marital_status;
```
Result:<br>
![](https://raw.githubusercontent.com/VictoriaStetskevych/projects/refs/heads/main/SQL/04_sql_exploratory_data_analysis_baraa/images/10_marital_status.png?raw=true)

<table>
<hr>
</table>

- total products by category
```sql
SELECT
	category,
	COUNT(product_key) as total_product
FROM [gold.dim_products]
GROUP BY category
ORDER BY total_product DESC;
```
Result:<br> ![](https://raw.githubusercontent.com/VictoriaStetskevych/projects/refs/heads/main/SQL/04_sql_exploratory_data_analysis_baraa/images/24_products_category.png?raw=true)

<table>
<hr>
</table>

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
Result:<br> ![](https://raw.githubusercontent.com/VictoriaStetskevych/projects/refs/heads/main/SQL/04_sql_exploratory_data_analysis_baraa/images/25_category_avg_cost.png?raw=true)

<table>
<hr>
</table>

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
Result:<br> ![](https://raw.githubusercontent.com/VictoriaStetskevych/projects/refs/heads/main/SQL/04_sql_exploratory_data_analysis_baraa/images/26_total_revenue.png?raw=true)

<table>
<hr>
</table>

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
Result:<br> ![](https://raw.githubusercontent.com/VictoriaStetskevych/projects/refs/heads/main/SQL/04_sql_exploratory_data_analysis_baraa/images/27_customers_total_revenue.png?raw=true)

<table>
<hr>
</table>

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
Result:<br> ![](https://raw.githubusercontent.com/VictoriaStetskevych/projects/refs/heads/main/SQL/04_sql_exploratory_data_analysis_baraa/images/28_country_sold_items.png?raw=true)

<table>
<hr>
</table>

## 7. Ranking Analysis 

Goal: order the values of dimensions by measure to identify top and bottom performers

<table>
<hr>
</table>

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
Result:<br> ![](https://raw.githubusercontent.com/VictoriaStetskevych/projects/refs/heads/main/SQL/04_sql_exploratory_data_analysis_baraa/images/29_top_products.png?raw=true)

<table>
<hr>
</table>

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
Result:<br> ![](https://raw.githubusercontent.com/VictoriaStetskevych/projects/refs/heads/main/SQL/04_sql_exploratory_data_analysis_baraa/images/30_bottom_products.png?raw=true)

<table>
<hr>
</table>

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
Result:<br> ![](https://raw.githubusercontent.com/VictoriaStetskevych/projects/refs/heads/main/SQL/04_sql_exploratory_data_analysis_baraa/images/31_top_subcategory.png?raw=true)

<table>
<hr>
</table>

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
Result:<br> ![](https://raw.githubusercontent.com/VictoriaStetskevych/projects/refs/heads/main/SQL/04_sql_exploratory_data_analysis_baraa/images/32_bottom_subcategory.png?raw=true)

<table>
<hr>
</table>

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
Result:<br> ![](https://raw.githubusercontent.com/VictoriaStetskevych/projects/refs/heads/main/SQL/04_sql_exploratory_data_analysis_baraa/images/33_product_rank.png?raw=true)

<table>
<hr>
</table>

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
Result:<br> ![](https://raw.githubusercontent.com/VictoriaStetskevych/projects/refs/heads/main/SQL/04_sql_exploratory_data_analysis_baraa/images/34_customers_rank.png?raw=true)

<table>
<hr>
</table>

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
Result:<br> ![](https://raw.githubusercontent.com/VictoriaStetskevych/projects/refs/heads/main/SQL/04_sql_exploratory_data_analysis_baraa/images/35_customers_low_orders.png?raw=true)

<table>
<hr>
</table>

To continue with the Part 2 of this analysis, please visit the following [link](https://github.com/VictoriaStetskevych/projects/tree/main/SQL/05_sql_advanced_data_analytics_baraa).

