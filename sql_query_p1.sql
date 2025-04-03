-- SQL Retail Sales Analysis - P1
CREATE DATABASE sql_project_p2;
USE sql_project_p2;

-- Create TABLE
DROP TABLE IF EXISTS retail_sales;
CREATE TABLE retail_sales (
    transaction_id INT PRIMARY KEY,	
    sale_date DATE,	 
    sale_time TIME,	
    customer_id INT,
    gender VARCHAR(15),
    age INT,
    category VARCHAR(15),	
    quantity INT,
    price_per_unit DECIMAL(10,2),	
    cogs DECIMAL(10,2),
    total_sale DECIMAL(10,2)
);

-- View first 10 rows
SELECT * FROM retail_sales
LIMIT 10;

-- Count total records
SELECT COUNT(*) FROM retail_sales;

-- Data Cleaning
SELECT * FROM retail_sales WHERE transaction_id IS NULL;
SELECT * FROM retail_sales WHERE sale_date IS NULL;
SELECT * FROM retail_sales WHERE sale_time IS NULL;

SELECT * FROM retail_sales
WHERE 
    transaction_id IS NULL OR sale_date IS NULL OR sale_time IS NULL OR
    gender IS NULL OR category IS NULL OR quantity IS NULL OR 
    cogs IS NULL OR total_sale IS NULL;

-- Delete rows with NULL values
DELETE FROM retail_sales
WHERE 
    transaction_id IS NULL OR sale_date IS NULL OR sale_time IS NULL OR
    gender IS NULL OR category IS NULL OR quantity IS NULL OR 
    cogs IS NULL OR total_sale IS NULL;

-- Data Exploration

-- Total number of sales
SELECT COUNT(*) AS total_sales FROM retail_sales;

-- Unique customers
SELECT COUNT(DISTINCT customer_id) AS unique_customers FROM retail_sales;

-- List all unique categories
SELECT DISTINCT category FROM retail_sales;

-- Data Analysis & Business Key Problems & Answers

-- Q.1 Retrieve all sales made on '2022-11-05'
SELECT * FROM retail_sales WHERE sale_date = '2022-11-05';

-- Q.2 Retrieve transactions for 'Clothing' with quantity > 4 in Nov 2022
SELECT * FROM retail_sales
WHERE 
    category = 'Clothing'
    AND DATE_FORMAT(sale_date, '%Y-%m') = '2022-11'
    AND quantity > 4;

-- Q.3 Total sales per category
SELECT 
    category,
    SUM(total_sale) AS net_sale,
    COUNT(*) AS total_orders
FROM retail_sales
GROUP BY category;

-- Q.4 Average age of customers who purchased 'Beauty' items
SELECT ROUND(AVG(age), 2) AS avg_age
FROM retail_sales
WHERE category = 'Beauty';

-- Q.5 Find transactions where total_sale > 1000
SELECT * FROM retail_sales WHERE total_sale > 1000;

-- Q.6 Total transactions by gender and category
SELECT 
    category,
    gender,
    COUNT(*) AS total_transactions
FROM retail_sales
GROUP BY category, gender
ORDER BY category;

-- Q.7 Best-selling month per year
WITH monthly_sales AS (
    SELECT 
        YEAR(sale_date) AS year,
        MONTH(sale_date) AS month,
        AVG(total_sale) AS avg_sale,
        RANK() OVER (PARTITION BY YEAR(sale_date) ORDER BY AVG(total_sale) DESC) AS rank
    FROM retail_sales
    GROUP BY YEAR(sale_date), MONTH(sale_date)
)
SELECT year, month, avg_sale 
FROM monthly_sales
WHERE rank = 1;

-- Q.8 Top 5 customers by total sales
SELECT 
    customer_id,
    SUM(total_sale) AS total_sales
FROM retail_sales
GROUP BY customer_id
ORDER BY total_sales DESC
LIMIT 5;

-- Q.9 Unique customers per category
SELECT 
    category,    
    COUNT(DISTINCT customer_id) AS unique_customers
FROM retail_sales
GROUP BY category;

-- Q.10 Orders per shift (Morning, Afternoon, Evening)
WITH hourly_sale AS (
    SELECT *,
        CASE
            WHEN HOUR(sale_time) < 12 THEN 'Morning'
            WHEN HOUR(sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
            ELSE 'Evening'
        END AS shift
    FROM retail_sales
)
SELECT 
    shift,
    COUNT(*) AS total_orders    
FROM hourly_sale
GROUP BY shift;

-- End of project
