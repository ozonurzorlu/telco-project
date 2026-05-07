-- ============================================================================
-- 1. Tariff-Based Customer Queries
-- ============================================================================

-- 1.1 List the customers who are subscribed to the 'Kobiye Destek' tariff.
/*
I utilized an INNER JOIN to connect the CUSTOMERS and TARIFFS tables based on their shared TARIFF_ID. 
This allows me to access both the customer details and the specific name of their subscribed tariff. 
Finally, I applied a WHERE clause to filter the results exactly to the 'Kobiye Destek' tariff.
*/
SELECT c.CUSTOMER_ID, c.NAME, c.CITY, t.NAME as TARIFF_NAME
FROM CUSTOMERS c
JOIN TARIFFS t ON c.TARIFF_ID = t.TARIFF_ID
WHERE t.NAME = 'Kobiye Destek';


-- 1.2 Find the newest customer who subscribed to this tariff.
/*
To find the newest customer, I first selected the customers subscribed to 'Kobiye Destek' and ordered them by SIGNUP_DATE in descending order. 
Since Oracle XE does not support the LIMIT clause, I wrapped this ordered dataset in a subquery. 
Then, I used the ROWNUM pseudocolumn in the outer query to extract only the very first row, which represents the most recent signup.
*/
SELECT * FROM (
    SELECT c.CUSTOMER_ID, c.NAME, c.SIGNUP_DATE
    FROM CUSTOMERS c
    JOIN TARIFFS t ON c.TARIFF_ID = t.TARIFF_ID
    WHERE t.NAME = 'Kobiye Destek'
    ORDER BY c.SIGNUP_DATE DESC
)
WHERE ROWNUM = 1;


-- ============================================================================
-- 2. Tariff Distribution
-- ============================================================================

-- 2.1 Find the distribution of tariffs among the customers.
/*
I performed a LEFT JOIN starting from the TARIFFS table to ensure all tariffs are listed, even those currently without any subscribed customers. 
I then utilized the GROUP BY clause on the tariff name to aggregate the customer data for each specific plan. 
Finally, the COUNT function was applied to the CUSTOMER_ID to calculate the total number of users per tariff, ordering the result from most to least popular.
*/
SELECT t.NAME AS TARIFF_NAME, COUNT(c.CUSTOMER_ID) AS TOTAL_CUSTOMERS
FROM TARIFFS t
LEFT JOIN CUSTOMERS c ON t.TARIFF_ID = c.TARIFF_ID
GROUP BY t.NAME
ORDER BY TOTAL_CUSTOMERS DESC;


-- ============================================================================
-- 3. Customer Signup Analysis
-- ============================================================================

-- 3.1 Identify the earliest customers to sign up.
/*
First, I used a subquery to find the absolute minimum signup date from the CUSTOMERS table.
Then, I filtered the main CUSTOMERS table using this minimum date to ensure I catch all customers who signed up on that exact day.
This approach is crucial because the earliest customer might not necessarily have the lowest ID in the database due to potential data insertion orders.
*/
SELECT CUSTOMER_ID, NAME, SIGNUP_DATE 
FROM CUSTOMERS 
WHERE SIGNUP_DATE = (SELECT MIN(SIGNUP_DATE) FROM CUSTOMERS);


-- 3.2 Find the distribution of these earliest customers across different cities.
/*
I built upon the previous query by isolating the earliest customers using the exact same subquery logic for the minimum signup date.
After filtering the records, I utilized the GROUP BY clause on the CITY column to categorize these early adopters based on their locations.
Finally, I applied the COUNT function to calculate the total number of earliest customers in each city and ordered them in descending order.
*/
SELECT CITY, COUNT(CUSTOMER_ID) AS CUSTOMER_COUNT 
FROM CUSTOMERS 
WHERE SIGNUP_DATE = (SELECT MIN(SIGNUP_DATE) FROM CUSTOMERS) 
GROUP BY CITY 
ORDER BY CUSTOMER_COUNT DESC;


-- ============================================================================
-- 4. Missing Monthly Records
-- ============================================================================

-- 4.1 Identify the IDs of missing customers who have no monthly records.
/*
To find customers without monthly usage statistics, I performed a LEFT JOIN between the CUSTOMERS and MONTHLY_STATS tables.
By establishing the join condition on CUSTOMER_ID, all customers are retrieved regardless of whether they have matching stats.
Applying a WHERE clause that checks if the CUSTOMER_ID from the MONTHLY_STATS table IS NULL effectively isolates the missing records.
*/
SELECT c.CUSTOMER_ID, c.NAME 
FROM CUSTOMERS c 
LEFT JOIN MONTHLY_STATS s ON c.CUSTOMER_ID = s.CUSTOMER_ID 
WHERE s.CUSTOMER_ID IS NULL;


