# Dynamic dashboard in Microsoft Excel

This project was made using Leila Gharani's YouTube [tutorial](https://www.youtube.com/watch?v=lHk6MdGAfw8).

The tasks for this project are:
 - define and combine data from two different tables (Actuals and Plan) using XLOOKUP,
 - compare data,
 - add variances,
 - create charts and a dynamic dashboard.

 This is the result:

![](https://raw.githubusercontent.com/VictoriaStetskevych/projects/refs/heads/main/03_dynamic_dashboard_leila_gharani/images/15_result.png)
# PROCESS

## 1. Create a new sheet for the project
 
In this project I didn't change the original files (sheets) that I got. I had to combine raw data into another table. 
So, I added another sheet to the same document, called it 'Dashboard_new', and copied the formatting that was suggested in the Leila's tutorial.<br>

![](https://raw.githubusercontent.com/VictoriaStetskevych/projects/refs/heads/main/03_dynamic_dashboard_leila_gharani/images/01_new_sheet.png)

## 2. Create a dropdown list for years and months

**Year - dropdown list**<br>
To make a drop down list by year I used a Data Validation tool <br>
Choose a cell for the list. <br>
Data > Data validation<br>
Allow: List<br>
Source: 'Actives' sheet, choose all column with year data range (Ctrl + Shift + Down Arrow Key)<br>
![](https://raw.githubusercontent.com/VictoriaStetskevych/projects/refs/heads/main/03_dynamic_dashboard_leila_gharani/images/02_data_validation_years.png)<br>
Result:<br>
![](https://raw.githubusercontent.com/VictoriaStetskevych/projects/refs/heads/main/03_dynamic_dashboard_leila_gharani/images/03_data_validation_years_result.png)

**Month - dropdown list**<br>
I used the same method to make a dropdown list by month.<br>
Choose a cell for the list.<br>
Data > Data validation<br>
Allow: List<br>
Source: 'Plan' sheet, choose all column with months data range (Ctrl + Shift + Down Arrow Key)<br>
![](https://raw.githubusercontent.com/VictoriaStetskevych/projects/refs/heads/main/03_dynamic_dashboard_leila_gharani/images/04_data_validation_months.png)<br>
Result:<br>
![](https://raw.githubusercontent.com/VictoriaStetskevych/projects/refs/heads/main/03_dynamic_dashboard_leila_gharani/images/05_data_validation_months_result.png)

## 3. XLOOKUP function to populate columns Actual, PY(previous year), Plan in a new table

I used XLOOKUP function to populate columns in a new table with actual data by location, making sure I can separately change any year/month and get the total amount by each location.<br>
I was using the following function:<br>
=XLOOKUP($C$2&$C$3&B7,TSales[Year]&TSales[Month]&TSales[Store Location],TSales[Sales],"")<br>
![](https://raw.githubusercontent.com/VictoriaStetskevych/projects/refs/heads/main/03_dynamic_dashboard_leila_gharani/images/06_actual_by_location.png)

Autofill and this is the result.<br>
![](https://raw.githubusercontent.com/VictoriaStetskevych/projects/refs/heads/main/03_dynamic_dashboard_leila_gharani/images/07_actual_by_location_result.png)

To populate a column PY (previous year), I copied the same XLOOKUP function, made sure all cells referred correctly and added -1 to year.<br>
Autofill.<br>
Result:<br>
![](https://raw.githubusercontent.com/VictoriaStetskevych/projects/refs/heads/main/03_dynamic_dashboard_leila_gharani/images/08_previous_year_by_location.png)

To populate a column Plan I used the XLOOKUP function again (=XLOOKUP(B7,Plan_raw!$A$3:$A$13,XLOOKUP($C$3,Plan_raw!$B$2:$M$2,Plan_raw!$B$3:$M$13),"")) to fill the data by month and by each location. <br>
Autofill and the result:<br>
![](https://raw.githubusercontent.com/VictoriaStetskevych/projects/refs/heads/main/03_dynamic_dashboard_leila_gharani/images/09_plan.png)

## 4. Variances

I added two new headers '∆ PY %' and '∆ PL %' to the table.

I used formulas:<br>
 'Actual/Previous - 1' to get '∆ PY %' and,<br>
 'Actual/Plan - 1' to get '∆ PL %'. <br>
I also additionally wrapped this formula into IFERROR function to make sure I don't have value errors when I don't have any data.<br>
Autofill and result.<br>

Result ∆ PY %<br>
![](https://raw.githubusercontent.com/VictoriaStetskevych/projects/refs/heads/main/03_dynamic_dashboard_leila_gharani/images/10_delta_previous.png)

Result ∆ PL %<br>
![](https://raw.githubusercontent.com/VictoriaStetskevych/projects/refs/heads/main/03_dynamic_dashboard_leila_gharani/images/11_delta_plan.png)

**Change number formatting**<br>
I used the following formatting for columns:<br>
∆ columns - Percentage (Ctrl+1 > Percentage)<br>
Actual, previous year, plan - comma separator and zero decimal places. (Ctrl+1 > Number)<br>

Now all data in the table is changing automatically, no matter what year/month I choose. 
![](https://raw.githubusercontent.com/VictoriaStetskevych/projects/refs/heads/main/03_dynamic_dashboard_leila_gharani/images/12_number_formatting.png)


## 4. Visualization 

**Chart #1**<br>
Selected:<br>
All locations names + column 'Actual' + column 'Plan'<br>
Insert > Column Chart<br>
![](https://raw.githubusercontent.com/VictoriaStetskevych/projects/refs/heads/main/03_dynamic_dashboard_leila_gharani/images/13_chart.png)<br>

**Chart #2**<br>
Selected:<br>
All locations names + ∆ PY %<br>

I also slightly changed the formatting of the second chart, as was suggested in the tutorial.<br>
![](https://raw.githubusercontent.com/VictoriaStetskevych/projects/refs/heads/main/03_dynamic_dashboard_leila_gharani/images/14_charts.png)<br>

## 5. My additional analysis and charts

I decided to make extra analysis as I really enjoyed working with this data.<br>
I decided to find out:
- total sells for each year separately by each location 
- total year ∆ by each location (∆ PY), 
- total sales by all locations,
- calculate total year ∆ (total ∆ PY),
- add conditional formatting for total ∆.

For that task I used the following functions and formulas:<br>
**Total sells for each year separately by each location:**<br> 
=IFERROR(SUM(FILTER(TSales[Sales], (Actuals_raw!$A$4:$A$353 = $C$19) * (Actuals_raw!$C$4:$C$353 = B23))),"")<br>

**Total sells for the previous year separately by each location:**<br>
I used the same formula to recalculate the data for the previous year:<br>
=IFERROR(SUM(FILTER(TSales[Sales], (Actuals_raw!$A$4:$A$353 = $C$19-1) * (Actuals_raw!$C$4:$C$353 = B23))),"")<br>

**Total year ∆ by each location (∆ PY):**<br>
=IFERROR(C23/D23-1,"")<br>

I also built a chart that shows the total ∆PY for each location.<br>

I additionally added a simple calculation 'TOTAL, all location' using the SUM formula and calculated ∆ PY .<br>
Added conditional formatting to the cell with total ∆ to make the font green/red depending if it's positive or negative.

And this is the final result.
![](https://raw.githubusercontent.com/VictoriaStetskevych/projects/refs/heads/main/03_dynamic_dashboard_leila_gharani/images/15_result.png)<br>