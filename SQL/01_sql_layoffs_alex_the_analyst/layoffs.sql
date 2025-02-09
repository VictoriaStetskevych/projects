SELECT *
FROM [Portfolio Project]..layoffs


-- 1. remove duplicates
-- 2. standartize the data
-- 3. null or blank values
-- 4. remove any columns

-- Miking a copy of layoffs file

SELECT *
INTO layoffs_staging
FROM [Portfolio Project]..layoffs;

SELECT *
FROM layoffs_staging

-- REMOVING DUPLICATES

SELECT *,
       ROW_NUMBER() OVER (
           PARTITION BY company, industry, country
           ORDER BY date DESC
       ) AS row_number
FROM layoffs_staging;

-- Finding duplicates 

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


-- Deleting dupicates

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

-- Make another copy, without duplicates

SELECT *
INTO layoffs_staging2
FROM layoffs_staging


-- STANDARTIZING DATA
-- there were spaces at the beginning 

SELECT DISTINCT (company)
FROM layoffs_staging2

-- trim spaces, showed in a new column
SELECT DISTINCT company, TRIM(company) as 'TRIM(company)'
FROM layoffs_staging2

UPDATE layoffs_staging2
SET company = TRIM(company)

SELECT DISTINCT (company)
FROM layoffs_staging2


SELECT DISTINCT (industry)
FROM layoffs_staging2
ORDER by 1

SELECT *
FROM layoffs_staging2
WHERE industry LIKE 'Crypto%';

UPDATE layoffs_staging2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';

SELECT DISTINCT country
FROM layoffs_staging2
ORDER by 1;

 SELECT DISTINCT country, TRIM(TRAILING '.' FROM country) AS 'TRIM(country)'
 FROM layoffs_staging2
 ORDER BY 1;

 UPDATE layoffs_staging2
 SET country = TRIM(TRAILING '.' FROM country)
 WHERE country LIKE 'United States%';

 SELECT date
 FROM layoffs_staging2
 ORDER BY date DESC;

SELECT date
FROM layoffs_staging2
WHERE TRY_CAST(date AS DATE) IS NULL;

SELECT date,
       FORMAT(CAST(date AS DATE), 'yyyy-MM-dd') AS formatted_date
FROM layoffs_staging2
WHERE TRY_CAST(date AS DATE) IS NOT NULL;

UPDATE layoffs_staging2
SET date = FORMAT(CAST(date AS DATE), 'yyyy-MM-dd') 
WHERE TRY_CAST(date AS DATE) IS NOT NULL;

-- identify date with NULL 
SELECT *
FROM layoffs_staging2
WHERE TRY_CAST(date AS DATE) IS NULL;

-- replace it with NULL
UPDATE layoffs_staging2
SET date = NULL
WHERE TRY_CAST(date AS DATE) IS NULL;

-- change data type to date in a date column

ALTER TABLE layoffs_staging2
ALTER COLUMN date DATE;


-- Make another copy (layoffs_staging3) after all changes

SELECT *
INTO layoffs_staging3
FROM layoffs_staging2;


-- Change a data type in a total_laid_off column to numeric.
-- Since this moment we work with layoffs_staging3 version.
SELECT total_laid_off
FROM layoffs_staging3
ORDER by 1 DESC;


-- Example: we can't do it because it was varchar.
-- But we can afrer changing data type to numeric
SELECT *
FROM layoffs_staging3
WHERE company = 'Microsoft';

SELECT SUM(percentage_laid_off)
FROM layoffs_staging3
WHERE company = 'Foxtrot';


-- identify total_laid_off with NULL 
SELECT *
FROM layoffs_staging3
WHERE TRY_CAST(total_laid_off AS numeric) IS NULL;

-- replace it with NULL
UPDATE layoffs_staging3
SET total_laid_off = NULL
WHERE TRY_CAST(total_laid_off AS numeric) IS NULL;

-- change data type to numeric in a total_laid_off column

ALTER TABLE layoffs_staging3
ALTER COLUMN total_laid_off numeric;

-- for percentage_laid_off we are going to set decimal data type
-- identify percentage_laid_off with NULL 
SELECT *
FROM layoffs_staging3
WHERE TRY_CAST(percentage_laid_off AS decimal(10,4)) IS NULL;

-- replace it with NULL
UPDATE layoffs_staging3
SET percentage_laid_off = NULL
WHERE TRY_CAST(percentage_laid_off AS decimal(10,4)) IS NULL;

-- change data type to date in a percentage_laid_off column

ALTER TABLE layoffs_staging3
ALTER COLUMN percentage_laid_off decimal(10,4);

-- Make another copy (layoffs_staging4) after all changes

SELECT *
INTO layoffs_staging4
FROM layoffs_staging3;


-- for funds_raised_millions we are going to set decimal data type
-- identify funds_raised_millions with NULL 
SELECT *
FROM layoffs_staging4
WHERE TRY_CAST(funds_raised_millions AS decimal(10,4)) IS NULL;

-- replace it with NULL
UPDATE layoffs_staging4
SET funds_raised_millions = NULL
WHERE TRY_CAST(funds_raised_millions AS decimal(10,4)) IS NULL;

-- change data type to date in a funds_raised_millions column

ALTER TABLE layoffs_staging4
ALTER COLUMN funds_raised_millions decimal(10,4);

SELECT *
FROM layoffs_staging4;

-- we have NULL and blank cells in the industry column.
-- So, I need to try to fill it.
SELECT *
FROM layoffs_staging4
WHERE industry='NULL'
OR industry ='';

SELECT *
FROM layoffs_staging4
WHERE company = 'Juul';


-- there are 2 rows and only 1 doesn't have industry.

SELECT *
FROM layoffs_staging4 t1
JOIN layoffs_staging4 t2
	ON t1.company = t2.company
	AND t1.location = t2.location
WHERE (t1.industry IS NULL OR t1.industry = '')
AND t2.industry IS NOT NULL


UPDATE t1
SET t1.industry = t2.industry
FROM layoffs_staging4 AS t1
INNER JOIN layoffs_staging4 AS t2
ON t1.company = t2.company
WHERE (t1.industry IS NULL OR t1.industry = '')
  AND t2.industry IS NOT NULL;

UPDATE layoffs_staging4
SET industry = NULL
WHERE industry = 'NULL';

-- Deleting NULL and blank values that we don't need for the analysis.
SELECT *
FROM layoffs_staging4
WHERE total_laid_off is NULL
AND percentage_laid_off is NULL;

DELETE 
FROM layoffs_staging4
WHERE total_laid_off is NULL
AND percentage_laid_off is NULL;

SELECT *
FROM layoffs_staging4