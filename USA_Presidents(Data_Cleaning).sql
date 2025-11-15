SELECT *
FROM usa_presidents;

--  first thing i want to do is create a staging table. This is the one i will work in and clean the data. We want a table with the raw data in case something happens

CREATE TABLE usa_presidents_staging
LIKE usa_presidents;

SELECT *
FROM usa_presidents_staging;

INSERT usa_presidents_staging
SELECT *
FROM usa_presidents;

-- now when we are data cleaning we usually follow a few steps
-- 1. check for duplicates and remove any
-- 2. standardize data and fix errors
-- 3. Look at null values, blanks and see what 
-- 4. remove any columns and rows that are not necessary - few ways
-- It would be better to start with checking duplicates but i noticed there was some columns that needed to be dropped so as not to make the data cleaning process hard -- 

SELECT * 
FROM usa_presidents_staging;

ALTER TABLE usa_presidents_staging
DROP COLUMN MyUnknownColumn;

ALTER TABLE usa_presidents_staging
DROP COLUMN prior;

ALTER TABLE usa_presidents_staging
DROP COLUMN date_created;

ALTER TABLE usa_presidents_staging
DROP COLUMN date_updated;

ALTER TABLE usa_presidents_staging
DROP COLUMN salary;

-- CHECKING FOR DUPLICATES--

WITH duplicate_cte AS
( 
SELECT *,
ROW_NUMBER() OVER(PARTITION BY S_No, President, Political_Party,
Vice_President ,salary) AS row_num
FROM usa_presidents_staging
)
SELECT * 
FROM duplicate_cte 
WHERE row_num > 1
;

-- I manually searched for duplicates that the row_num couldn't find( i knew this already from cleaning it in Excel) and fixed it so that MySql could recognise the duplicates --

UPDATE usa_presidents_staging
SET Political_Party = 'Democratic'
WHERE Political_Party = 'Demorcatic'
;

-- had to create another staging table so as to be able to fix the duplicates --

CREATE TABLE `usa_presidents_staging1` (
  `S_No` int DEFAULT NULL,
  `President` text,
  `Political_Party` text,
  `Vice_President` text,
  `salary` text,
  row_num INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


INSERT INTO usa_presidents_staging1
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY S_No, President, Political_Party, Vice_President,salary ) AS row_num
FROM usa_presidents_staging
;

SELECT *
FROM usa_presidents_staging1
WHERE row_num > 1;

DELETE
FROM usa_presidents_staging1
WHERE row_num > 1;

-- I dropped some unneccesary columns and added new ones -- 

ALTER TABLE usa_presidents_staging1
DROP COLUMN salary;

ALTER TABLE usa_presidents_staging1
ADD Annual_Salary decimal(10,2);

ALTER TABLE usa_presidents_staging1
ADD Term VARCHAR(20);
  
ALTER TABLE usa_presidents_staging1
DROP COLUMN row_num;

SELECT *
FROM usa_presidents_staging1;

-- i noticed the data was not up to date and updated it--

INSERT INTO usa_presidents_staging1 (S_No, President, Political_Party, Vice_President, Annual_Salary)
VALUES (46, 'Joe Biden', 'Democratic', 'Kamala Harris', 400000.00 );


INSERT INTO usa_presidents_staging1 (S_No, President, Political_Party, Vice_President, Annual_Salary)
VALUES (47, 'Donald Trump', 'Republican', 'JD Vance', 400000.00 );

-- Adding the relevant data into the new columns i added --

UPDATE usa_presidents_staging1
SET Term = CASE S_No
WHEN 1 THEN '1789–1797'
WHEN 2 THEN '1797–1801'
WHEN 3 THEN '1801–1809'
WHEN 4 THEN '1809–1817'
WHEN 5  THEN '1817–1825'
WHEN 6 THEN '1825–1829'
WHEN 7 THEN '1829–1837'
WHEN 8 THEN '1837–1841'
WHEN 9 THEN '1841'
WHEN 10 THEN '1841–1845'
WHEN 11 THEN '1845–1849'
WHEN 12 THEN '1849–1850'
WHEN 13 THEN '1850–1853'
WHEN 14 THEN '1853–1857'
WHEN 15 THEN '1857–1861'
WHEN 16 THEN '1861–1865'
WHEN 17 THEN '1865–1869'
WHEN 18 THEN '1869–1877'
WHEN 19 THEN '1877–1881'
WHEN 20 THEN '1881'
WHEN 21 THEN '1881–1885'
WHEN 22 THEN '1885–1889'
WHEN 23 THEN '1889–1893'
WHEN 24 THEN '1893–1897'
WHEN 25 THEN '1897–1901'
WHEN 26 THEN '1901–1909'
WHEN 27 THEN '1909–1913'
WHEN 28 THEN '1913–1921'
WHEN 29 THEN '1921–1923'
WHEN 30 THEN '1923–1929'
WHEN 31 THEN '1929–1933'
WHEN 32 THEN '1933–1945'
WHEN 33 THEN '1945–1953'
WHEN 34 THEN '1953–1961'
WHEN 35 THEN '1961–1963'
WHEN 36 THEN '1963–1969'
WHEN 37 THEN '1969–1974'
WHEN 38 THEN '1974–1977'
WHEN 39 THEN '1977–1981'
WHEN 40 THEN '1981–1989'
WHEN 41 THEN '1989–1993'
WHEN 42 THEN '1993–2001'
WHEN 43 THEN '2001–2009'
WHEN 44 THEN '2009–2017'
WHEN 45 THEN '2017–2021'
WHEN 46 THEN '2021–2024'
WHEN 47 THEN '2024- Present'

