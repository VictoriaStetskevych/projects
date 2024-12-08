This project was made using Alex Freberg's YouTube [tutorial](https://www.youtube.com/watch?v=opJgMj1IUrc).

The tasks for this project are:
 - clean data 
 - analyze data
 - create a dashboard using Pivot Tables

 I made this project in Google Spreadsheets.

 # 1. Duplicate a raw data.

> [!TIP]
> Always make a duplicate! Never work with an original file! .
 
 - I made a copy of the original (raw) data file 
 (Right click on a sheet > Duplicate) 
 - Renamed a new sheet as a "working_sheet" (Double click on a sheet's name).
 Since then, I was working with a duplicate .

# 2. Begin exploring the data

I added a filter to have a first look at the data.
I did it through the toolbar: Select a top row > choose a filter icon or
Though the menu: Data > Create a filter

---------------------- add image 02_filter ---------------

3. Remove duplicates.
I do this with following steps:
    1. Select data range
    2. Data > Data cleanup > Remove duplicates 
    3. Check that selected data range has a header row.
    4. Press 'Remove Duplicates'.

---------------------- add image 03_remove_duplicates ---------------

Result: 26 duplicate rows found and removed
---------------------- add image 04_remove_duplicates_result ---------------

4. Cleaning data

Columns B and C ('Marital Status' and 'Gender') use the same type of letters to represent different data >
For example: Letter M in both these columns represents 'M'(male) and 'M'(married).
So, I'm going to change how the data represents in these two columns:

Select Column B 'Marital Status' > Ctrl+H ('Find and Replace')
Find M > Replace with Married
Find S > Replace with Single
Replace All

Select Column C 'Gender' > Ctrl+H ('Find and Replace')
Find M > Replace with Male
Find F > Replace with Female
Replace All

Done!
---------------------- add image 05_colunm_b ---------------

Column D 'Income'.
I'm not going to do any changes, only remove decimals as all numbers in this column are whole numbers.

Column J 'Commute Distance'.
I'm going to change the name '10+ Miles' to 'More than 10 Miles' (Ctrl+H), as I'll help me to order properly data in Pivot Tables.

Column L 'Age' has age data. It is represented individually, not as a range.
So, I'm going to create a new column 'Age Brackets' and divide all people in my data in different groups by age:
< 31 - Adolescents
31 - 54 - Middle Age
> 55 - Old
To do that in a new column 'Age Brackets' I will add the next formula:
=IF(L2>54, "Old", IF(L2>=31, "Middle Age", IF(L2<31, "Adolescents", "Invalid")))

---------------------- add image  06_age_brackets ---------------

5. Pivot table

I add a pivot table with following steps:
Insert > Pivot Table > Select a data range (Ctrl+A) > Insert to New Sheet

---------------------- add image  07_add_pivot_table ---------------
Result:                                                            
---------------------- add image  08_pivot_table ---------------



I add next settings for a first pivot table:
Rows > Gender
Columns > Purchased Bikes
Values > Income > Summarize by AVERAGE

---------------------- add image  09_pivot_table ---------------

Now I add a chart for that table and add some additions to it to make the data more readable 
Insert > Chart > Column

---------------------- add image  10_pivot_table_2 ---------------


Using the same steps I add a second pivot table into the same sheet.

I add next settings for a second pivot table:
Rows > Commute Distance
Columns > Purchased Bikes
Values > Purchased Bikes

Now I add a chart for that table and add some additions to it to make the data more readable 
Insert > Chart > Line

---------------------- add image  11_pivot_table_3 ---------------

Using the same steps I add a third pivot table into the same sheet.

I add next settings for a second pivot table:
Rows > Age Brackets
Columns > Purchased Bikes
Values > Purchased Bikes

Now I add a chart for that table and add some additions to it to make the data more readable 
Insert > Chart > Line 

---------------------- add image  12_pivot_table_4 ---------------