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


2. The most important step in a cleaning data process - to make a duplicate to the original data file. 

```sql
SELECT *
INTO layoffs_staging
FROM [Portfolio Project]..layoffs;
```

During cleaning data I was making other duplicates, especially before updating data.

3. Finding and removing duplicates.
For this task we are going to use CTE in SQL to group and filter data.

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
Result:
!()