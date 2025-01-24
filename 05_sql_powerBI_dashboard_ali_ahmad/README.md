# Analyzing data in Microsoft SQL Server. Building Dashboards in Power BI.<br>

<u>Business problem</u><br>
Online retail business is facing reduced customers engagement and conversion rates despite launching several new online marketing campaign.<br>
Marketing expenses have gone up but the return on investment isn't meeting company's expectations.
For the past few months company noticed a drop in customer engagement and satisfaction, and gathered a significant amount of customers' reviews and social media comments that highlighted various issues and sentiments. <br>

<u>Goal is to conduct a detail analysis to:</u>
- identify factors impacting the conversion rate<br>
- Determine which types of content drive the highest engagement <br>
- Understand common themes in customer reviews<br>

Key Performance Indicators (KPI's)<br>
- Conversion Rate: percentage of website visitors who make purchase <br>
- Customer Engagement Rate: Level of interaction with marketing content (clicks, likes, comments)<br>
- Average Order Value (AOV) - average amount spent by a customer per transaction <br>
- Customer feedback score - average rating from customer reviews. <br>

# Process

In a current project I was using [database backup file](https://github.com/VictoriaStetskevych/projects/blob/main/05_sql_powerBI_dashboard_ali_ahmad/PortfolioProject_MarketingAnalytics.bak) which I restored in the Microsoft SQL Server.<br>

> [!NOTE]
> To restore a database in Microsoft SQL Server I had to follow next steps:<br>
> - Databases > Right Click > Restore Database<br>
> - Choose Device > Select Backup devices > Add<br>
> - Choose a file<br>
Backup file had to be in the location<br>
C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\Backup<br>
> - OK<br>

Current database has next tables:<br>
- customer_journey - customers' movements through the website<br>
- customer_reviews - customers' feedback to identify common themes and sentiments<br>
- customers - information about customers<br>
- engagement_data - engagement with different types of content <br>
- geography - additional geographic information about customers<br>
- products - additional information about product<br>


## 1. 'products' table<br>

I started my analysis with a 'products' table.<br>

To preview the data in the 'product' table and examine the variety of product categories I used the following queries:<br>

```sql
SELECT *
FROM products;

SELECT DISTINCT(Category)
FROM products;
```
Result: <br>
- 1 category - 'Sport', 
- 20 different products, 
- different prices from 26.21 to 485.32<br>

![](https://github.com/VictoriaStetskevych/projects/blob/main/05_sql_powerBI_dashboard_ali_ahmad/images/01_product.png?raw=true)
![](https://github.com/VictoriaStetskevych/projects/blob/main/05_sql_powerBI_dashboard_ali_ahmad/images/12_product_category.png?raw=true)

min/max prises I got using following queries

```sql
SELECT MIN(Price) as min_price
FROM products;

SELECT MAX(Price)as max_price
FROM products;
``` 
![](https://github.com/VictoriaStetskevych/projects/blob/main/05_sql_powerBI_dashboard_ali_ahmad/images/02_min_max_price.png?raw=true)


## 2. 'products' table. 'Price Category' column

The database contains products with varying prices, so I categorized them into three price ranges: <br>
- 'Low' - products priced at $50 or below<br>
- Medium - products priced between $50 and $200<br>
- High - products priced above $200<br>

I used the following query to do that:
```sql 
SELECT 
    ProductID,
    ProductName,
    Price
CASE 
    WHEN Price <= 50 THEN 'Low'
    WHEN PRICE BETWEEN 50 AND 200 'Medium'
    ELSE 'High'
END AS Price Category 
FROM products;
```
Result:<br>
![](https://github.com/VictoriaStetskevych/projects/blob/main/05_sql_powerBI_dashboard_ali_ahmad/images/03_price_category.png?raw=true)

## 3. 'customers' table 

To preview the data in the 'customers' table:
```sql
SELECT * 
FROM customers;
```
Result:
![](https://github.com/VictoriaStetskevych/projects/blob/main/05_sql_powerBI_dashboard_ali_ahmad/images/04_customers.png?raw=true)

To perform a basic analysis of this table I used the following queries <br>

- to count male/female<br>

```sql
SELECT 
    Gender,
    COUNT(*) AS GenderCount
FROM customers
GROUP BY Gender;
```
Result:<br>
![](https://github.com/VictoriaStetskevych/projects/blob/main/05_sql_powerBI_dashboard_ali_ahmad/images/05_gender.png?raw=true)

To categorize by age range, I used the following groups:<br>
- Young - Age below 29<br>
- Middle - Age between 30 and 55<br>
- Old - Age above 55<br>

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
Result:<br>
![](https://github.com/VictoriaStetskevych/projects/blob/main/05_sql_powerBI_dashboard_ali_ahmad/images/06_age_category.png?raw=true)

I also observed a column called 'DemographyID' with various values. The next step was to join the 'customer' and 'geography' tables to add geography data for customers, such as country and city.<br>

## 4. 'geography' table 

To preview the data in the 'geography' table:
```sql
SELECT * 
FROM geography;
```
Result:
![](https://github.com/VictoriaStetskevych/projects/blob/main/05_sql_powerBI_dashboard_ali_ahmad/images/07_geography.png?raw=true)

Joined the 'customers' and 'geography' tables to obtain complete data about the customers with the following query:

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
Result:
![](https://github.com/VictoriaStetskevych/projects/blob/main/05_sql_powerBI_dashboard_ali_ahmad/images/08_join_customers_and_geography.png?raw=true)

## 5. 'customer_reviews' table

To preview the data in the 'customer_reviews' table:
```sql
SELECT *
FROM customer_reviews;
```
Result:
![](https://github.com/VictoriaStetskevych/projects/blob/main/05_sql_powerBI_dashboard_ali_ahmad/images/09_customer_reviews.png?raw=true)

As part of the data cleaning process, I aimed to replace double spaces (' ') with single spaces (' ') in the 'ReviewText' column. This step helps improve the data for future analysis.
To achieve this, I used the following query:

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
![](https://github.com/VictoriaStetskevych/projects/blob/main/05_sql_powerBI_dashboard_ali_ahmad/images/10_customer_reviews_fixed.png?raw=true)

## 6. 'engagement_data' table

To preview the data in the 'engagement_data' table:
```sql
SELECT *
FROM engagement_data;
```
Result:
![](https://github.com/VictoriaStetskevych/projects/blob/main/05_sql_powerBI_dashboard_ali_ahmad/images/11_engagement_data.png?raw=true)

I cleaned the data in this table to ensure a standardized format and added comments to my queries to clarify the purpose of each part.

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
![](https://github.com/VictoriaStetskevych/projects/blob/main/05_sql_powerBI_dashboard_ali_ahmad/images/13_engagement_data_fixed.png?raw=true)

## 7. 'customer_journey' table. Looking for duplicates.

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

Result: there are 79 duplicate rows in this table
![](https://github.com/VictoriaStetskevych/projects/blob/main/05_sql_powerBI_dashboard_ali_ahmad/images/14_duplicates.png?raw=true)


The final task in the analysis was to address 'NULL' values and remove all duplicates identified in the previous query. I accomplished this using the following query and included additional comments to explain the purpose of each part.

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
![](https://github.com/VictoriaStetskevych/projects/blob/main/05_sql_powerBI_dashboard_ali_ahmad/images/15_null_duplicates_fixed.png?raw=true)

## 8. Analyzing 'customer_reviews' table in Python

In a project presented by Ali Ahmad, the next step involved data processing with Python. However, I chose to skip this step to focus on SQL and Power BI.<br>
This is the Python code Ali was using for this part of the project. <br>

```py
# pip install pandas nltk pyodbc sqlalchemy

import pandas as pd
import pyodbc
import nltk
from nltk.sentiment.vader import SentimentIntensityAnalyzer


# Download the VADER lexicon for sentiment analysis if not already present.
nltk.download('vader_lexicon')

# Define a function to fetch data from a SQL database using a SQL query
def fetch_data_from_sql():
    # Define the connection string with parameters for the database connection
    conn_str = (
        "Driver={SQL Server};"  # Specify the driver for SQL Server
        "Server=ALI-LT2024\\SQLEXPRESS;"  # Specify your SQL Server instance
        "Database=PortfolioProject_MarketingAnalytics;"  # Specify the database name
        "Trusted_Connection=yes;"  # Use Windows Authentication for the connection
    )
    # Establish the connection to the database
    conn = pyodbc.connect(conn_str)
    
    # Define the SQL query to fetch customer reviews data
    query = "SELECT ReviewID, CustomerID, ProductID, ReviewDate, Rating, ReviewText FROM fact_customer_reviews"
    
    # Execute the query and fetch the data into a DataFrame
    df = pd.read_sql(query, conn)
    
    # Close the connection to free up resources
    conn.close()
    
    # Return the fetched data as a DataFrame
    return df

# Fetch the customer reviews data from the SQL database
customer_reviews_df = fetch_data_from_sql()

# Initialize the VADER sentiment intensity analyzer for analyzing the sentiment of text data
sia = SentimentIntensityAnalyzer()

# Define a function to calculate sentiment scores using VADER
def calculate_sentiment(review):
    # Get the sentiment scores for the review text
    sentiment = sia.polarity_scores(review)
    # Return the compound score, which is a normalized score between -1 (most negative) and 1 (most positive)
    return sentiment['compound']

# Define a function to categorize sentiment using both the sentiment score and the review rating
def categorize_sentiment(score, rating):
    # Use both the text sentiment score and the numerical rating to determine sentiment category
    if score > 0.05:  # Positive sentiment score
        if rating >= 4:
            return 'Positive'  # High rating and positive sentiment
        elif rating == 3:
            return 'Mixed Positive'  # Neutral rating but positive sentiment
        else:
            return 'Mixed Negative'  # Low rating but positive sentiment
    elif score < -0.05:  # Negative sentiment score
        if rating <= 2:
            return 'Negative'  # Low rating and negative sentiment
        elif rating == 3:
            return 'Mixed Negative'  # Neutral rating but negative sentiment
        else:
            return 'Mixed Positive'  # High rating but negative sentiment
    else:  # Neutral sentiment score
        if rating >= 4:
            return 'Positive'  # High rating with neutral sentiment
        elif rating <= 2:
            return 'Negative'  # Low rating with neutral sentiment
        else:
            return 'Neutral'  # Neutral rating and neutral sentiment

# Define a function to bucket sentiment scores into text ranges
def sentiment_bucket(score):
    if score >= 0.5:
        return '0.5 to 1.0'  # Strongly positive sentiment
    elif 0.0 <= score < 0.5:
        return '0.0 to 0.49'  # Mildly positive sentiment
    elif -0.5 <= score < 0.0:
        return '-0.49 to 0.0'  # Mildly negative sentiment
    else:
        return '-1.0 to -0.5'  # Strongly negative sentiment

# Apply sentiment analysis to calculate sentiment scores for each review
customer_reviews_df['SentimentScore'] = customer_reviews_df['ReviewText'].apply(calculate_sentiment)

# Apply sentiment categorization using both text and rating
customer_reviews_df['SentimentCategory'] = customer_reviews_df.apply(
    lambda row: categorize_sentiment(row['SentimentScore'], row['Rating']), axis=1)

# Apply sentiment bucketing to categorize scores into defined ranges
customer_reviews_df['SentimentBucket'] = customer_reviews_df['SentimentScore'].apply(sentiment_bucket)

# Display the first few rows of the DataFrame with sentiment scores, categories, and buckets
print(customer_reviews_df.head())

# Save the DataFrame with sentiment scores, categories, and buckets to a new CSV file
customer_reviews_df.to_csv('fact_customer_reviews_with_sentiment.csv', index=False)

```
Result: [fact_customer_reviews_enrich.csv
](https://github.com/VictoriaStetskevych/projects/blob/main/05_sql_powerBI_dashboard_ali_ahmad/fact_customer_reviews_enrich.csv)


## 9. Dashboards in Power BI

DAX Script for Calendar in Power BI

```sql
Calendar = 
ADDCOLUMNS (
    CALENDAR ( DATE ( 2023, 1, 1 ), DATE ( 2025, 12, 31 ) ),
    "DateAsInteger", FORMAT ( [Date], "YYYYMMDD" ),
    "Year", YEAR ( [Date] ),
    "Monthnumber", FORMAT ( [Date], "MM" ),
    "YearMonthnumber", FORMAT ( [Date], "YYYY/MM" ),
    "YearMonthShort", FORMAT ( [Date], "YYYY/mmm" ),
    "MonthNameShort", FORMAT ( [Date], "mmm" ),
    "MonthNameLong", FORMAT ( [Date], "mmmm" ),
    "DayOfWeekNumber", WEEKDAY ( [Date] ),
    "DayOfWeek", FORMAT ( [Date], "dddd" ),
    "DayOfWeekShort", FORMAT ( [Date], "ddd" ),
    "Quarter", "Q" & FORMAT ( [Date], "Q" ),
    "YearQuarter",
        FORMAT ( [Date], "YYYY" ) & "/Q"
            & FORMAT ( [Date], "Q" )
)
```

Result: Power BI Dashboards [PBIX file](https://github.com/VictoriaStetskevych/projects/blob/main/05_sql_powerBI_dashboard_ali_ahmad/Dashboard_sql.pbix)

![](https://github.com/VictoriaStetskevych/projects/blob/main/05_sql_powerBI_dashboard_ali_ahmad/images/dashboard_01.png?raw=true)

![](https://github.com/VictoriaStetskevych/projects/blob/main/05_sql_powerBI_dashboard_ali_ahmad/images/dashboard_02.png?raw=true)

![](https://github.com/VictoriaStetskevych/projects/blob/main/05_sql_powerBI_dashboard_ali_ahmad/images/dashboard_03.png?raw=true)

![](https://github.com/VictoriaStetskevych/projects/blob/main/05_sql_powerBI_dashboard_ali_ahmad/images/dashboard_04.png?raw=true)