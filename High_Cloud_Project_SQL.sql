CREATE DATABASE Project_File;

USE Project_File;

ALTER TABLE maindata ADD Order_Date_Key DATE DEFAULT (CONCAT(Year,"-",Month,"-",Day));

## views
## KPI 1

CREATE VIEW KPI1 AS
SELECT
    Order_Date_Key,
    YEAR(Order_Date_Key) AS Year,
    MONTH(Order_Date_Key) AS Month,
    MONTHNAME(Order_Date_Key) AS Month_Name,
    CONCAT("Q",quarter(Order_Date_Key)) AS Quarter,
    DATE_FORMAT(Order_Date_Key,"%Y-%b") AS "Year_Month",
    DAYOFWEEK(Order_Date_Key) AS WeekDay_Number,
    DAYNAME(Order_Date_Key) AS Weekday_Name,
    CASE
        WHEN DAYOFWEEK(Order_Date_Key) IN(1,7)
        THEN "Weekend"
        ELSE "Weekday"
        END AS Weekday_Weekend,
    CASE
        WHEN MONTH(Order_Date_Key)>3
        THEN MONTH(Order_Date_Key)-3
        ELSE MONTH(Order_Date_Key)+9
        END AS Financial_Month,
    CASE
        WHEN MONTH(Order_Date_Key) BETWEEN 4 AND 6 THEN "Q1"
        WHEN MONTH(Order_Date_Key) BETWEEN 7 AND 9 THEN "Q2"
        WHEN MONTH(Order_Date_Key) BETWEEN 10 AND 12 THEN "Q3"
        ELSE "Q4"
        END AS Financial_Quarter
FROM maindata;

SELECT*FROM KPI1;


## KPI 2

##YEAR WISE LOAD FACTOR
CREATE VIEW YEAR_WISE_LOAD_FACTOR AS
SELECT
    YEAR(Order_Date_Key) AS YEAR,
    CONCAT(ROUND((SUM(Transported_Passengers)/SUM(Available_Seats))*100,2),"%") AS Load_Factor
FROM maindata
GROUP BY YEAR(Order_Date_Key)
ORDER BY Load_Factor DESC;

SELECT*FROM YEAR_WISE_LOAD_FACTOR;

##QUARTER WISE LOAD FACTOR
CREATE VIEW QUARTER_WISE_LOAD_FACTOR AS
SELECT
    CONCAT("Q",QUARTER(Order_Date_Key)) AS QUARTER,
    CONCAT(ROUND((SUM(Transported_Passengers)/SUM(Available_Seats))*100,2),"%") AS Load_Factor
FROM maindata
GROUP BY CONCAT("Q",QUARTER(Order_Date_Key))
ORDER BY Load_Factor DESC;

SELECT*FROM QUARTER_WISE_LOAD_FACTOR;

## MONTH WISE LOAD FACTOR
CREATE VIEW MONTH_WISE_LOAD_FACTOR AS
SELECT
    MONTHNAME(Order_Date_Key) AS Month_Name,
    CONCAT(ROUND((SUM(Transported_Passengers)/SUM(Available_Seats))*100,2),"%") AS Load_Factor
FROM maindata
GROUP BY MONTHNAME(Order_Date_Key)
ORDER BY Load_Factor DESC;

SELECT*FROM MONTH_WISE_LOAD_FACTOR;


## KPI 3

## Load Factor Based On Carrier Name
CREATE VIEW Load_Factor_Based_On_Carrier_Name AS
SELECT
    Carrier_Name,
    CONCAT(ROUND((SUM(Transported_Passengers)/SUM(Available_Seats))*100,2),"%") AS Load_Factor
FROM maindata
GROUP BY Carrier_Name
ORDER BY Load_Factor DESC;

SELECT*FROM Load_Factor_Based_On_Carrier_Name;


## KPI 4

## No_Of_Flights_Based_On_Carrier_Name
CREATE VIEW No_Of_Flights_Based_On_Carrier_Name AS
SELECT
    Carrier_Name,
    COUNT(Airline_ID) AS No_Of_Flights
FROM maindata
GROUP BY Carrier_Name
ORDER BY No_Of_Flights DESC;

SELECT*FROM No_Of_Flights_Based_On_Carrier_Name;

## KPI 5

## No_Of_Flights_Based_On_From_To_City_Routes
CREATE VIEW No_Of_Flights_Based_On_From_To_City_Routes AS
SELECT
    From_To_City,
    COUNT(Airline_ID) AS No_Of_Flights
FROM maindata
GROUP BY From_To_City
ORDER BY No_Of_Flights DESC;

SELECT*FROM No_Of_Flights_Based_On_From_To_City_Routes;


##KPI6

##Weekend vs Weekday based on load factor

CREATE VIEW Weekend_vs_Weekday_based_on_load_factor AS
SELECT
    kpi1.Weekday_Weekend,
    CONCAT(ROUND((SUM(Transported_Passengers)/SUM(Available_Seats))*100,2),"%") AS Load_Factor
FROM maindata m INNER JOIN kpi1 
ON m.Order_Date_Key=kpi1.Order_Date_Key
GROUP BY kpi1.Weekday_Weekend;

SELECT*FROM Weekend_vs_Weekday_based_on_load_factor;


## KPI 8

## No_Of_Flights_Based_On_Distance_Groups
CREATE VIEW No_Of_Flights_Based_On_Distance_Groups AS
SELECT
    D.Distance_Interval,
    COUNT(m.Airline_ID) AS No_Of_Flights
FROM maindata m INNER JOIN distance_groups D
ON m.Distance_Group_ID = D.ï»¿Distance_Group_ID
GROUP BY D.Distance_Interval
ORDER BY No_Of_Flights DESC;

SELECT*FROM No_Of_Flights_Based_On_Distance_Groups;


## KPI 7

## Flight details
CREATE VIEW Flight_Details AS
SELECT
    Airline_ID,
    Region_Code,
    Distance,
    Carrier_Name,
    Origin_Country,
    Origin_State,
    Origin_City,
    Origin_Airport_Code,
    Destination_Country,
    Destination_State,
    Destination_City,
    Destination_Airport_Code,
    Available_Seats,
    Transported_Passengers,
    Transported_Freight
FROM maindata;

SELECT*FROM Flight_Details;


## Stored procedures

## KPI 1

delimiter //
CREATE PROCEDURE KPI1()
BEGIN

        SELECT*FROM kpi1;

END//

CALL KPI1;