USE PortfolioProject_MarketingAnalytics;

--------------------------- products ---------------------------------
SELECT *
FROM products;

SELECT MIN(Price)
FROM products;

SELECT MAX(Price)
FROM products;

SELECT 
    ProductID,
    ProductName,
    Price,
CASE 
    WHEN Price < 50 THEN 'Low'
    WHEN PRICE BETWEEN 50 AND 200 THEN 'Medium'
    ELSE 'High'
END AS [Price Category]
FROM dbo.products;

------------------------- customers ------------------------------------

SELECT * 
FROM customers;

SELECT 
    Gender,
    COUNT(*) AS GenderCount
FROM customers
GROUP BY Gender;

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

------------------------- geographyID ------------------------------------

SELECT * 
FROM geography;

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

------------------------- customer_reviews ------------------------------------

SELECT *
FROM customer_reviews;

SELECT
    ReviewID,
    CustomerID,
    ProductID,
    ReviewDate,
    Rating,
    REPLACE(ReviewText, '  ', ' ') AS ReviewText
FROM customer_reviews;

------------------------- engagement_data ------------------------------------

SELECT *
FROM engagement_data;

SELECT
    EngagementID,
    ContentID,
    CampaignID,
    -- Replace 'Socialmedia' with 'Social Media', UPPER function to standartize text data in the column
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
    -- Filter ContetntType is excluded as it's not relevant for this analysis
WHERE 
    ContentType != 'Newsletter';

------------------------- customer_journey ------------------------------------

SELECT *
FROM customer_journey;

	-- Common Table Expression (CTE) to identify and tag duplicate records

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
			-- PARTITION BY - to group the rows based on spresific columns
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

SELECT DISTINCT(Action)
FROM customer_journey;