END;

UPDATE usa_presidents_staging1
SET Annual_Salary = CASE S_No
WHEN 1 THEN  25000.00 
WHEN 2 THEN 25000.00
WHEN 3  THEN 25000.00
WHEN 4 THEN 25000.00
WHEN 5 THEN 25000.00
WHEN 6 THEN 25000.00
WHEN 7 THEN 25000.00
WHEN 8 THEN 25000.00
WHEN 9 THEN 25000.00
WHEN 10 THEN 25000.00
WHEN 11 THEN 25000.00
WHEN 12 THEN 25000.00
WHEN 13 THEN 25000.00
WHEN 14 THEN 25000.00
WHEN 15 THEN 25000.00
WHEN 16 THEN 25000.00
WHEN 17 THEN 25000.00
WHEN 18 THEN 25000.00
WHEN 19 THEN 50000.00
WHEN 20 THEN 50000.00
WHEN 21 THEN 50000.00
WHEN 22 THEN 50000.00
WHEN 23 THEN 50000.00
WHEN 24 THEN 50000.00
WHEN 25 THEN 50000.00
WHEN 26 THEN 50000.00
WHEN 27 THEN 75000.00
WHEN 28 THEN 75000.00
WHEN 29 THEN 75000.00
WHEN 30 THEN 75000.00
WHEN 31 THEN 75000.00
WHEN 32 THEN 75000.00
WHEN 33 THEN 100000.00
WHEN 34 THEN 100000.00
WHEN 35 THEN 100000.00
WHEN 36 THEN 100000.00
WHEN 37 THEN 200000.00
WHEN 38 THEN 200000.00
WHEN 39 THEN 200000.00
WHEN 40 THEN 200000.00
WHEN 41 THEN 200000.00
WHEN 42 THEN 200000.00
WHEN 43 THEN 400000.00
WHEN 44 THEN 400000.00
WHEN 45 THEN 400000.00
WHEN 46 THEN 400000.00
WHEN 47 THEN 400000.00

END ;

-- STANDARDIZING DATA --

SELECT DISTINCT president
FROM usa_presidents_staging1
;

SELECT REPLACE ( president,'john adams', 'John Adams')
FROM usa_presidents_staging1
;

UPDATE usa_presidents_staging1
SET president = REPLACE ( president,'john adams', 'John Adams')
WHERE president = 'john adams'
;

UPDATE usa_presidents_staging1
SET president = REPLACE ( president,'JAMES MONROE', 'James Monroe')
WHERE president = 'JAMES MONROE'
;

UPDATE usa_presidents_staging1
SET president = REPLACE ( president,'john tyler', 'John Tyler')
WHERE president = 'john tyler'
;

SELECT DISTINCT Political_Party
FROM usa_presidents_staging1;

UPDATE usa_presidents_staging1
SET Political_Party = 'Whig'
WHERE Political_Party = 'Whig   April 4, 1841  â€“  September 13, 1841'
;

UPDATE usa_presidents_staging1
SET Political_Party = 'Republican'
WHERE Political_Party = 'Republicans'
;

SELECT *
FROM usa_presidents_staging1
WHERE Political_Party = 'Republican';


SELECT Vice_President
FROM usa_presidents_staging1;

UPDATE usa_presidents_staging1
SET Vice_President = (TRIM(Vice_President))
;

UPDATE usa_presidents_staging1
SET Vice_President = REPLACE ( Vice_President,'George    Clinton', 'George Clinton')
WHERE Vice_president = 'George    Clinton'
;

UPDATE usa_presidents_staging1
SET Vice_President = REPLACE ( Vice_President,'John C.     Calhoun', 'John C. Calhoun')
WHERE Vice_president = 'John C.     Calhoun'
;

UPDATE usa_presidents_staging1
SET Vice_President = REPLACE ( Vice_President,'George         M. Dallas', 'George M. Dallas')
WHERE Vice_president = 'George         M. Dallas'
;

UPDATE usa_presidents_staging1
SET Vice_President = 'Charles W. Fairbanks'
WHERE S_No = 26
;

UPDATE usa_presidents_staging1
SET Vice_President = 'Charles G. Dawes'
WHERE S_No = 30
;

UPDATE usa_presidents_staging1
SET Vice_President = 'John Nance Garner, Henry A. Wallace, Harry S. Truman'
WHERE S_No = 32
;

UPDATE usa_presidents_staging1
SET Vice_President = 'Alben Barkley'
WHERE S_No = 33
;

UPDATE usa_presidents_staging1
SET Vice_President = 'Hubert Humphrey'
WHERE S_No = 36
;

UPDATE usa_presidents_staging1
SET Vice_President = 'Spiro Agnew, then Gerald Ford'
WHERE S_No = 38
;



SELECT *
FROM usa_presidents_staging1;


-- The data has been cleaned successfully--
-- MR_XARNEY--







