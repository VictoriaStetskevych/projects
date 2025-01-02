# Pivot Tables and Dashboard in Microsoft Excel

This project was made using Mo Chen's YouTube [tutorial](https://www.youtube.com/watch?v=m13o5aqeCbM&t=1660s).

The tasks for this project are:
 - make a table, combining data from additional tables (XLOOKUP),
 - create a dashboard using Pivot Tables.

Result: a dashboard with a timeline, different slicers, and charts.<br>
-----------------video

 # PROCESS

## 1. Duplicate a raw data.

> [!TIP]<br>
> I always make a duplicate! I never work with an original file!<br>
In this case, I always have a chanse to come back to the original file if something goes wrong.<br>
Having an original backup, I always can start over.<br>
 
Original data file has 3 sheets with different data. <br>

 - I made a copy of each raw data sheet. 
 (Right click on a sheet > Move or copy / Create a copy) 
 - Renamed sheets.
 Since then, I was working with a duplicate sheets

 ---------------- image 01

 ## 2. Populate cells

**'Orders' sheet > 'Customer Name' column**

To populate cells in this column I used the following XLOOKUP function:<br>

Lookup_value ► Customer ID ('order' sheet)<br>
Lookup_array ► Customer ID ('customers' sheet)<br>
Return_array ► Customer Name ('customers' sheet) <br>
match_mode = 0, as I needed the exact match.<br>

=XLOOKUP(C2,customers!$A$2:$A$1001,customers!$B$2:$B$1001,,0)<br>

---------------- image 02

Autofill and the result.<br>
---------------- image 03

**'Orders' sheet > 'Email' column**

I used the same method to populate a column with the email data:<br>

Lookup_value ► Customer ID ('order' sheet)<br>
Lookup_array ► Customer ID ('customers' sheet)<br>
Return_array ► Email ('customers' sheet) <br>
match_mode = 0, as I needed the exact match.<br>

---------------- image 04<br>

after appllying XLOOKUP function I got 'O(zeros)' in cells without emails, so I wrapped XLOOKUP function in IF function to fix this issue.<br>

---------------- image 05

**'Orders' sheet > 'Country' column**

I used the same method to populate a column with the country data:<br>

Lookup_value ► Customer ID ('order' sheet)<br>
Lookup_array ► Customer ID ('customers' sheet)<br>
Return_array ► Country ('customers' sheet) <br>
match_mode = 0, as I needed the exact match.<br>

**Orders' sheet > Columns 'Coffee Type',	'Roast Type','Size',	'Unit Price'**

To populate cells in these columns I could use the same XLOOKUP mtethod, as I was using before, but Mo suggersted to use INDEX MATCHC method, as this method is going to be more dynamic.

=INDEX('products  '!$A$1:$G$49,MATCH($D2,'products  '!$A$1:$A$49,0),MATCH(orders!I$1,'products  '!$A$1:$G$1,0))

----------------images 06 
----------------image 07

**'Orders' sheet > 'Sales' column**

It's the last column. For populating this column I was using a simple formula
sales = Quantity(packages)*UnitPrice

----------------image 09

**'Orders' sheet > New column 'Coffee Type Name'**

I added a new column "Coffee Type Name" to write a full name for each type of coffee.
I used IF function to populate cells.<br>
Rob - Robusta<br>
Exc - Excelsa<br>
Ara - Arabica<br>
Lib - Liberica<br>

=IF(I2="Rob","Robusta",IF(I2="Exc","Excelsa",IF(I2="Ara","Arabica",IF(I2="Lib","Liberica",""))))<br>

----------------image 10

**'Orders' sheet > New column 'Roast Type Name'**

I added a new column "Roast Type Name" to write full name for a type of roast, as it's much easier to understand a coffe roast type when it's written as a word, then just a letter (L,M or D).<br> 
I used IF function to populate cells.<br>

=IF(J2="M","Medium",IF(J2="L","Light",IF(J2="D","Dark","")))<br>

----------------image 11

## 3. Fomatting

