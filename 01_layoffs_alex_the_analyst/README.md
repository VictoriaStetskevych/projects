## Cleaning data using Microsoft SQL server ##
 
This project was made using Alex Freberg's YouTube [tutorial](https://www.youtube.com/watch?v=4UltKCnnnTA).


Goals:
- Remove duplicates
- Standardize the data
- Populate the null or blank cells.
- Delete unusual data with nulls that we couldn't populate.

PROCESS

1. First import file in Microsoft SQL server and.
I had some difficulties with importing the layoffs.csv file. This is the way, how I was able to upload the file.

Select Database > Tasks > Import Data > Next > Data source = Flat file source > Select CSV file > Locale = English (United States)  > Next > Destination > Microsoft OLE DB Provider for SQL Server > Next > Next > Finish


2. The most important step in a cleaning data process - to make a duplicate to the original data file. 

```sql
SELECT *
INTO layoffs_staging
FROM [Portfolio Project]..layoffs;
```




