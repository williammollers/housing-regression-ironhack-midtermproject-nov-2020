#1. Create a database called house_price_regression.

#2. Create a table house_price_data with the same columns 
#as given in the csv file. Please make sure you use the 
#correct data types for the columns.

use house_price_regression;
drop table if exists house_price_data;
CREATE TABLE house_price_data (
  id bigint NOT NULL,
  dates date,
  bedrooms int NOT NULL,
  bathrooms float NOT NULL,
  sqft_living int NOT NULL,
  sqft_lot int NOT NULL,
  floors float NOT NULL,
  waterfront int NULL,
  views int NULL,
  conditions int NOT NULL,
  grade int NOT NULL,
  sqft_above int NOT NULL, 
  sqft_basement int NULL,
  yr_built int NOT NULL,
  yr_renovated int NULL,
  zipcode int NOT NULL,
  latitude float NOT NULL,
  longitude float NOT NULL,
  sqft_living15 int NOT NULL,
  sqft_lot15 int NOT NULL,
  price int NOT NULL
  );

#3. Import the data from the csv file into the table.
LOAD DATA LOCAL INFILE '/Users/williammollers/Desktop/DATA_ANALYTICS/IRONHACK/CLASS/PROJECTS/Mid_WAY_PROJECT - INDIVIDUAL WEEK 5/data_mid_bootcamp_project_regression/regression_data_clean2.csv'
#This may have to be adjusted, as your data source file will
#be different to mine.
INTO TABLE house_price_regression.house_price_data
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

#4 Select all the data from table house_price_data to check 
#if the data was imported correctly

use house_price_regression;
SELECT * FROM house_price_data;

#it looks bueno to me 

#5 Use the alter table command to drop the column date 
#from the database, as we would not use it in the analysis
#with SQL. Select all the data from the table to 
#verify if the command worked. 
#Limit your returned results to 10.

ALTER TABLE house_price_data DROP COLUMN dates;

SELECT * FROM house_price_data LIMIT 10;

#6 Use sql query to find how many rows of data you have.

SELECT COUNT(*) FROM house_price_data;

#21,597 rows

#7Now we will try to find the unique values in some of 
#the categorical columns:

#7a What are the unique values in the column bedrooms?
SELECT distinct bedrooms from house_price_data 
ORDER BY bedrooms;
#1-11 & 33

#7b What are the unique values in the column bathrooms?
SELECT distinct bathrooms from house_price_data 
ORDER BY bathrooms;
#1, 1.25, 1.5, 1.75, 2, 2.25, 2.5, 2.75, 3, 3.25, 3.5, 3.75,
# 4, 4.25, 4.5, 4,75, 5, 5.25, 5.5, 5.75, 6, 6.25, 6.5, 6.75
#7.5, 7.75, 8 


#7c What are the unique values in the column floors?
SELECT distinct floors from house_price_data 
ORDER BY floors;
#1, 1.5, 2, 2.5, 3, 3.5

#7d What are the unique values in the column condition?
SELECT distinct conditions from house_price_data 
ORDER BY conditions;
#1-5

#What are the unique values in the column grade?
SELECT distinct grade from house_price_data 
ORDER BY grade;
#3-13

#8 Arrange the data in a decreasing order by the price of 
#the house. Return only the IDs of the 
#top 10 most expensive houses in your data.

SELECT * FROM house_price_data ORDER BY price DESC LIMIT 10; 

#9 What is the average price of all the properties 
#in your data?

SELECT AVG (price) FROM house_price_data; 
#$540,296.57

#10 In this exercise we will use simple group by to check 
#the properties of some of the categorical variables 
#in our data

#10a 
#What is the average price of the houses grouped by 
#bedrooms? The returned result should have only two columns,
# bedrooms and Average of the prices. 
#Use an alias to change the name of the second column.

use house_price_regression;
SELECT bedrooms, AVG(price) as average_price 
FROM house_price_data
GROUP BY bedrooms
ORDER BY bedrooms;

#10b 
#What is the average sqft_living of the houses grouped 
#by bedrooms? 
#The returned result should have only two 
#columns, bedrooms and Average of the sqft_living. 
#Use an alias to change the name of the second column.

use house_price_regression;
SELECT bedrooms, AVG(sqft_living) as average_sqft_living 
FROM house_price_data
GROUP BY bedrooms
ORDER BY bedrooms;

#10c 
#What is the average price of the houses with a 
#waterfront and without a waterfront? 
#The returned result should have only two columns, 
#waterfront and Average of the prices. 
#Use an alias to change the name of the second column.

use house_price_regression;
SELECT waterfront, AVG(price) as average_price 
FROM house_price_data
GROUP BY waterfront;

