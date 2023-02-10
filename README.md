# 
<h1> Cyclistic Bike - Share: How does a bike-share navigate speedy success? </h1>

<p> This project was made for the Google Analytics Professional Certificate in which I dicided to use the Cyclistic Bike - Share Data. </p>

<h3> About the Company: </h3>
<p> Cyclistic is a bike-share company located in Chicago (USA) that offers a variety of bike-share programs. Nowadays, the company manages more than 5,824 bicycles that are tracked and locked into a network of 692 stations across the state. Cyclistic offers different types of bikes and many pricing plans to attract mixed customer segments. 
<p> The princing plans offered by Cyclistic are: </p>
<li> Single - ride passes. </li>
<li> Full - day passes. </li>
<li> Annual Membership. </li> <br>
<p> Cyclistic’s finance analysts have concluded that annual members are much more profitable than casual riders. Until now, the marketing campaign focused on targeting new customers and creating general awareness. With this discovery, the Marketing Director decided to develop a new campaign aimed to convert casual riders into annual members. In order to do that, the marketing analyst team needs more clear understanding on how annual members and casual riders differ. </p>
<h3> Business Task: </h3>
<p> Analyze the data and provide insights about the differences between annual members' behavior and the casual riders. This recommendation will help the marketing team to design the new campaign. </p>
<h3> Tools: </h3>
<li> SQL Server Managment Studio. </li>
<li> Looker Studio. </li>
<li> Google Sheets. </li> 
<h3> About the Dataset: </h3>
<li> The data was provided by the course and the link to the website is: https://divvy-tripdata.s3.amazonaws.com/index.html 
(Additional information about the licence is available<a href="https://ride.divvybikes.com/data-license-agreement" target="_blank"> here</a>.)</li>
<li> We used 12 month of Cyclistic data from January, 2022 to December, 2022. </li>
<li> Each month has his own cvs file. In order to have all the data that we need, I'd to import 12 csv in one database called 'Cyclistic'. </li>
<li> We used all the columns in the cvs files. </li>
<h3> Preparing, Processing and Analyzing the Data: </h3>
<p> In the next part, I'll briefly describe what I did in each step. I recommend reading while checking the script here. (It's in Spanish because I didn't have time to translate my observations.) </p>
<h4> Preparing the Data: </h4>
<li> Import the cvs files into SQL Server Management Studio and create individual tables for each one. </li>
<li> I checked all 12 tables to be sure they had the same columns. Then I combined all the tables in one called 'Datos2022'. Note: I had some trouble using UNION to create the table. Because I hade little time, I decided to create an empty table and then insert the data for each month into it.   </li>
<h4> Processing the Data: </h4>
<li> I wanted to keep the date and the time separately for the 'started_at' and the 'ended_at' columns. So I created four new columns and kept the ones that I had. (I don't exactly know the purpose of why I did this, but I decided to keep going with the analysis and was too late to correct it.)</li>
<li> I wanted to calculate the duration for each ride, so I decided to create a new column called 'ride_length'. </li>
<li> I checked that were only two classes for the type of customers (member and casual), the range for latitude and longitude of the stations, and the ride_ids uniqueness. Note: I found some ride_ids repeated, so I decided to keep only one of them. </li>
<li> I checked for rows that contained NULL values or empty spaces. In the end, I deleted all the missing the rows that had missing data because they didn't represent a significant amount in the dataset. Note: I tried to complete the missing data (I could find a query to do that), but my computer wasn´t able to complete the query. </li>
<li> I search for rides that started and ended at the same time and date. I encounter some, so I decided to delete them because they weren't correct. </li>
<li> Finally, I checked the ride's length and encountered that some of them had a duration of 0. I delete them because that's not possible. Note: Some rides had a length of 0.1 seconds (that's not possible), but I decided to keep them. In reality, I'd had to check for rides that had at least 10 - 30 minutes). </li>
<h4> Analyzing the Data: </h4>
<li> Count the total number of rides, and number of rides made by casual customers and annual members.</li> 
<li> The types of bikes being offered and the number of rides made by each one. </li>
<li> The number of rides starting and ending at each docking station, and the number of round trips (sorted by the types of customer and types of bikes). </li>
<li> I calculated rides per month and day of the week for each membership type. </li>
<li> I calculated the maximum and minimum ride length, the average ride length for each membership type, and the average ride length per month for each membership type. </li>. 
<li> Finally, I created different tables for the visualization part of the project. Note: I had to do it this way because the dataset was too large to import directly to Looker Studio. </li>
<h3> Data Visualization using Looker Studio: </h3>
<p> If you have an account, you can look the dashboard from <a href="[https://ride.divvybikes.com/data-license-agreement](https://lookerstudio.google.com/s/lnejOF8JVCE )" target="_blank"> here</a>. But I'll leave the PDF file for those who don't. </p>
<p> If you have an account, you can look at the dashboard from here. But I'll leave the PDF file for those who don't. </p>
<p> To complete the project, I decided to create a short presentation addressed to the marketing team in which I left my insights and recommendations. I left the PDF file of it above (you can find it here for those who don't want to download it.)</p>





