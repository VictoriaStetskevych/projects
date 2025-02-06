## Business Power BI Dashboard 

This project was made using Nicole Thompson's [tutorial](https://www.youtube.com/watch?v=BLxW9ZSuuVI) that I found on Mo Chen's Youtube [channel](https://www.youtube.com/@mo-chen)

https://github.com/user-attachments/assets/c08074be-788d-415b-9e8a-b2148bcc8126


# Process 

Here are some important steps and functions:

- Upload data / Transform data <br>
- Unique ID: Right click / Remove Duplicates <br>
- Modeling / New Table <br>

- Calendar <br>
```
Dim_Date = 
CALENDAR(
    DATE(2022, 1, 1), 
    DATE(2024, 12, 31)
)
```

- Dim_Date / New Column<br>
```
Inpact = 
VAR lastsalesdate = MAX(Fact_sales[Date_Time])
VAR lastsalesdatePY = EDATE(lastsalesdate, -12)
RETURN
Dim_Date[Date]<=lastsalesdatePY
```
> [!NOTE] <br>
> It's a calculated column. <br>
> It will return TRUE or FALSE for each row based on the condition.<br>
> EDATE function in DAX moves a date forward or backward by a specified number of months.<br>

- Modeling / New Table / _Measures = and (Press Enter) <br>

> [!NOTE] <br>
> To create a new table with veriaty of measures. <br>

The list of measures:<br>
- Sales
```
Sales = SUM(Fact_sales[Sales_USD])<br>
```
- Quantity
```
Quantity = SUM(Fact_sales[quantity])<br>
```
- COGs - Cost of Goods <br>
```
COGs = SUM(Fact_sales[COGS_USD])<br> 
```
- Gross Profit<br>
```
Gross Profit = [Sales]-[COGs]
``` 
- PYTD_Sales - Prior Year to Date Sales
```
  PYTD_Sales = 
CALCULATE(
    [Sales],
    SAMEPERIODLASTYEAR(Dim_Date[Date]),
    Dim_Date[Inpact] = TRUE
)
```
> [!NOTE] <br>
> PYTD_Sales measure calculates sales from the same period last year, but only for past dates.<br> 
> SAMEPERIODLASTYEAR - finds the same date range from last year.<br> 
> Dim_Date[Inpast] = TRUE - Ensures only past dates are included (not future dates).<br> 
> Inpast is a column that marks past dates as TRUE.<br> 
- PYTD_Quantity - Prior Year to Date Quantity
```
PYTD_Quantity = 
CALCULATE(
    [Quantity],
    SAMEPERIODLASTYEAR(Dim_Date[Date]),
    Dim_Date[Inpast] = TRUE
)
```
- PYTD_Quantity - Prior Year to Date Gross Profit
```
PYTD_GrossProfit = 
CALCULATE(
    [Gross Profit],
    SAMEPERIODLASTYEAR(Dim_Date[Date]),
    Dim_Date[Inpast] = TRUE
)
```
- Year to Date Sales
```sql
-- original formula, but it didn't work for me, it didn't count total sales properly. 
-- It counted sales by year saperately but when I wanted to see the data for two year it didn't show the total amount
YTD_Sales = TOTALYTD([Sales],Fact_sales[Date_Time])
-- formula I used
YTD_Sales = CALCULATE([Sales],Fact_sales[Date_Time])
```
- Year to Date Quantity
```sql
-- original formula.
-- The reaason I changged it is the same as in a previous formula
YTD_Quantity = TOTALYTD([Quantity],Fact_sales[Date_Time])
-- formula I used
YTD_Quantity = CALCULATE([Quantity],Fact_sales[Date_Time])
```
- Year to Date Gross Profit
```sql
-- original formula.
-- The reaason I changged it is the same as in a previous formula
YTD_GrossProfit = TOTALYTD([Gross Profit],Fact_sales[Date_Time])
-- formula I used
YTD_GrossProfit = CALCULATE([Gross Profit],Fact_sales[Date_Time])
```
- Switch prior year to date -
```
S_PYTD = 
VAR selected_value = SELECTEDVALUE(Slc_Values[Values])
VAR result = SWITCH(selected_value,
    "Sales", [PYTD_Sales],
    "Quantity", [PYTD_Quantity],
    "Gross Profit", [PYTD_GrossProfit],
    BLANK()
)
RETURN
result
```
> [!NOTE] <br>
> SELECTEDVALUE(Slc_Values[Values]) - gets the value selected in a slicer (e.g., "Sales", "Quantity", or "Gross Profit").<br>
> SWITCH - Checks what the user selected and returns the corresponding measure.<br>
> RETURN result - gives back the chosen measure’s value.
- Switch year to date
```
S_YTD = 
VAR selected_value = SELECTEDVALUE(Slc_Values[Values])
VAR result = SWITCH(selected_value,
    "Sales", [YTD_Sales],
    "Quantity", [YTD_Quantity],
    "Gross Profit", [YTD_GrossProfit],
    BLANK()
)
RETURN
result
```
- Compare two switch data
```sql
-- original formula
YTD vs PYTD = [S_YTD]-[S_PYTD]
-- My formula. I changed it because I didn't want it to display data when I choose 2022, as I don't have any data from 2021.
YTD vs PYTD 2 = 
VAR result = IF( 
    NOT ISBLANK([S_PYTD]) && [S_PYTD] <> 0, 
    ([S_YTD] - [S_PYTD]), 
    BLANK() 
)
RETURN
result

```
- GP% - Gross Profit %
```
GP% = DIVIDE([Gross Profit],[Sales])
```

