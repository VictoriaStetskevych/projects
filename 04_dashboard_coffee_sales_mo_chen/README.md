# Pivot Tables and Dashboard in Microsoft Excel

This project was made using Mo Chen's YouTube [tutorial](https://www.youtube.com/watch?v=m13o5aqeCbM&t=1660s).

The tasks for this project are:
 - make a table, combining data from additional tables (XLOOKUP),
 - create a dashboard using Pivot Tables.

Result: a dashboard with a timeline, different slicers, and charts.<br>

[<video controls src="https://github.com/VictoriaStetskevych/projects/raw/refs/heads/main/04_dashboard_coffee_sales_mo_chen/dashboard_coffee_sales_mo_chen.mp4" title="Dashboard Coffee Sales"></video>](https://github.com/user-attachments/assets/61aeca15-c861-445c-9508-11e39602b732)

 # PROCESS

## 1. Duplicate a raw data.

> [!IMPORTANT]<br>
> I always make a duplicate! I never work with an original file!<br>
In this case, I always have a chance to come back to the original file if something goes wrong.<br>
Having an original backup, I always can start over.<br>
 
Original data file has 3 sheets with different data. <br>

 - I made a copy of each raw data sheet. 
 (Right click on a sheet > Move or copy / Create a copy) 
 - Renamed sheets.
 Since then, I was working with duplicate sheets

 ![](https://github.com/VictoriaStetskevych/projects/blob/main/04_dashboard_coffee_sales_mo_chen/images/01_duplicates.png?raw=true)

 ## 2. Populate cells

**'Orders' sheet > 'Customer Name' column**

To populate cells in the 'Customer Name' column I used the following XLOOKUP function:<br>

Lookup_value ► Customer ID ('order' sheet)<br>
Lookup_array ► Customer ID ('customers' sheet)<br>
Return_array ► Customer Name ('customers' sheet) <br>
match_mode = 0, as I needed the exact match.<br>

=XLOOKUP(C2,customers!$A$2:$A$1001,customers!$B$2:$B$1001,,0)<br>

![](https://github.com/VictoriaStetskevych/projects/blob/main/04_dashboard_coffee_sales_mo_chen/images/02_customers_name.png?raw=true)

Autofill and the result.<br>
![](https://github.com/VictoriaStetskevych/projects/blob/main/04_dashboard_coffee_sales_mo_chen/images/03_customers_name_result.png?raw=true)

**'Orders' sheet > 'Email' column**

I used the same method to populate the 'Email' column with email data:<br>

Lookup_value ► Customer ID ('order' sheet)<br>
Lookup_array ► Customer ID ('customers' sheet)<br>
Return_array ► Email ('customers' sheet) <br>
match_mode = 0, as I needed the exact match.<br>

![](https://github.com/VictoriaStetskevych/projects/blob/main/04_dashboard_coffee_sales_mo_chen/images/04_email.png?raw=true)<br>

After XLOOKUP function I got 'O(zeros)' in cells without emails, so I wrapped XLOOKUP function in IF function to fix this issue.<br>

![](https://github.com/VictoriaStetskevych/projects/blob/main/04_dashboard_coffee_sales_mo_chen/images/05_email_fixed.png?raw=true)

**'Orders' sheet > 'Country' column**

I used the same method to populate the 'Country' column with the country data:<br>

Lookup_value ► Customer ID ('order' sheet)<br>
Lookup_array ► Customer ID ('customers' sheet)<br>
Return_array ► Country ('customers' sheet) <br>
match_mode = 0, as I needed the exact match.<br>

![](https://github.com/VictoriaStetskevych/projects/blob/main/04_dashboard_coffee_sales_mo_chen/images/06_country.png?raw=true)

**Orders' sheet > Columns 'Coffee Type',	'Roast Type','Size',	'Unit Price'**

To populate cells in these columns I could use the same XLOOKUP function method, as I was using before, but Mo suggested to use INDEX MATCH method, as this method would be more dynamic.<br>

=INDEX('products  '!$A$1:$G$49,MATCH($D2,'products  '!$A$1:$A$49,0),MATCH(orders!I$1,'products  '!$A$1:$G$1,0))<br>

![](https://github.com/VictoriaStetskevych/projects/blob/main/04_dashboard_coffee_sales_mo_chen/images/07_index.png?raw=true)<br>

**'Orders' sheet > 'Sales' column**

To populate the 'Sales' column I used a simple formula:<br>
sales = Quantity(packages)*UnitPrice<br>

![](https://github.com/VictoriaStetskevych/projects/blob/main/04_dashboard_coffee_sales_mo_chen/images/09_sales.png?raw=true)

**'Orders' sheet > New column 'Coffee Type Name'**

I added a new column "Coffee Type Name" to write a full name for each type of coffee.
I used IF function to populate cells.<br>
Rob - Robusta<br>
Exc - Excelsa<br>
Ara - Arabica<br>
Lib - Liberica<br>

=IF(I2="Rob","Robusta",IF(I2="Exc","Excelsa",IF(I2="Ara","Arabica",IF(I2="Lib","Liberica",""))))<br>

![](https://github.com/VictoriaStetskevych/projects/blob/main/04_dashboard_coffee_sales_mo_chen/images/10_coffee_type.png?raw=true)

**'Orders' sheet > New column 'Roast Type Name'**

I added a new column "Roast Type Name" to write a full name for each type of roast, as it's much easier to understand a coffee roast type when it's written as a word, then just a letter (L,M or D).<br> 
I used IF function to populate cells in this column.<br>

=IF(J2="M","Medium",IF(J2="L","Light",IF(J2="D","Dark","")))<br>

![](https://github.com/VictoriaStetskevych/projects/blob/main/04_dashboard_coffee_sales_mo_chen/images/11_roast_type.png?raw=true)

## 3. Fomatting

**'Orders' sheet > 'Order Date' column formatting**

I changed a date formate to dd-mmm-yyyy.
![](https://github.com/VictoriaStetskevych/projects/blob/main/04_dashboard_coffee_sales_mo_chen/images/12_data_type.png?raw=true)
Result:<br>
![](https://github.com/VictoriaStetskevych/projects/blob/main/04_dashboard_coffee_sales_mo_chen/images/13_data_type_fixed.png?raw=true)

**'Orders' sheet > 'Size' column formatting**

I changed a 'Size' data formate to '0.0 "kg"'.
![](https://github.com/VictoriaStetskevych/projects/blob/main/04_dashboard_coffee_sales_mo_chen/images/14_size_format.png?raw=true)
Result:<br>
![](https://github.com/VictoriaStetskevych/projects/blob/main/04_dashboard_coffee_sales_mo_chen/images/15_size_format_fixed.png?raw=true)

**'Orders' sheet > 'Unit Price' and 'Sales' columns formatting**

I changed formate to 'Accounting Number Format > US dollars'.
![](https://github.com/VictoriaStetskevych/projects/blob/main/04_dashboard_coffee_sales_mo_chen/images/16_unit_sales.png?raw=true)
Result:<br>
![](https://github.com/VictoriaStetskevych/projects/blob/main/04_dashboard_coffee_sales_mo_chen/images/17_unit_sales_fixed.png?raw=true)

**Remove duplicates**

I also checked if the data has any duplicates to remove them. <br>
I did it with the following steps:<br>
- select all data<br>
- Data > Remove duplicates<br> 
- Press Enter<br>
![](https://github.com/VictoriaStetskevych/projects/blob/main/04_dashboard_coffee_sales_mo_chen/images/18_duplicates.png?raw=true)<br>
With the current data I got a message "No duplicate values found"<br>
![](https://github.com/VictoriaStetskevych/projects/blob/main/04_dashboard_coffee_sales_mo_chen/images/19_duplicates_result.png?raw=true)

**Convert an 'Orders' sheet range into an actual Table**

- click anywhere on a the table<br>
- Ctrl + T > press OK<br>
![](https://github.com/VictoriaStetskevych/projects/blob/main/04_dashboard_coffee_sales_mo_chen/images/20_table.png?raw=true)
- Change a table style (not necessary)<br>
![](https://github.com/VictoriaStetskevych/projects/blob/main/04_dashboard_coffee_sales_mo_chen/images/21_table_update.png?raw=true)

## 4. Pivot table #1 'Total Sales Over Time'

To add a Pivot Table 'Total Sales Over Time' I was using the following steps:<br>

Click anywhere on a table > Insert > Pivot Table<br>
![](https://github.com/VictoriaStetskevych/projects/blob/main/04_dashboard_coffee_sales_mo_chen/images/22_pivot_table_add.png?raw=true)  <br>
![](https://github.com/VictoriaStetskevych/projects/blob/main/04_dashboard_coffee_sales_mo_chen/images/23_pivot_table_add.png?raw=true)
![](https://github.com/VictoriaStetskevych/projects/blob/main/04_dashboard_coffee_sales_mo_chen/images/24_pivot_table.png?raw=true)

<text>1. Rows: Order Date <br>

<ins>To make dates to be grouped by year and month:<br></ins>

<text>2. Right Click > Group > Choose: Month and Year > OK<br>
<text>3. Design <br>
<text>4. Report Layout > Show in Tabular Form<br>
<text>5. Grand Totals > Off for Rows and Columns<br>
<text>6. Subtotals > Do not Show Subtotals<br>

<text>7. Columns: Coffee Type Name<br> 

8.Values: Sales<br>
9.Value Field Setting > Number Format > Number > Use 1000 Separator > Decimal places = 0 <br>

<text>10. Insert > Line Chart<br>

![](https://github.com/VictoriaStetskevych/projects/blob/main/04_dashboard_coffee_sales_mo_chen/images/25_total_sales_chart.png?raw=true)

<text>11. Right Click on any button on a chart > 'Hide all Field Buttons on Chart'<br>
<text>12. Formatted to make it user friendly. <br>

![](https://github.com/VictoriaStetskevych/projects/blob/main/04_dashboard_coffee_sales_mo_chen/images/26_total_sales_chart_updated.png?raw=true)

## 5. Time Line

<text>1. Select a chart 'Total Sales Over Time'<br>
<text>2. PivotChart Analyze > Insert Timeline > Order Date > OK<br>

![](https://github.com/VictoriaStetskevych/projects/blob/main/04_dashboard_coffee_sales_mo_chen/images/27_timeline.png?raw=true)

<text>3. Changed the Time Line style.  
   Timeline > Timeline Styles > New Timeline Style > 

![](https://github.com/VictoriaStetskevych/projects/blob/main/04_dashboard_coffee_sales_mo_chen/images/28_timeline_updated.png?raw=true)

## 6. Slicers

<text>1. Select a chart 'Total Sales Over Time'<br>
<text>2. PivotChart Analyze > Insert Slicer <br>
<text>> Roast Type Name<br>
<text>> Size<br>
<text>> Loyalty Card<br>
<text>> Coffee Type Name<br>
3. Changed the slicer style. 
![](https://github.com/VictoriaStetskevych/projects/blob/main/04_dashboard_coffee_sales_mo_chen/images/31_slicers.png?raw=true)

## 4. Pivot table #2 'Sales by Country'

I created a second pivot table by copying the first one and changing parameters. (Press Ctrl + Drag a sheet)<br>
Rows: Country<br>
Values: Sales (Sum of Sales)<br>

Insert > Bar Chart

I rearranged the order:<br>
Pivot Table > Sort (Country) > More Sort Option > Ascending order (Sum of Sales)

Formatted the 'Sales by Country' chart to look the same, as the previous chart. 

![](https://github.com/VictoriaStetskevych/projects/blob/main/04_dashboard_coffee_sales_mo_chen/images/29_country_chart.png?raw=true)

## 5. Pivot table #3 'Top 5 Customers'

I created a third pivot table by copying the second one and changing parameters.(Press Ctrl + Drag a sheet)<br>
Rows: Customer Name<br>
Values: Sales (Sum of Sales)<br>

Insert > Bar Chart

To make only Top 5 Customers<br>
Pivot Table > Sort (Customer Name) > Value Filters > Top 10 > Change to Top 5 

I rearranged the order:<br>
Pivot Table > Sort (Customer Name) > More Sort Option > Ascending by Sum of Sales

Formatted the 'Top 5 Customers' chart to look the same, as the previous charts. 

![](https://github.com/VictoriaStetskevych/projects/blob/main/04_dashboard_coffee_sales_mo_chen/images/30_customers_chart.png?raw=true)

## 6. Dashboard

To make a dashboard I:<br>
- added another sheet to the document,<br>
- renamed it as 'Dashboard',<br>
- inserted a shape (rectangle),<br>
- added a text 'COFFEE SALES DASHBOARD' to the shape, aligned it, changed text color, and size<br>
- added all charts and slicers from pivot tables to the dashboard (cut (Ctrl+X) > paste (Ctrl+V) )<br>
- rearranged / adjust all charts and slicers on a dashboard to look readable and easy to understand<br>
- made a connection between timeline, slicers and all charts<br>
Select timeline / slicer > Timeline / Slicer > Report Connections > Select all charts  <br>
- Removed gridlines<br>
View > Uncheck 'Gridlines' Checkbox<br>

This is a final result of this project: <br>

**Coffee Sales Dashboard:**<br>

[<video controls src="https://github.com/VictoriaStetskevych/projects/raw/refs/heads/main/04_dashboard_coffee_sales_mo_chen/dashboard_coffee_sales_mo_chen.mp4" title="Dashboard Coffee Sales"></video>](https://github.com/user-attachments/assets/61aeca15-c861-445c-9508-11e39602b732)

P.S.
Colors I used for this projects:

<table>
   <thead>
      <th>Color</th>
      <th>Color #</th>
      <th>Dashboard</th>
   </thead>
      <tr>
         <td>
         <svg width="20" height="20">
         <rect width="20" height="20" style="fill:#F5F5F5;" />
         </svg>
         </td>
         <td>#F5F5F5</td>
         <td>background</td>
      </tr>
      <tr>
         <td style="background-color:#58171D"></td>
         <td>#58171D</td>
         <td>Arabica</td>
      </tr>
      <tr>
         <td style="background-color:#D86A7C"></td>
         <td>#D86A7C</td>
         <td>Excelsa</td>
      </tr>
      <tr>
         <td style="background-color:#FFB011"></td>
         <td>#FFB011</td>
         <td>Robusta</td>
      </tr>
      <tr>
         <td style="background-color:#54B2A9"></td>
         <td>#54B2A9</td>
         <td>Liberica</td>
      </tr>
            <tr>
         <td style="background-color:#6F4E37"></td>
         <td>#6F4E37</td>
         <td>Timeline, slicers</td>
      </tr>
</table>

