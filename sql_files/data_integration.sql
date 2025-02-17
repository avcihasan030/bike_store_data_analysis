-- DATA INTEGRATION
-- loading data into mysql database

CREATE DATABASE bike_store_db;
USE bike_store_db;

CREATE TABLE brands (
                        brand_id INT PRIMARY KEY,
                        brand_name VARCHAR(255) NOT NULL
);

CREATE TABLE categories (
                            category_id INT PRIMARY KEY,
                            category_name VARCHAR(255) NOT NULL
);

CREATE TABLE customers (
                           customer_id INT PRIMARY KEY,
                           first_name VARCHAR(255) NOT NULL,
                           last_name VARCHAR(255) NOT NULL,
                           phone VARCHAR(25),
                           email VARCHAR(255) NOT NULL,
                           street VARCHAR(255),
                           city VARCHAR(50),
                           state VARCHAR(25),
                           zip_code VARCHAR(5)
);

CREATE TABLE stores (
                        store_id INT PRIMARY KEY,
                        store_name VARCHAR(255) NOT NULL,
                        phone VARCHAR(25),
                        email VARCHAR(255),
                        street VARCHAR(255),
                        city VARCHAR(255),
                        state VARCHAR(10),
                        zip_code VARCHAR(5)
);

CREATE TABLE products (
                          product_id INT PRIMARY KEY,
                          product_name VARCHAR(255) NOT NULL,
                          brand_id INT NOT NULL,
                          category_id INT NOT NULL,
                          model_year SMALLINT NOT NULL,
                          list_price DECIMAL(10, 2) NOT NULL,
                          FOREIGN KEY (brand_id) REFERENCES brands(brand_id),
                          FOREIGN KEY (category_id) REFERENCES categories(category_id)
);

CREATE TABLE stocks (
                        store_id INT,
                        product_id INT,
                        quantity INT,
                        PRIMARY KEY (store_id, product_id),
                        FOREIGN KEY (store_id) REFERENCES stores(store_id),
                        FOREIGN KEY (product_id) REFERENCES products(product_id)
);

CREATE TABLE staffs (
                        staff_id INT PRIMARY KEY,
                        first_name VARCHAR(50) NOT NULL,
                        last_name VARCHAR(50) NOT NULL,
                        email VARCHAR(255) NOT NULL UNIQUE,
                        phone VARCHAR(25),
                        active TINYINT NOT NULL,
                        store_id INT NOT NULL,
                        manager_id INT,
                        FOREIGN KEY (store_id) REFERENCES stores(store_id),
                        FOREIGN KEY (manager_id) REFERENCES staffs(staff_id)
);

CREATE TABLE orders (
                        order_id INT PRIMARY KEY,
                        customer_id INT,
                        order_status TINYINT NOT NULL,
                        order_date DATE NOT NULL,
                        required_date DATE NOT NULL,
                        shipped_date DATE,
                        store_id INT NOT NULL,
                        staff_id INT NOT NULL,
                        FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
                        FOREIGN KEY (store_id) REFERENCES stores(store_id),
                        FOREIGN KEY (staff_id) REFERENCES staffs(staff_id)
);

CREATE TABLE order_items (
                             order_id INT,
                             item_id INT,
                             product_id INT NOT NULL,
                             quantity INT NOT NULL,
                             list_price DECIMAL(10, 2) NOT NULL,
                             discount DECIMAL(4, 2) NOT NULL DEFAULT 0,
                             PRIMARY KEY (order_id, item_id),
                             FOREIGN KEY (order_id) REFERENCES orders(order_id),
                             FOREIGN KEY (product_id) REFERENCES products(product_id)
);


LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/bike_db/brands.csv'
    INTO TABLE brands
    FIELDS TERMINATED BY ','
    ENCLOSED BY '"'
    LINES TERMINATED BY '\n'
    IGNORE 1 ROWS;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/bike_db/categories.csv'
    INTO TABLE categories
    FIELDS TERMINATED BY ','
    ENCLOSED BY '"'
    LINES TERMINATED BY '\n'
    IGNORE 1 ROWS;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/bike_db/customers.csv'
    INTO TABLE customers
    FIELDS TERMINATED BY ','
    ENCLOSED BY '"'
    LINES TERMINATED BY '\n'
    IGNORE 1 ROWS;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/bike_db/stores.csv'
    INTO TABLE stores
    FIELDS TERMINATED BY ','
    ENCLOSED BY '"'
    LINES TERMINATED BY '\n'
    IGNORE 1 ROWS;--

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/bike_db/products.csv'
    INTO TABLE products
    FIELDS TERMINATED BY ','
    ENCLOSED BY '"'
    LINES TERMINATED BY '\n'
    IGNORE 1 ROWS;--

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/bike_db/stocks.csv'
    INTO TABLE stocks
    FIELDS TERMINATED BY ','
    ENCLOSED BY '"'
    LINES TERMINATED BY '\n'
    IGNORE 1 ROWS;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/bike_db/staffs.csv'
    INTO TABLE staffs
    FIELDS TERMINATED BY ','
    ENCLOSED BY '"'
    LINES TERMINATED BY '\n'
    IGNORE 1 ROWS;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/bike_db/orders.csv'
    INTO TABLE orders
    FIELDS TERMINATED BY ','
    ENCLOSED BY '"'
    LINES TERMINATED BY '\n'
    IGNORE 1 ROWS;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/bike_db/order_items.csv'
    INTO TABLE order_items
    FIELDS TERMINATED BY ','
    ENCLOSED BY '"'
    LINES TERMINATED BY '\n'
    IGNORE 1 ROWS;
