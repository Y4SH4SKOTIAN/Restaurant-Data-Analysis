create database hotel ;
use hotel ;
select * from dataset;

ALTER TABLE dataset
CHANGE `ï»¿Restaurant ID` restaurant_id INT;

ALTER TABLE dataset
CHANGE `Price range` price_range INT;

SELECT
COUNT(*) AS total_rows,
SUM(CASE WHEN City IS NULL OR City = '' THEN 1 ELSE 0 END) AS city_missing,
SUM(CASE WHEN Cuisines IS NULL OR Cuisines = '' THEN 1 ELSE 0 END) AS cuisines_missing,
SUM(CASE WHEN `Aggregate rating` IS NULL THEN 1 ELSE 0 END) AS rating_missing,
SUM(CASE WHEN Votes IS NULL THEN 1 ELSE 0 END) AS votes_missing
FROM dataset;

DELETE FROM dataset
WHERE Cuisines IS NULL OR Cuisines = '';

SELECT COUNT(*) 
FROM dataset
WHERE Cuisines IS NULL OR Cuisines = '';

UPDATE dataset
SET `Aggregate rating` = 0
WHERE `Aggregate rating` IS NULL;

UPDATE dataset
SET Votes = 0
WHERE Votes IS NULL;

UPDATE dataset
SET `Has Online delivery` = 'No'
WHERE `Has Online delivery` IS NULL;

UPDATE dataset
SET `Has Table booking` = 'No'
WHERE `Has Table booking` IS NULL;

DELETE FROM dataset
WHERE City IS NULL OR Cuisines IS NULL;

SELECT
COUNT(*) AS total_rows,
SUM(CASE WHEN Cuisines IS NULL THEN 1 ELSE 0 END) AS null_rows,
SUM(CASE WHEN TRIM(Cuisines) = '' THEN 1 ELSE 0 END) AS blank_rows
FROM dataset;

SELECT COUNT(*) AS weird_rows
FROM dataset
WHERE LENGTH(TRIM(Cuisines)) < 3;

SELECT Cuisines
FROM dataset
WHERE LENGTH(TRIM(Cuisines)) < 3;





-- Task 1 — Top 3 Cuisines 

SELECT TRIM(cuisine) AS cuisine, COUNT(*) AS total
FROM dataset,
JSON_TABLE(
    CONCAT('["', REPLACE(Cuisines, ', ', '","'), '"]'),
    '$[*]' COLUMNS (cuisine VARCHAR(100) PATH '$')
) AS jt
GROUP BY cuisine
ORDER BY total DESC
LIMIT 3;


-- Percentage of each top cuisine
WITH cuisine_counts AS (
SELECT TRIM(cuisine) AS cuisine, COUNT(*) AS total
FROM dataset,
JSON_TABLE(
    CONCAT('["', REPLACE(Cuisines, ', ', '","'), '"]'),
    '$[*]' COLUMNS (cuisine VARCHAR(100) PATH '$')
) jt
GROUP BY cuisine
)

-- Task 2 — City Analysis
-- City with most restaurants
SELECT City, COUNT(*) AS total
FROM dataset
GROUP BY City
ORDER BY total DESC
LIMIT 1;

-- Average rating per city
SELECT City, ROUND(AVG(`Aggregate rating`),2) AS avg_rating
FROM dataset
GROUP BY City;

-- Highest rated city
SELECT City, ROUND(AVG(`Aggregate rating`),2) AS avg_rating
FROM dataset
GROUP BY City
ORDER BY avg_rating DESC
LIMIT 1;

-- Task 3 — Price Range Distribution
-- Count per price range
SELECT price_range, COUNT(*) AS total
FROM dataset
GROUP BY price_range
ORDER BY price_range;

-- Percentage per price range
SELECT price_range,
ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM dataset),2) AS percentage
FROM dataset
GROUP BY price_range
ORDER BY price_range;

-- Task 4 — Online Delivery
-- Delivery percentage
SELECT `Has Online delivery`,
ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM dataset),2) AS percentage
FROM dataset
GROUP BY `Has Online delivery`;

-- Average rating with vs without delivery
SELECT `Has Online delivery`,
ROUND(AVG(`Aggregate rating`),2) AS avg_rating
FROM dataset
GROUP BY `Has Online delivery`;

 -- LEVEL 2
-- Task 1 — Ratings + Votes
-- Rating distribution
SELECT `Aggregate rating`, COUNT(*) 
FROM dataset
GROUP BY `Aggregate rating`
ORDER BY `Aggregate rating`;

-- Average votes
SELECT ROUND(AVG(Votes),2) AS avg_votes
FROM dataset;

-- Task 2 — Cuisine Combinations
SELECT Cuisines, COUNT(*) AS total
FROM dataset
GROUP BY Cuisines
ORDER BY total DESC
LIMIT 5;

-- Higher-rated combos
SELECT Cuisines, ROUND(AVG(`Aggregate rating`),2) AS avg_rating
FROM dataset
GROUP BY Cuisines
HAVING COUNT(*) > 10
ORDER BY avg_rating DESC
LIMIT 5;

-- Task 3 — Geographic Analysis
SELECT Latitude, Longitude
FROM dataset
WHERE Latitude IS NOT NULL;

-- Task 4 — Restaurant Chains
SELECT `Restaurant Name`, COUNT(*) AS branches
FROM dataset
GROUP BY `Restaurant Name`
HAVING branches > 1
ORDER BY branches DESC
LIMIT 10;

-- Ratings by chain:

SELECT `Restaurant Name`,
ROUND(AVG(`Aggregate rating`),2) AS avg_rating
FROM dataset
GROUP BY `Restaurant Name`
HAVING COUNT(*) > 1
ORDER BY avg_rating DESC;

-- LEVEL 3
-- Votes Analysis
-- Highest / lowest votes
SELECT `Restaurant Name`, Votes
FROM dataset
ORDER BY Votes DESC
LIMIT 1;
SELECT `Restaurant Name`, Votes
FROM dataset
ORDER BY Votes ASC
LIMIT 1;

-- Votes vs Rating
SELECT Votes, `Aggregate rating`
FROM dataset;

-- Price vs Delivery / Table Booking
SELECT price_range, `Has Online delivery`, COUNT(*) AS total
FROM dataset
GROUP BY price_range, `Has Online delivery`;

-- Price vs Table Booking
SELECT price_range, `Has Table booking`, COUNT(*) AS total
FROM dataset
GROUP BY price_range, `Has Table booking`;