# Cleaning data in Microsoft SQL server ##
 
This project was made using Alex Freberg's YouTube [tutorial](https://www.youtube.com/watch?v=4UltKCnnnTA).


Goals:
- Remove duplicates
- Standardize the data
- Populate the null or blank cells.
- Delete data with nulls that we couldn't populate.

# PROCESS

## 1. Import file into Microsoft SQL server.

I had some difficulties with importing the [layoffs.csv](https://github.com/VictoriaStetskevych/projects/blob/main/SQL/01_sql_layoffs_alex_the_analyst/layoffs_cleaned.csv) file. 
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
![](https://github.com/VictoriaStetskevych/projects/blob/main/SQL/01_sql_layoffs_alex_the_analyst/images/01_duplicates.png?raw=true)

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
![](https://github.com/VictoriaStetskevych/projects/blob/main/SQL/01_sql_layoffs_alex_the_analyst/images/02_dulicates_fixed.png?raw=true)

## 4. Standardizing data

During this part of a project I make data consistent.

- First of all I run query to see names of all companies and to check if there are any inconsistencies. 
```sql
SELECT DISTINCT (company)
FROM layoffs_staging2
```
Result: there are 2 companies that have extra space at the beginning. 
![](https://github.com/VictoriaStetskevych/projects/blob/main/SQL/01_sql_layoffs_alex_the_analyst/images/03_company.png?raw=true)

To fix it I use a TRIM function to delete spaces and after that I update my data file.
```sql
UPDATE layoffs_staging2
SET company = TRIM(company)
```
Result: no more companies with extra spaces in names
![](https://github.com/VictoriaStetskevych/projects/blob/main/SQL/01_sql_layoffs_alex_the_analyst/images/04_company_fixed.png?raw=true)

- While checking names of industries I noticed that "Crypto" industry represented by 3 different names and there are 'Blank'(no data) industry cells 
```sql
SELECT DISTINCT (industry)
FROM layoffs_staging2
ORDER by 1
``` 
Result:                           
![](https://github.com/VictoriaStetskevych/projects/blob/main/SQL/01_sql_layoffs_alex_the_analyst/images/05_industries.png?raw=true)

To fix it I use the next query anf update my data file.
```sql
UPDATE layoffs_staging2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';
```
Result:                           
![](https://github.com/VictoriaStetskevych/projects/blob/main/SQL/01_sql_layoffs_alex_the_analyst/images/06_industries_fixed.png?raw=true)

- While checking names of countries I noticed that 'United States' is written as 'United States.'(with a dot). 
```sql
SELECT DISTINCT country
FROM layoffs_staging2
ORDER by 1;
```
Result:                             
![](https://github.com/VictoriaStetskevych/projects/blob/main/SQL/01_sql_layoffs_alex_the_analyst/images/07_country.png?raw=true)

With the next step I change the 'United States' country name and update the data file. 
```sql
 UPDATE layoffs_staging2
 SET country = TRIM(TRAILING '.' FROM country)
 WHERE country LIKE 'United States%';
``` 
Result:                                 
![](https://github.com/VictoriaStetskevych/projects/blob/main/SQL/01_sql_layoffs_alex_the_analyst/images/08_country_fixed.png?raw=true)

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

Using the same method I changed data type to "total_laid_off" and "percentage_laid_off" columns.
```sql
-- identify total_laid_off with NULL ad change a data type 
SELECT *
FROM layoffs_staging3
WHERE TRY_CAST(total_laid_off AS numeric) IS NULL;

-- Update data file.
UPDATE layoffs_staging3
SET total_laid_off = NULL
WHERE TRY_CAST(total_laid_off AS numeric) IS NULL;

-- change data type to numeric in a total_laid_off column

ALTER TABLE layoffs_staging3
ALTER COLUMN total_laid_off numeric;

-- for percentage_laid_off I am going to set decimal data type
-- identify percentage_laid_off with NULL and change a data type.
SELECT *
FROM layoffs_staging3
WHERE TRY_CAST(percentage_laid_off AS decimal(10,4)) IS NULL;

-- Update data file
UPDATE layoffs_staging3
SET percentage_laid_off = NULL
WHERE TRY_CAST(percentage_laid_off AS decimal(10,4)) IS NULL;

-- change data type to date in a percentage_laid_off column

ALTER TABLE layoffs_staging3
ALTER COLUMN percentage_laid_off decimal(10,4);
```
Result:
![](https://github.com/VictoriaStetskevych/projects/blob/main/SQL/01_sql_layoffs_alex_the_analyst/images/09_data_type_fixed.png?raw=true)

## 5. Fill in blank/NULL cells 

During cleaning data I noticed that there are blank cells in the "industry" column.
I need to try to fill them. For this task I need check what companies have missing data in the "industry" column, and for this task I use the next query
```sql
SELECT *
FROM layoffs_staging3
WHERE industry= 'NULL'
OR industry = '';
```
Result:
There are 4 rows with missing data in the "industry" column
![](https://github.com/VictoriaStetskevych/projects/blob/main/SQL/01_sql_layoffs_alex_the_analyst/images/10_industry_missing.png?raw=true)

To fill these cells I will use a JOIN function to check if there are the same companies with filled "industry" cells in other rows. 
```sql
SELECT *
FROM layoffs_staging2 t1
JOIN layoffs_staging2 t2
	ON t1.company = t2.company
	AND t1.location = t2.location
WHERE (t1.industry IS NULL OR t1.industry = '')
AND t2.industry IS NOT NULL
```
Result:
As I can see, there are other rows with the same company names with filled "industry" cell.
![](https://github.com/VictoriaStetskevych/projects/blob/main/SQL/01_sql_layoffs_alex_the_analyst/images/11_industry_missing_result.png?raw=true)

With the next query I'll populate blank/NULL cells in the "industry" column and update the data file 
``` sql
UPDATE t1
SET t1.industry = t2.industry
FROM layoffs_staging4 AS t1
INNER JOIN layoffs_staging4 AS t2
ON t1.company = t2.company
WHERE (t1.industry IS NULL OR t1.industry = '')
  AND t2.industry IS NOT NULL;
```
After this step only one the "Bally's Interactive" company has a NULL in an "industry" column and we don't have any data to fill it.
The only thing I'm going to do is to update the data file one more time to set a proper format to this NULL cell as it was a 'NULL' text format.
```sql
UPDATE layoffs_staging4
SET industry = NULL
WHERE industry = 'NULL';
```
## 6. Delete the data with NULLs that I couldn't populate.

This is going to be the last step in the cleaning process.
There are some cells that have NULLS and I can't populate them. So, with my next query I will delete this data and update the data file .
```sql
SELECT *
FROM layoffs_staging4
WHERE total_laid_off is NULL
AND percentage_laid_off is NULL;

DELETE 
FROM layoffs_staging4
WHERE total_laid_off is NULL
AND percentage_laid_off is NULL;
```

This is the end of the cleaning process. 
Let's check with this final query how the data is look like after cleaning.
```sql
SELECT *
FROM layoffs_staging4
```
If you will need to save a cleaned data as a new .csv file, you need to follow next steps:
- write query
- execute the query as usual
- right click anywhere in the result set grid, then select 'Save Results As'
- choose 'File name' and 'Save as type (.csv)'
- select a location where you want to save your file
- click Save.

[layoffs_cleaned.csv](https://github.com/VictoriaStetskevych/projects/blob/main/SQL/01_sql_layoffs_alex_the_analyst/layoffs_cleaned.csv) file
