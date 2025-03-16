# Finance Power BI Dashboard 

This project was made using Nicole Thompson's [tutorial](https://www.youtube.com/watch?v=BLxW9ZSuuVI) that I found on Mo Chen's Youtube [channel](https://www.youtube.com/@mo-chen)

Goal: To build a financial dashboard to analyze sales, profit, and quantity of sales (YoY, MoM), Top/Bottom countries.   

https://github.com/user-attachments/assets/c08074be-788d-415b-9e8a-b2148bcc8126

## Process 

Here are some important steps and functions I used in this project:

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

> [!NOTE]
> It's a calculated column. <br>
> It will return TRUE or FALSE for each row based on the condition.<br>
> EDATE function in DAX moves a date forward or backward by a specified number of months.<br>

```sql
Inpact = 
VAR lastsalesdate = MAX(Fact_sales[Date_Time])
VAR lastsalesdatePY = EDATE(lastsalesdate, -12)
RETURN
Dim_Date[Date]<=lastsalesdatePY
```

- Modeling / New Table / _Measures = and (Press Enter) <br>

> [!NOTE]
> To create a new table with verity of measures. <br>

<u>The list of measures:<br></u>
- Sales
```sql
Sales = SUM(Fact_sales[Sales_USD])<br>
```
- Quantity
```sql
Quantity = SUM(Fact_sales[quantity])<br>
```
- COGs - Cost of Goods <br>
```sql
COGs = SUM(Fact_sales[COGS_USD])<br> 
```
- Gross Profit<br>
```sql
Gross Profit = [Sales]-[COGs]
``` 
- PYTD_Sales - Prior Year to Date Sales
```sql
  PYTD_Sales = 
CALCULATE(
    [Sales],
    SAMEPERIODLASTYEAR(Dim_Date[Date]),
    Dim_Date[Inpact] = TRUE
)
```
> [!NOTE]
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
```sql
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
-- It counted sales by year separately but when I wanted to see the data for two year it didn't show the total amount
YTD_Sales = TOTALYTD([Sales],Fact_sales[Date_Time])
-- formula I used
YTD_Sales = CALCULATE([Sales],Fact_sales[Date_Time])
```
- Year to Date Quantity
```sql
-- original formula.
-- The reason I changed it is the same as in a previous formula
YTD_Quantity = TOTALYTD([Quantity],Fact_sales[Date_Time])
-- formula I used
YTD_Quantity = CALCULATE([Quantity],Fact_sales[Date_Time])
```
- Year to Date Gross Profit
```sql
-- original formula.
-- The reason I changed it is the same as in a previous formula
YTD_GrossProfit = TOTALYTD([Gross Profit],Fact_sales[Date_Time])
-- formula I used
YTD_GrossProfit = CALCULATE([Gross Profit],Fact_sales[Date_Time])
```
- Switch prior year to date
```sql
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

```sql
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
- P.S.
Colors I used for this projects:

<table>
   <tr>
      <td>Color</td>
      <td><img src="https://color-hex.org/colors/540202.png" style="width:100px; height:50px;"></td>
      <td><img src="https://www.colorhexa.com/ab3131.png" style="width:100px; height:50px;"></td>
      <td><img src="https://www.colorhexa.com/3f6c48.png" style="width:100px; height:50px;"></td>
      <td><img src="https://color-hex.org/colors/799163.png" style="width:100px; height:50px;"></td> 
      <td><img src="https://www.colorhexa.com/c0d3ad.png" style="width:100px; height:50px;"></td>
   </tr>
   <tr>
      <td>Color code</td>
      <td>#540202</td>
      <td>#AB3131</td>
      <td>#3F6C48</td>
      <td>#799163</td>
      <td>#C0D3AD</td>
   </tr>
</table>
