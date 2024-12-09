# Pivot Tables and Dashboard in Google Sheets 

This project was made using Alex Freberg's YouTube [tutorial](https://www.youtube.com/watch?v=opJgMj1IUrc).

The tasks for this project are:
 - clean data 
 - analyze data
 - create a dashboard using Pivot Tables

 I made this project in Google Spreadsheets.
 This is the final result:
 ![](https://raw.githubusercontent.com/VictoriaStetskevych/projects/refs/heads/main/02_bike_sales_alex_the_analyst/images/13_dashboards.png)

# PROCESS

 ## 1. Duplicate a raw data.

> [!TIP]
> Always make a duplicate! Never work with an original file! .
 
 - I made a copy of the original (raw) data file 
 (Right click on a sheet > Duplicate) 
 - Renamed a new sheet as a "working_sheet" (Double click on a sheet's name).
 Since then, I was working with a duplicate .

## 2. Begin exploring the data

I added a filter to have a first look at the data.
I did it through the toolbar: Select a top row > choose a filter icon or
Though the menu: Data > Create a filter

![](https://raw.githubusercontent.com/VictoriaStetskevych/projects/refs/heads/main/02_bike_sales_alex_the_analyst/images/02_filter.png)

## 3. Remove duplicates.
To remove duplicates I did following steps:
    1. Select data range (Ctrl+A)
    2. Data > Data cleanup > Remove duplicates 
    3. Check the box 'Data has header row'.
    4. Press 'Remove Duplicates'.

![](https://raw.githubusercontent.com/VictoriaStetskevych/projects/refs/heads/main/02_bike_sales_alex_the_analyst/images/03_remove_duplicates.png)

Result '26 duplicate rows found and removed':
![](https://raw.githubusercontent.com/VictoriaStetskevych/projects/refs/heads/main/02_bike_sales_alex_the_analyst/images/04_remove_duplicates_result.png)

## 4. Cleaning data

**Columns B and C** ('Marital Status' and 'Gender') use the same letter to represent different meaning of data.<br>
For example: Letter M in both these columns represents 'M'(male) and 'M'(married).<br>
So, I changed how the data is represented in these two columns:

**Column B 'Marital Status'** (M - Married, S - Single).<br>
Select Column B 'Marital Status' > Ctrl+H ('Find and Replace')<br>
Find M > Replace with Married<br>
Find S > Replace with Single<br>
Replace All

![](https://raw.githubusercontent.com/VictoriaStetskevych/projects/refs/heads/main/02_bike_sales_alex_the_analyst/images/05_colunm_b.png)

I used the same method for the **Column C 'Gender'**: M - Male, F - Female.<br>
Select Column C 'Gender' > Ctrl+H ('Find and Replace')<br>
Find M > Replace with Male<br>
Find F > Replace with Female<br>
Replace All

**Column D 'Income'**.<br>
I didn't do any changes, just removed decimals, as all numbers in this column are whole numbers.

**Column J 'Commute Distance'**.<br>
I changed the name '10+ Miles' to 'More than 10 Miles' (Ctrl+H), as this step would help me to properly order data in Pivot Tables.

**Column L 'Age'**.<br> 
All ages represented individually, not as a range.
So, I created a new column 'Age Brackets' and divided all people in my data in three different groups:<br>
\< 31 - Adolescents<br>
31 - 54 - Middle Age<br>
\>55 - Old<br>

To do that in a new column 'Age Brackets' I added the next formula:<br>
=IF(L2>54, "Old", IF(L2>=31, "Middle Age", IF(L2<31, "Adolescents", "Invalid")))

![](https://raw.githubusercontent.com/VictoriaStetskevych/projects/refs/heads/main/02_bike_sales_alex_the_analyst/images/06_age_brackets.png)

## 5. Pivot table

**Pivot Table 1.**

I added pivot tables with following steps:<br>
Insert > Pivot Table > Select a data range (Ctrl+A) > Insert to New Sheet.

![](https://raw.githubusercontent.com/VictoriaStetskevych/projects/refs/heads/main/02_bike_sales_alex_the_analyst/images/07_add_pivot_table.png)
Result:
![](https://raw.githubusercontent.com/VictoriaStetskevych/projects/refs/heads/main/02_bike_sales_alex_the_analyst/images/08_pivot_table.png)


I added next settings for a first pivot table:<br>
Rows > Gender<br>
Columns > Purchased Bikes<br>
Values > Income > Summarize by AVERAGE<br>
![](https://raw.githubusercontent.com/VictoriaStetskevych/projects/refs/heads/main/02_bike_sales_alex_the_analyst/images/09_pivot_table_1.png)

I added a chart for that table and some additions to it to make the data more readable <br>
Insert > Chart > Column<br>
![](https://raw.githubusercontent.com/VictoriaStetskevych/projects/refs/heads/main/02_bike_sales_alex_the_analyst/images/10_pivot_table_2.png)

**Pivot Table 2.**

Using the same steps as before I added a second pivot table into the same sheet.

I added next settings for a second pivot table:<br>
Rows > Commute Distance<br>
Columns > Purchased Bikes<br>
Values > Purchased Bikes

I also added a chart for that table and some additions to it to make the data more readable<br> 
Insert > Chart > Line<br>
![](https://raw.githubusercontent.com/VictoriaStetskevych/projects/refs/heads/main/02_bike_sales_alex_the_analyst/images/11_pivot_table_3.png)

**Pivot Table 3.**

Using the same steps as before I added a third pivot table into the same sheet.

I added next settings for a second pivot table:<br>
Rows > Age Brackets<br>
Columns > Purchased Bikes<br>
Values > Purchased Bikes<br>

I also added a chart for the third table and added some additions to it to make the data more readable.<br> 
Insert > Chart > Line 
![](https://raw.githubusercontent.com/VictoriaStetskevych/projects/refs/heads/main/02_bike_sales_alex_the_analyst/images/12_pivot_table_4.png)

## 5. Dashboard

To make a Dashboard I added a new sheet, and renamed it as 'Dashboard'.<br> 
In this new sheet I added all pivot tables and charts that I made.
I rearranged all tables, charts to look nice, understandable, readable.

I added slicers to my charts to have a possibility to choose different parameters.<br>
- Select a chart<br>
- Data > Add a slicer<br>
- Choose a Data Range (full data range)<br>
- Choose a Column. <br>
This slicer is going to be an interactive filter to all charts.

I added 4 slicers to have a variety of different filters:<br>
- Gender<br>
- Marital Status <br>
- Amount of cars <br>
- Age Brackets <br>

This is the way my dashboard looks. <br>
 ![](https://raw.githubusercontent.com/VictoriaStetskevych/projects/refs/heads/main/02_bike_sales_alex_the_analyst/images/13_dashboards.png)