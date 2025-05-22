USE DataWarehouseAnalytics;

SELECT Top 10 *
FROM [gold.dim_customers];

SELECT Top 10 *
FROM [gold.dim_products];

SELECT Top 10 *
FROM [gold.fact_sales];

--------------------------------------------------------------------- Report Products ------------------------------------------------------------------------------------------------------------

CREATE VIEW report_product AS 
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

SELECT *
FROM report_product;