-- 4.2 Find the distribution of these missing customers across different cities.
/*
I used the same LEFT JOIN strategy to isolate the customers who are missing from the MONTHLY_STATS dataset.
Instead of just listing them, I grouped the results by the CITY column from the CUSTOMERS table to see regional patterns.
Using the COUNT function, I tallied the number of missing records per city to help the technical team identify any location-based insertion errors.
*/
SELECT c.CITY, COUNT(c.CUSTOMER_ID) AS MISSING_COUNT 
FROM CUSTOMERS c 
LEFT JOIN MONTHLY_STATS s ON c.CUSTOMER_ID = s.CUSTOMER_ID 
WHERE s.CUSTOMER_ID IS NULL 
GROUP BY c.CITY 
ORDER BY MISSING_COUNT DESC;


-- ============================================================================
-- 5. Usage Analysis
-- ============================================================================

-- 5.1 Find the customers who have used at least 75% of their data limit.
/*
I joined the CUSTOMERS, TARIFFS, and MONTHLY_STATS tables to bring together usage data and package limits.
To calculate the 75% threshold, I multiplied the DATA_LIMIT from the TARIFFS table by 0.75 within the WHERE clause.
The query then checks if the customer's DATA_USAGE is greater than or equal to this calculated threshold value.
*/
SELECT c.CUSTOMER_ID, c.NAME, s.DATA_USAGE, t.DATA_LIMIT 
FROM CUSTOMERS c 
JOIN TARIFFS t ON c.TARIFF_ID = t.TARIFF_ID 
JOIN MONTHLY_STATS s ON c.CUSTOMER_ID = s.CUSTOMER_ID 
WHERE s.DATA_USAGE >= (t.DATA_LIMIT * 0.75);


-- 5.2 Identify the customers who have completely exhausted all of their package limits.
/*
I connected the necessary tables using INNER JOIN operations to compare each customer's monthly statistics against their tariff limits.
I constructed a WHERE clause using the AND operator to ensure all three conditions (Data, Minutes, and SMS) are evaluated simultaneously.
The query filters for records where the usage values are greater than or equal to their respective limits provided in the TARIFFS table.
*/
SELECT c.CUSTOMER_ID, c.NAME 
FROM CUSTOMERS c 
JOIN TARIFFS t ON c.TARIFF_ID = t.TARIFF_ID 
JOIN MONTHLY_STATS s ON c.CUSTOMER_ID = s.CUSTOMER_ID 
WHERE s.DATA_USAGE >= t.DATA_LIMIT 
  AND s.MINUTE_USAGE >= t.MINUTE_LIMIT 
  AND s.SMS_USAGE >= t.SMS_LIMIT;


-- ============================================================================
-- 6. Payment Analysis
-- ============================================================================

-- 6.1 Find the customers who have unpaid fees.
/*
I established a relationship between the CUSTOMERS and MONTHLY_STATS tables using their common CUSTOMER_ID field.
I applied a filter on the PAYMENT_STATUS column to isolate records that contain the string value indicating an unpaid status.
The UPPER function can optionally be used here to ensure the filter works regardless of case sensitivity in the dataset.
*/
SELECT c.CUSTOMER_ID, c.NAME, s.PAYMENT_STATUS 
FROM CUSTOMERS c 
JOIN MONTHLY_STATS s ON c.CUSTOMER_ID = s.CUSTOMER_ID 
WHERE UPPER(s.PAYMENT_STATUS) = 'UNPAID';


-- 6.2 Find the distribution of all payment statuses across the different tariffs.
/*
I joined all three tables (CUSTOMERS, TARIFFS, MONTHLY_STATS) to access both tariff names and customer payment statuses.
I utilized the GROUP BY clause on both the TARIFF_NAME and PAYMENT_STATUS columns to create a detailed multidimensional distribution.
Finally, the COUNT function calculates how many customers fall into each specific payment status category per tariff.
*/
SELECT t.NAME AS TARIFF_NAME, s.PAYMENT_STATUS, COUNT(c.CUSTOMER_ID) AS STATUS_COUNT 
FROM CUSTOMERS c 
JOIN TARIFFS t ON c.TARIFF_ID = t.TARIFF_ID 
JOIN MONTHLY_STATS s ON c.CUSTOMER_ID = s.CUSTOMER_ID 
GROUP BY t.NAME, s.PAYMENT_STATUS 
ORDER BY t.NAME, STATUS_COUNT DESC;
