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


In Progress!