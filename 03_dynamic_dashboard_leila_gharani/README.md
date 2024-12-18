# Dashboard in Microsoft Excel

This project was made using Leila Gharani's YouTube [tutorial](https://www.youtube.com/watch?v=lHk6MdGAfw8).

The tasks for this project are:
 - define and combine data from two different tables (Actuals and Plan) using XLOOKUP.
 - compare data
 - add variances for future analysis.
 - create charts and a dynamic dashboard.

 This is the result:

-----------img14

# PROCESS

## 1. Create a new sheet for the project
 
In this project I didn't change the original files (sheets) that I got. I had to combine raw data into another table. 
So, I added another sheet to the same document, called it 'Dashboard_new', and copied the formatting that was suggested in the Leila's tutorial.<br>

-----------img1

## 2. Create a dropdown list for years and months

**Year - dropdown list**<br>
To make a drop down list by year I used a Data Validation tool <br>
Choose a cell for the list. <br>
Data > Data validation<br>
Allow: List<br>
Source: 'Actives' sheet, choose all column with year data range (Ctrl + Shift + Down Arrow Key)<br>
-----------img2<br>
Result:<br>
-----------img3

**Month - dropdown list**<br>
I used the same method to make a dropdown list by month
Choose a cell for the list.<br>
Data > Data validation<br>
Allow: List<br>
Source: 'Plan' sheet, choose all column with months data range (Ctrl + Shift + Down Arrow Key)<br>
-----------img4<br>
Result:<br>
-----------img5

## 3. XLOOKUP function to populate columns Actual, PY(previous year), Plan in a new table

I used XLOOKUP function to populate columns in a new table with actual data by location, making sure I can separately change any year/month and get the total amount by each location.<br>
I was using the following function:<br>
=XLOOKUP($C$2&$C$3&B7,TSales[Year]&TSales[Month]&TSales[Store Location],TSales[Sales],"")<br>

-----------img6

Autofill and this is the result.<br>
-----------img7

To populate a column PY (previous year), I copied the same XLOOKUP function, made sure all cells referred correctly and added -1 to year.<br>
Autofill.<br>
Result:<br>
-----------img8<br>

To populate a column Plan I used the XLOOKUP function again (=XLOOKUP(B7,Plan_raw!$A$3:$A$13,XLOOKUP($C$3,Plan_raw!$B$2:$M$2,Plan_raw!$B$3:$M$13),"")) to fill the data by month and by each location. 
Autofill and result:
-----------img9

## 4. Variances

I added two new headers '∆ PY %' and '∆ PL %' to the table.

I used formulas:<br>
 'Actual/Previous - 1' to get '∆ PY %' and,<br>
 'Actual/Plan - 1' to get '∆ PL %'. <br>
I also additionally wrapped this formula into IFERROR function to make sure I don't have value errors when I don't have any data.<br>
Autofill and result.<br>

Result ∆ PY %<br>

-----------img10<br>

Result ∆ PL %<br>

-----------img11<br>

**Change number formatting**<br>
I used the following formatting for columns:<br>
∆ columns - Percentage (Ctrl+1 > Percentage)<br>
Actual, previous year, plan - comma separator and zero decimal places. (Ctrl+1 > Number)<br>

Now all data in the table is changing automatically, no matter what year/month I choose. 

-----------img12


## 4. Visualization 

**Chart #1**<br>
Selected:<br>
All locations names + column 'Actual' + column 'Plan'<br>
Insert > Column Chart<br>

-----------img13<br>

**Chart #2**<br>
Selected:<br>
All locations names + ∆ PY %<br>

I also slightly changed the formatting of the second chart, as was suggested in the tutorial.<br>

-----------img14<br>

## 5. My additional analysis and charts

I decided to make extra analysis as I really enjoyed working with this data.
I wanted to find out the total amount (not by month) of sales by each location separately for each year, and later compare total sales with the previous year.<br>

For that task I used the following functions and formulas:<br>
=IFERROR(SUM(FILTER(TSales[Sales], (Actuals_raw!$A$4:$A$353 = $C$19) * (Actuals_raw!$C$4:$C$353 = B23))),"")<br>

I used the same formula to recalculate the data for the previous year:<br>
=IFERROR(SUM(FILTER(TSales[Sales], (Actuals_raw!$A$4:$A$353 = $C$19-1) * (Actuals_raw!$C$4:$C$353 = B23))),"")<br>

And I found '∆ PY % total' using the same method as before
=IFERROR(C23/D23-1,"")<br>

I also built a chart that shows the total ∆ compared to the previous year separately for each location.<br>

I additionally added a simple calculation 'TOTAL, all location' using the SUM formula and calculated ∆ PY .<br>
Added conditional formatting to the cell with total ∆ to make the font green/red depending if it's positive or negative.

And this is the final result.
-----------img15<br>