## Sport Data Dashboard in Power BI

https://github.com/user-attachments/assets/367e75c1-0af2-451e-a337-86618fa5182a

This project was made using Bas Dohmen’s YouTube [tutorials](https://www.youtube.com/watch?v=cYwioeHu_OU&t=1041s).<br>

Goal: create a dashboard that displays key fitness metrics: steps, calories, heart rate, and exercise sessions for each individual. <br>

Unfortunately, the profile images were unavailable, so I followed these steps to add them to my dashboard:<br>

1. Downloaded profile images from Adobe Express [website](https://new.express.adobe.com/)<br>
2. Cropped all images using this [website](https://crop-circle.imageonline.co/). The images needed to have a transparent background.<br>
3. created an Excel [file](https://github.com/VictoriaStetskevych/projects/blob/main/PowerBI/02_power_bi_sport_dashboard/profile_images.xlsx) with a list of all users and added a link to each user's profile image.<br>
4. added this Excel file to the Power BI project's data<br>
![](https://github.com/VictoriaStetskevych/projects/blob/main/PowerBI/02_power_bi_sport_dashboard/images/01_add_excel_file.png?raw=true)<br>
5. Opened the Excel table in a Power BI 'Model View' to ensure there was a connection between User ID in the Excel file and User ID in the dimUser table.<br>
6. Opened the Excel table in a Power BI 'Table View' to make sure that the 'Data category' was set to 'Image URL' <br>
![](https://github.com/VictoriaStetskevych/projects/blob/main/PowerBI/02_power_bi_sport_dashboard/images/02_image_url.png?raw=true)<br>
6. Used photo links from the Excel file for visualizing profile images.<br>