#10d
#Is there any correlation between the columns condition 
#and grade? 
#You can analyse this by grouping the data by one of the 
#variables and then aggregating the results of the other 
#column. 
#Visually check if there is a positive correlation 
#or negative correlation or no correlation between the 
#variables.

use house_price_regression;
SELECT conditions, grade 
FROM house_price_data
ORDER BY conditions;

use house_price_regression;
SELECT conditions, AVG(grade) as average_grade
FROM house_price_data
GROUP BY conditions
ORDER BY conditions;

use house_price_regression;
SELECT grade, AVG(conditions) as average_conditions
FROM house_price_data
GROUP BY grade
ORDER BY grade;

#There is some correlation, but only up to a minimal point. 
#after condition 3, then the average_grade starts to decline
#which implies that they are perhaps rating different 
#things or potentially that the condition mark is wrong. 
#For later analysis, this would mean that I would
#probably drop conidition in pandas.

#One of the customers is only interested in the 
#following houses:
#Number of bedrooms either 3 or 4
#Bathrooms more than 3
#One Floor
#No waterfront
#Condition should be 3 at least
#Grade should be 5 at least
#Price less than 300000
#For the rest of the things, they are not too concerned. 
#Write a simple query to find what are the 
#options available for them?

SELECT bedrooms, bathrooms, floors, waterfront, 
conditions, grade, price FROM house_price_data
WHERE (bedrooms = 3 OR bedrooms = 4) AND bathrooms >= 3 
AND floors = 1 AND waterfront = 0 AND
conditions >= 3 AND grade >= 5 and price < 300000 
ORDER BY price DESC;

#12 Your manager wants to find out the list of properties
# whose prices are twice more than the average of all 
#the properties in the database. 
#Write a query to show them the list of such properties. 
#You might need to use a sub query for this problem. 

use house_price_regression;

SELECT * FROM house_price_data
WHERE price >= 2*( 
	SELECT round(avg(price)) FROM house_price_data 
	)
    ORDER BY price DESC;
    
#13 Since this is something that the senior management is 
#regularly interested in, create a view of the same query.

use house_price_regression;
CREATE VIEW double_avg_price_or_more AS
SELECT * FROM house_price_data
WHERE price >= 2*( 
	SELECT round(avg(price)) FROM house_price_data 
	)
    ORDER BY price DESC;
    

#14 Most customers are interested in properties with 
#three or four bedrooms. What is the difference in 
#average prices of the properties with three and 
#four bedrooms?

SELECT ROUND(AVG(price)) FROM house_price_data
WHERE bedrooms = 3;

SELECT ROUND(AVG(price)) FROM house_price_data
WHERE bedrooms = 4;

#doing it manually you get an answer of 
#635565 - 466277 = 169,288

#I will be honest here and say I didn't know how to do this
#but like any smart analyst I asked a colleague for help
#Muchas Gracias Maria! 

SELECT b.average_price4 - a.average_price3 AS 
difference_in_average_prices
FROM (
SELECT ROUND(AVG(price),2) AS average_price4
FROM house_price_data
WHERE bedrooms = 4) b
CROSS JOIN
(SELECT ROUND(AVG(price),2) AS average_price3
FROM house_price_data
WHERE bedrooms = 3) a;



#15 What are the different locations where properties are 
#available in your database?

use house_price_regression;
SELECT distinct zipcode FROM house_price_data
ORDER BY zipcode;

#The houses are all in Washington state near to Seattle. 

#16 Show the list of all the properties that were renovated.

#as in the definitions sqft_lot15 and sqft_living15 imply
#some renovations, this ended up leading to pretty much 
#all of the properties being included if even a partial 
#renovation is included. 

SELECT * FROM house_price_data
WHERE yr_renovated > 0 OR sqft_living15 > 0 
OR sqft_lot15 > 0
ORDER BY price DESC;

#If, however, you count just a full renovation year then the 
#amount of properties that are listed reduces quite a lot:

SELECT * FROM house_price_data
WHERE yr_renovated > 0 
ORDER BY price DESC;

#17 Provide the details of the property that is the 11th 
#most expensive property in your database.

SELECT * FROM house_price_data
ORDER by price DESC;

#quick and easy way is to collect all the records,
#sort by price and limit to 11and manually look. 
#Takes about 15 seconds
#6065300370 is the idea of the 11th most expensive property
#The issue with this, however, is that it is not a lookup,
#so you must do this manually

SELECT * FROM house_price_data
ORDER by price DESC
LIMIT 11;


#more elegant way to do it. 
SELECT * FROM (
SELECT *,
RANK() OVER (ORDER BY price DESC) AS Position
FROM house_price_data
LIMIT 11) a
WHERE Position = 11;


