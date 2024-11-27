# Cleaning data in Microsoft SQL server ##
 
This project was made using Alex Freberg's YouTube [tutorial](https://www.youtube.com/watch?v=4UltKCnnnTA).


Goals:
- Remove duplicates
- Standardize the data
- Populate the null or blank cells.
- Delete unusual data with nulls that we couldn't populate.

# PROCESS

## 1. Import file into Microsoft SQL server.

I had some difficulties with importing the [layoffs.csv](https://github.com/VictoriaStetskevych/projects_from_internet/blob/main/01_layoffs_alex_the_analyst/layoffs.csv) file. 
This is the way, how I was able to upload the file.

> [!TIP]
> Select Database > Tasks > Import Data > Next > Data source = Flat file source > Select CSV file > Locale = English (United States)  > Next > Destination > Microsoft OLE DB Provider for SQL Server > Next > Next > Finish

## 2. Make a duplicate to the original data file

This is the most important step in a cleaning data process  
> [!IMPORTANT]
> Never work with a raw data file!!

```sql
SELECT *
INTO layoffs_staging
FROM [Portfolio Project]..layoffs;
```

During this project I was making other duplicates, especially before updating data. Just to make sure I have back ups, and I have a last updated version of a file.

## 3. Finding and removing duplicates.
For this task I am going to use CTE to group and filter data.

```sql
WITH duplicate_cte as
(
SELECT *,
       ROW_NUMBER() OVER (
           PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, date, stage, country, funds_raised_millions
           ORDER BY date DESC
       ) AS row_number
FROM layoffs_staging
)
SELECT *
FROM duplicate_cte
WHERE row_number > 1;
```
Result: 5 duplicate rows that need to be delete:
![](https://raw.githubusercontent.com/VictoriaStetskevych/projects_from_internet/refs/heads/main/01_layoffs_alex_the_analyst/images/01_duplicates.png)

After finding duplicate rows, the next step is to delete them.
```sql
WITH duplicate_cte as
(
SELECT *,
       ROW_NUMBER() OVER (
           PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, date, stage, country, funds_raised_millions
           ORDER BY date DESC
       ) AS row_number
FROM layoffs_staging
)
DELETE FROM duplicate_cte
WHERE row_number > 1;
```
Result: all duplicate rows were deleted.
![](https://raw.githubusercontent.com/VictoriaStetskevych/projects_from_internet/refs/heads/main/01_layoffs_alex_the_analyst/images/02_dulicates_fixed.png)

## 4. Standardizing data

During this part of a project I make data consistent.

- First of all I run query to see names of all companies and to check if there are any inconsistencies. 
```sql
SELECT DISTINCT (company)
FROM layoffs_staging2
```
Result: there are 2 companies that have extra space at the beginning. 
![](https://raw.githubusercontent.com/VictoriaStetskevych/projects_from_internet/refs/heads/main/01_layoffs_alex_the_analyst/images/03_company.png)

To fix it I use a TRIM function to delete spaces and after that I update my data file.
```sql
UPDATE layoffs_staging2
SET company = TRIM(company)
```
Result: no more companies with extra spaces in names
![](https://raw.githubusercontent.com/VictoriaStetskevych/projects_from_internet/refs/heads/main/01_layoffs_alex_the_analyst/images/04_company_fixed.png)

- While checking names of industries I noticed that "Crypto" industry represented by 3 different names and there are 'Blank'(no data) industry cells 
```sql
SELECT DISTINCT (industry)
FROM layoffs_staging2
ORDER by 1
``` 
Result:                           
![](https://raw.githubusercontent.com/VictoriaStetskevych/projects_from_internet/refs/heads/main/01_layoffs_alex_the_analyst/images/05_industries.png)

To fix it I use the next query anf update my data file.
```sql
UPDATE layoffs_staging2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';
```
Result:                           
![](https://raw.githubusercontent.com/VictoriaStetskevych/projects_from_internet/refs/heads/main/01_layoffs_alex_the_analyst/images/06_industries_fixed.png)

- While checking names of countries I noticed that 'United States' written as 'United States.'(with a dot). 
```sql
SELECT DISTINCT country
FROM layoffs_staging2
ORDER by 1;
```
Result:                             
![](https://raw.githubusercontent.com/VictoriaStetskevych/projects_from_internet/refs/heads/main/01_layoffs_alex_the_analyst/images/07_country.png)

With the next step I change the 'United States' country name and update the data file. 
```sql
 UPDATE layoffs_staging2
 SET country = TRIM(TRAILING '.' FROM country)
 WHERE country LIKE 'United States%';
``` 
Result:                                 
![](https://raw.githubusercontent.com/VictoriaStetskevych/projects_from_internet/refs/heads/main/01_layoffs_alex_the_analyst/images/08_country_fixed.png)

There is also a 'Blank' cell in a country column. I'm going to fix it in this project in a step #5 while populating cells. 

- Changing data type.
Right now all data in a date column represented as text format and I need to change it into date format.
I'm going to make it in a couple steps.  
```sql
-- identify a NULL cell in a date column and assign a date type to it.
SELECT date
FROM layoffs_staging2
WHERE TRY_CAST(date AS DATE) IS NULL;

-- update date format for NULL cells in a data file 
UPDATE layoffs_staging2
SET date = NULL
WHERE TRY_CAST(date AS DATE) IS NULL;

-- create an additional column to check that the FORMAT and CAST formulas work properly 
SELECT date,
       FORMAT(CAST(date AS DATE), 'yyyy-MM-dd') AS formatted_date
FROM layoffs_staging2
WHERE TRY_CAST(date AS DATE) IS NOT NULL;

-- update date format in a data file 
UPDATE layoffs_staging2
SET date = FORMAT(CAST(date AS DATE), 'yyyy-MM-dd') 
WHERE TRY_CAST(date AS DATE) IS NOT NULL;

-- permanently change the data type of the column. The column will be recognized as a DATE type in the database schema.
ALTER TABLE layoffs_staging2
ALTER COLUMN date DATE;
```
