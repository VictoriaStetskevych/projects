# Analyzing data in Microsoft SQL Server.<br>
# Building Dashboards in Power BI.<br>
# Feedback.<br>

<u>Business problem</u><br>
Online retail business is facing reduced customers engagement and conversion rates despite launching several new online marketing campaign.<br>
Marketing expenses have gone up but the return on investment isn't meeting company's expectations.
For the past few months company noticed a drop in customer engagement and satisfaction, and gathered a significant amount of customer's reviews and social media comments that highlighted various issues and sentiments. <br>

<u>Goal:</u><br>
- conduct a detail analysis<br>
- identify areas for improvement in the marketing strategy<br>
- identify factors impacting the conversion rate and provide recommendation to improve it<br>
- Determine which types of content drive the highest engagement <br>
- Understand common themes in customer reviews and provide actionable insights

Key Performance Indicators (KPI's)<br>
- Conversion Rate: percentage of website visitors who make purchase <br>
- Customer Engagement Rate: Level of interaction with marketing content (clicks, likes, comments)<br>
- Average Order Value (AOV) - average amount spent by a customer per transaction <br>
- Customer feedback score - average rating from customer reviews. <br>

# Process

In a current project I was using database backup file which I restored in the Microsoft SQL Server.<br>

Current database has next tables:
- customer_journey - customers' movements through the website.
- customer_reviews - customers' feedback to identify common themes and sentiments
- customers - information about customers
- engagement_data - engagement with different types of content 
- geography - additional geographic information about customers
- products - additional information about product

1. I started my analysis with a 'products' table
```sql
SELECT *
FROM dbo.products
```
Result: we have a table with 1 category 'Sport', 20 different products, different prices from 26.21 to 485.32

01_product

max/min prises I got using following queries

```sql
SELECT MIN(Price) as min_price
FROM products;

SELECT MAX(Price)as max_price
FROM products;
``` 

02_min_max_price

2. Price category column

```sql 
SELECT 
    ProductID,
    ProductName,
    Price
CASE 
    WHEN Price < 50 THEN 'Low'
    WHEN PRICE BETWEEN 50 AND 200 'Medium'
    ELSE 'High'
END AS Price Category 
FROM products;
```
03_price_category

3. Customers table 

```sql
SELECT * 
FROM customers;
```
Result:
In this table I got data with CustomerID, CustomerName, Email, Gender, Age, GeographyID

04_customers

To observe a little this table I was using the following queries 

- to count male/female
```sql
SELECT 
    Gender,
    COUNT(*) AS GenderCount
FROM customers
GROUP BY Gender;
```
05_gender

to analyze age range 
```sql
SELECT 
    CustomerID,
    CustomerName,
    Email,
	Gender,
	Age,
	GeographyID,
CASE 
    WHEN Age <= 29 THEN 'Young'
    WHEN Age BETWEEN 30 AND 55 THEN 'Middle'
    ELSE 'Old'
END AS [Age Category]
FROM dbo.customers;
```
Result

06_age_category

I also noticed a column 'DemographyID' with different numbers. 
The next step was to join 'customer' and 'geography' tables to add customers' geography data, such as country, and city.

4. geography table 

```sql
SELECT * 
FROM geography;
```
Result
07_geography

My next step was to join two tables ('customers' and 'geography') to get a full data about customers

```sql
SELECT
    c.CustomerID,
    c.CustomerName,
    c.Email,
    c.Gender,
    c.Age,
    g.Country,
    g.City
FROM
    customers as c 
LEFT JOIN
    geography as g
ON c.GeographyID = g.GeographyID;
```
Result
08_join_customers_and_geography

5. The next step was observing the customer_reviews table

```sql
SELECT *
FROM customer_reviews;
```
Result:
09_customer_reviews

So, for cleaning process I wanted just to replace '  ' (double space) with ' '(single space) in a 'ReviewText' column. It will help to analyze this data in the future.
To do that I was using the following query:

```sql
SELECT
    ReviewID,
    CustomerID,
    ProductID,
    ReviewDate,
    Rating
    REPLACE (ReviewText, '  ', ' ') AS ReviewText
FROM customer_reviews;
```
Result
10_customer_reviews_fixed

6. 'engagement_data' table

SELECT *
FROM engagement_data;

Result
11_engagement_data

For this I table I cleaned data to have standardized look and I added comments to my queries to show what was the goal for each part of query.

```sql
SELECT
    EngagementID,
    ContentID,
    CampaignID,
    -- Replace 'Socialmedia' with 'Social Media', UPPER function to standardize text data in the column
    UPPER(REPLACE(ContentType, 'Socialmedia', 'Social Media')) AS ContentType,
    -- Extract the View data from the 'ViewsClicksCombined'
    LEFT(ViewsClicksCombined, CHARINDEX('-', ViewsClicksCombined) - 1) AS Views, 
    -- Extract the Clicks data from the 'ViewClicksCombined'
    RIGHT(ViewsClicksCombined, LEN(ViewsClicksCombined) - CHARINDEX('-', ViewsClicksCombined)) AS Clicks,
    Likes,
    -- Convert the EngagementDate to the dd-mm-yyyy format
    FORMAT(CONVERT(DATE, EngagementDate),'dd-MMM-yyyy') as EngagementDate
FROM 
    engagement_data
    -- Filter ContentType is excluded as it's not relevant for this analysis
WHERE 
    ContentType != 'Newsletter';
```
image 10

7. 'customer_journey' table. Looking for duplicates.

```sql
WITH DuplicateRecords AS (
	SELECT 
		JourneyID,
		CustomerID, 
		ProductID,
		-- Convert the VisitDate to the dd-mm-yyyy format
		FORMAT(CONVERT(DATE, VisitDate),'dd-MMM-yyyy') as VisitDate,
		Stage,
		Action,
		Duration,
		-- ROW_NUMBER - to assign a row number to each record with the partition defined below 
		ROW_NUMBER() OVER (
			-- PARTITION BY - to group the rows based on specific columns
			PARTITION BY
				CustomerID, 
				ProductID,
				VisitDate,
				Stage,
				Action
			--- ORDER BY - to order the rows within each partition 
			ORDER BY JourneyID
		) AS row_num
	FROM
		customer_journey
)
-- Select all records from the CTE where row_num > 1
SELECT *
FROM DuplicateRecords
WHERE row_num > 1
ORDER BY JourneyID;
```

Result, as you can see, there 79 duplicate rows in this table
image 11


The next issue with this table was 'NULL' values in a 'Duration' column.
So, with next query I 
```sql

-- to fix NULLS in Duration column and duplicates
SELECT
    JourneyID,
    CustomerID,
    ProductID,
    VisitDate,
    Stage,
    Action,
    -- COALESCE - to replace missing durations (NULLs) with the avarage duration
    COALESCE(Duration, avg_duration) AS Duration 
FROM
--Subquery - to process and clean data, to assigns row numbers to help identify and remove duplicates
    (
        SELECT
            JourneyID,
            CustomerID,
            ProductID,
            -- Convert the VisitDate to the dd-mm-yyyy format
			FORMAT(CONVERT(DATE, VisitDate),'dd-MMM-yyyy') as VisitDate,
            UPPER(Stage) AS Stage,
            Action,
			Duration,
			-- calculate avarage duration. PARTITION BY - to ensures that the average is specific to each date
            AVG(Duration) OVER (PARTITION BY visitDate) AS avg_duration,
            -- Assigns a unique row number to each record within groups
			ROW_NUMBER() OVER (
                PARTITION BY 
                    CustomerID,
                    ProductID,
                    VisitDate,
                    UPPER(Stage),
                    Action
                ORDER BY JourneyID
            ) AS row_num
        FROM 
            customer_journey
    ) AS subquery
WHERE row_num = 1;
```

Result:
image12


Next part will be analizing 'customer_reviews' table in Python

Dashboards in Power BI

2024 year analysis:
Decreased Conversion Rate: The conversion rate demonstrate strong rebound in December, reaching 10.3% despite a drop to 5% in October.
The lowest conversion rate was in May: 4.3%
The highest conversion rate was in January: 19.6%
Top 5 products: Ski Boots, Kayak, Surfboard, Volleyball, Golf CLubs
Noticed consistently low customer engagement during the year
Customer ratings: The majority reviews are in the higher rating, that indicating overall positive feedback.
Sentiment Analysis: positive sentiments dominate , reflecting generally satisfied customer rate.
Negative sentiments are present with a smaller number of neutral and mixed sentiments, suggesting some areas for improvement.

Actions
Conversion Rate
Target-High-Performing Product Category: focus marketing efforts on products with demonstrated high conversion rate, such as Kayak, Ski Boots, and Baseball Gloves.
Implement seasonal promotions or personalized campaigns during peak months to capitalize on these trends.

Customer Engagement
More engaging content format, interactive videos, user-generated content 

Customer feedback score
Mixed and negative feedbacks
Implement a feedback loop where mixed and negative reviews are analyzed to identify common issue .
Consider following up with dissatisfied customers to resolve issues and encourage to re-rate, aiming to move the average rating closer to the 4.0 and higher target. 