## Cleaning data in Microsoft SQL server ##
 
This project was made using Alex Freberg's YouTube [tutorial](https://www.youtube.com/watch?v=4UltKCnnnTA).


Goals:
- Remove duplicates
- Standardize the data
- Populate the null or blank cells.
- Delete unusual data with nulls that we couldn't populate.

PROCESS

1. Import file into Microsoft SQL server.
I had some difficulties with importing the [layoffs.csv](https://github.com/VictoriaStetskevych/projects_from_internet/blob/main/01_layoffs_alex_the_analyst/layoffs.csv) file. 
This is the way, how I was able to upload the file.

> [!TIP]
> Select Database > Tasks > Import Data > Next > Data source = Flat file source > Select CSV file > Locale = English (United States)  > Next > Destination > Microsoft OLE DB Provider for SQL Server > Next > Next > Finish


2. The most important step in a cleaning data process - to make a duplicate to the original data file. Never work with a raw data file!

```sql
SELECT *
INTO layoffs_staging
FROM [Portfolio Project]..layoffs;
```

During this project I was making other duplicates, especially before updating data. Just to make sure I have back ups, and I have last updated version of a file.

3. Finding and removing duplicates.
For this task we are going to use CTE to group and filter data.

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
Result after executing a query.
![](https://raw.githubusercontent.com/VictoriaStetskevych/projects_from_internet/refs/heads/main/01_layoffs_alex_the_analyst/images/02_deleted_dulicates.png)

4. Standardizing data

During this part of a project we need to make data consistent.

First of all we run query to see names of all companies and to check if there are any inconsistencies. 
```sql
SELECT DISTINCT (company)
FROM layoffs_staging2
```
Result: there are 2 companies that have extra space at the beginning. 
![](https://raw.githubusercontent.com/VictoriaStetskevych/projects_from_internet/refs/heads/main/01_layoffs_alex_the_analyst/images/03_companies.png)

Remove extra spaces using TRIM function and update data file.
```sql
UPDATE layoffs_staging2
SET company = TRIM(company)
```
Result: 
![](https://raw.githubusercontent.com/VictoriaStetskevych/projects_from_internet/refs/heads/main/01_layoffs_alex_the_analyst/images/04_companies_fixed.png)

While checking names of industries we noticed that "Crypto" industry represented by 3 different names and there are 'Blank'(no data) industry cells 
```sql
SELECT DISTINCT (industry)
FROM layoffs_staging2
ORDER by 1
``` 
Result
Result: 
![](https://raw.githubusercontent.com/VictoriaStetskevych/projects_from_internet/refs/heads/main/01_layoffs_alex_the_analyst/images/05_industries.png)