**'Orders' sheet > 'Order Date' column formatting**

I changed a date formate to dd-mmm-yyyy.

**'Orders' sheet > 'Size' column formatting**

I changed a 'Size' data formate to '0.0 "kg"'.

**'Orders' sheet > 'Unit Price' and 'Sales' columns formatting**

I changed formate to 'Accounting Number Format > US dollars'.

**Remove dupliocates**

I also checked if the data has any duplicates to remove them. <br>
I did it with the following steps:<br>
- select all data<br>
- Data > Remove duplicates<br> 
- Press Enter<br>

With the current data I got a message "No duplicate values found"

**Convert an 'Orders' sheet range into an actual Table**

- click anywhere on a the table<br>
- Ctrl + T > press OK<br>
- Change a table style (now nessesary)<br>


## 4. Pivot table #1 'Total Sales Over Time'

I add a Pivot Table 'Total Sales Over Time' I was using the following steps:<br>
Click anywhere on a table > Insert > Pivot Table<br>
1. Rows: Order Date <br>

To make dates to be group by year and month:<br>
2. Right CLick > Group > Choose: Month and Year > OK<br>
3. Design <br>
4. Report Layout > Show in Tabular Form<br>
5. Grand Totals > Off for Rows and Columns<br>
6. Subtotals > Do not Show Subtotals<br>

7. Columns: Coffee Type Name<br> 

8. Values: Sales<br>
9. Value Field Setting > Number Format > Number > Use 1000 Separator > Decimal places = 0 <br>

10. Insert > Line Chart<br>

![alt text](<Screenshot 2024-12-23 173314.png>)

11. Right Click on any button on a chart > 'Hide all Field Buttons on Chart'
12. Formatted to make it look presentable. 

![alt text](<Screenshot 2024-12-23 181830.png>)

## 5. Time Line

1. Select a chart 'Total Sales Over Time'
2. PivotChart Analyze > Insert Timeline > Order Date > OK
3. Changed the Time Line style.  
   Timeline > Timeline Styles > New Timeline Style > 

![alt text](<Screenshot 2024-12-26 143958.png>)

## 6. Slicers

1. Select a chart 'Total Sales Over Time'
2. PivotChart Analyze > Insert Slicer > Roast Type Name
                                    > Size
                                    > Loyalty Card
                                    > Coffee Type Name
3. Changed the slicer style. 

## 4. Pivot table #2 'Sales by Country'

I created a second pivot chart by copying the first one and changing parameters. (Press Ctrl + Drag a sheet)
Rows: Country
Values: Sales (Sum of Sales)

Insert > Bar Chart

I rearranged the order:
Pivot Table > Sort (Country) > More Sort Option > Ascending order (Sum of Sales)

Formatted to make it look presentable. 


## 5. Pivot table #3 'Top 5 Customers'

I created a third pivot chart by copying the second one and changing parameters.(Press Ctrl + Drag a sheet)
Rows: Customer Name
Values: Sales (Sum of Sales)

Insert > Bar Chart

To make only Top 5 Customers
Pivot Table > Sort (Customer Name) > Value Filters > Top 10 > Change to Top 5 

I rearranged the order:
Pivot Table > Sort (Customer Name) > More Sort Option > Ascending by Sum of Sales

Formatted to make it look presentable.

## 6. Dashboard

To make  dashboard I:
- added another sheet to the document,
- remaned it as 'Dashboard',
- inserted a shape (erctangle),
- added a text 'COFFEE SALES DASHBOARD' to the shape, aligned it, changed text color, and size
- added all charts and slicers from pivot tables to the dashboard (cut (Ctrl+X) > paste (Crtl+V) )
- rearranged / adjust all charts and slicers on a dashboard to look readable and easy to understand
- made a connection between timeline, slicers and all charts
Select timeline / slicer > Timeline / Slicer > Report Connections > Select all charts  
- Removed gridlines
View > Uncheck 'Gridlines' Checkbox

This is a final result of this project: <br>

Coffee Sales Dashboard:

------------ video