-- 1. Data Cleaning and Preprocessing steps for each table

-- Use the bike_store_db database
USE bike_store_db;

-- Show all tables in the database
SHOW TABLES;

-- ----------------------------------------------------------------------------
-- customers table
-- ----------------------------------------------------------------------------

-- Select all records from the customers table
SELECT *
FROM customers;

-- Describe the structure of the customers table
DESC customers;

-- Count the total number of records in the customers table
SELECT COUNT(*)
FROM customers;

-- Check for null or invalid/broken values in the customers table
SELECT GROUP_CONCAT(
               CONCAT(
                       'SUM(CASE WHEN ', COLUMN_NAME, ' IS NULL THEN 1 ELSE 0 END) AS ', COLUMN_NAME, '_null_count'
               )
       )
INTO @sql_query
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'customers'
  AND TABLE_SCHEMA = DATABASE();

SET @sql_query = CONCAT('SELECT ', @sql_query, ' FROM customers;');

PREPARE stmt FROM @sql_query;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Count the total number of records and distinct customer IDs
SELECT COUNT(*)
FROM customers;
SELECT COUNT(DISTINCT customer_id)
FROM customers;

-- Check for distinct cities in the customers table
SELECT DISTINCT city
FROM customers
ORDER BY city;

-- Standardize data: Trim leading and trailing spaces from the street column
SELECT DISTINCT street, TRIM(street)
FROM customers;
UPDATE customers
SET street = TRIM(street);

-- Remove non-numeric characters from phone numbers
SELECT phone
FROM customers;
UPDATE customers
SET phone = REPLACE(REPLACE(REPLACE(REPLACE(phone, '(', ''), ')', ''), '-', ''), ' ', '');

-- Check for duplicate data and remove if necessary
WITH CTE AS (SELECT customer_id,
                    ROW_NUMBER() OVER (PARTITION BY first_name, last_name, email, street, city, state, zip_code) AS row_num
             FROM customers)
SELECT *
FROM CTE
WHERE row_num > 1;

-- ----------------------------------------------------------------------------
-- order_items table
-- ----------------------------------------------------------------------------

-- Select all records from the order_items table
SELECT *
FROM order_items;

-- Describe the structure of the order_items table
DESC order_items;

-- Check for null values in the order_items table
SELECT GROUP_CONCAT(
               CONCAT(
                       'SUM(CASE WHEN ', COLUMN_NAME, ' IS NULL THEN 1 ELSE 0 END) AS ', COLUMN_NAME, '_null_count'
               )
       )
INTO @sql_query
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'order_items'
  AND TABLE_SCHEMA = DATABASE();

SET @sql_query = CONCAT('SELECT ', @sql_query, ' FROM order_items;');

PREPARE stmt FROM @sql_query;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Check for duplicate data and remove if necessary
WITH CTE AS (SELECT *,
                    ROW_NUMBER() OVER (PARTITION BY order_id, item_id, product_id) AS row_num
             FROM order_items)
SELECT *
FROM CTE
WHERE row_num > 1;

-- Validate foreign keys and remove orphaned records
SELECT oi.order_id
FROM order_items oi
         LEFT JOIN orders o USING (order_id)
WHERE o.order_id IS NULL;

-- Data transformation: Add a revenue column to order_items
ALTER TABLE order_items
    ADD COLUMN revenue DECIMAL(10, 2);

-- Calculate revenue as quantity * list_price * (1 - discount)
UPDATE order_items
SET revenue = quantity * list_price * (1 - discount);

-- ----------------------------------------------------------------------------
-- staffs table
-- ----------------------------------------------------------------------------

-- inconsistent order-shipping dates
SELECT order_id, order_date, shipped_date
FROM orders
WHERE shipped_date < order_date;


-- ----------------------------------------------------------------------------
-- staffs table
-- ----------------------------------------------------------------------------

-- Select all records from the staffs table
SELECT *
FROM staffs;

-- Describe the structure of the staffs table
DESC staffs;

-- Check for null values in the staffs table
SELECT GROUP_CONCAT(
               CONCAT(
                       'SUM(CASE WHEN ', COLUMN_NAME, ' IS NULL THEN 1 ELSE 0 END) AS ', COLUMN_NAME, '_null_count'
               )
       )
INTO @sql_query
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'staffs'
  AND TABLE_SCHEMA = DATABASE();

SET @sql_query = CONCAT('SELECT ', @sql_query, ' FROM staffs;');

PREPARE stmt FROM @sql_query;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Check for duplicate data and remove if necessary
WITH CTE AS (SELECT *,
                    ROW_NUMBER() OVER (PARTITION BY staff_id, first_name, last_name, email, phone, active, store_id, manager_id) AS row_num
             FROM staffs)
SELECT *
FROM CTE
WHERE row_num > 1;

-- Remove non-numeric characters from phone numbers
UPDATE staffs
SET phone = REPLACE(REPLACE(REPLACE(REPLACE(phone, '(', ''), ')', ''), '-', ''), ' ', '');

-- ----------------------------------------------------------------------------
-- stores table
-- ----------------------------------------------------------------------------

-- Select all records from the stores table
SELECT *
FROM stores;

-- Remove non-numeric characters from phone numbers
UPDATE stores
SET phone = REPLACE(REPLACE(REPLACE(REPLACE(phone, '(', ''), ')', ''), '-', ''), ' ', '');