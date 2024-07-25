------- 1. time_of_day
SELECT Time,
CASE 
    WHEN Time BETWEEN '00:00:00' AND '12:00:00' THEN 'Morning'
    WHEN Time BETWEEN '12:01:00' AND '16:00:00' THEN 'Afternoon'
    ELSE 'Evening'
END AS time_of_day
FROM walmart_sales;

ALTER TABLE walmart_sales 
ADD time_of_day VARCHAR(50);

UPDATE walmart_sales 
SET time_of_day = CASE 
    WHEN Time BETWEEN '00:00:00' AND '12:00:00' THEN 'Morning'
    WHEN Time BETWEEN '12:01:00' AND '16:00:00' THEN 'Afternoon'
    ELSE 'Evening'
END;

SELECT * FROM walmart_sales;

------  2. day_name
SELECT date,
DAYNAME(date) AS day_name
FROM walmart_sales;

ALTER TABLE walmart_sales ADD day_name VARCHAR(50);

UPDATE walmart_sales SET day_name = DAYNAME(date);

SELECT * FROM walmart_sales;


-------  3. month_name
SELECT date,
MONTHNAME(date) AS month_name
FROM walmart_sales;

ALTER TABLE walmart_sales ADD month_name VARCHAR(50);

UPDATE walmart_sales SET month_name = MONTHNAME(date);

SELECT * FROM walmart_sales;

-----------------------------------------------------------------------------------------------------------------------------------------
-- 1. How many unique cities does data have?
SELECT COUNT(DISTINCT city) AS count_of_cities FROM walmart_sales;

-- 2. In which city is each branch?
SELECT DISTINCT branch FROM walmart_sales;

SELECT DISTINCT city, branch FROM walmart_sales;

-- 3. How many unique product lines does the data have?
ALTER TABLE walmart_sales CHANGE COLUMN `Product line` product_line VARCHAR(255);

SELECT COUNT(DISTINCT Product_line) AS no_of_product_line FROM walmart_sales;

-- 4. What is the most common payment method?
SELECT payment, COUNT(*) AS pay_method 
FROM walmart_sales
GROUP BY payment
ORDER BY pay_method DESC;

-- 5. What is the most selling product line?
SELECT product_line, COUNT(*) AS no_of_product_line
FROM walmart_sales
GROUP BY product_line
ORDER BY no_of_product_line DESC;

-- 6. What is the total revenue by month?
SELECT month_name, SUM(total) AS total_revenue 
FROM walmart_sales
GROUP BY month_name
ORDER BY total_revenue DESC;

-- 7. What month had the largest COGS?
SELECT month_name, SUM(cogs) AS no_of_cogs
FROM walmart_sales
GROUP BY month_name
ORDER BY no_of_cogs DESC;

-- 8. What product line had the largest revenue?
SELECT product_line, SUM(total) AS total_reve_of_product_line 
FROM walmart_sales
GROUP BY product_line
ORDER BY total_reve_of_product_line DESC;

-- 9. What is the city with the largest revenue?
SELECT city, SUM(total) AS city_largest_reve 
FROM walmart_sales
GROUP BY city
ORDER BY city_largest_reve DESC;

-- 10. What product line had the largest VAT?
ALTER TABLE walmart_sales CHANGE COLUMN `Tax 5%` Tax_5 DECIMAL(10,2);

SELECT product_line, AVG(Tax_5) AS avg_tax 
FROM walmart_sales
GROUP BY product_line
ORDER BY avg_tax DESC;

-- 11. Fetch each product line and add a column to those product lines showing "Good", "Bad". Good if it's greater than average sales.
WITH cte AS (
    SELECT product_line, AVG(total) AS avg_total
    FROM walmart_sales
    GROUP BY product_line
), cte2 AS (
    SELECT AVG(avg_total) AS total_avg FROM cte
)
SELECT cte.product_line,
CASE 
    WHEN cte.avg_total > cte2.total_avg THEN 'Good'
    ELSE 'Bad'
END AS 'Good/Bad'
FROM cte, cte2;

-- 12. Which branch sold more products than average product sold?
SELECT branch, SUM(quantity) AS qty
FROM walmart_sales
GROUP BY branch 
HAVING SUM(quantity) > (SELECT AVG(quantity) FROM walmart_sales);

-- 13. What is the most common product line by gender?
SELECT product_line,
COUNT(CASE WHEN gender = 'Female' THEN 1 END) AS female_cnt,
SUM(CASE WHEN gender = 'Male' THEN 1 END) AS male_cnt
FROM walmart_sales
GROUP BY product_line;

-- Same question but different approach
SELECT product_line, gender,
COUNT(gender) AS total_cnt
FROM walmart_sales
GROUP BY product_line, gender
ORDER BY total_cnt DESC;

-- 14. What is the average rating of each product line?
SELECT product_line, ROUND(AVG(rating), 1) AS avg_rating
FROM walmart_sales
GROUP BY product_line
ORDER BY avg_rating DESC;


------------------------------------------------ Sales Analysis Part ------------------------------------------------------------

-- 1. Number of sales made in each time of the day per weekday?
SELECT time_of_day, COUNT(*) AS total_sales
FROM walmart_sales
WHERE day_name = 'Monday'
GROUP BY time_of_day
ORDER BY total_sales DESC;

-- 2. Which customer type brings the most revenue?
ALTER TABLE walmart_sales CHANGE COLUMN `Customer type` customer_type VARCHAR(255);

SELECT customer_type, ROUND(SUM(total), 2) AS revenue 
FROM walmart_sales
GROUP BY Customer_type
ORDER BY revenue DESC;

-- 3. Which city has the largest tax percent/VAT?
SELECT city, ROUND(SUM(Tax_5), 2) AS taxes
FROM walmart_sales
GROUP BY city
ORDER BY taxes DESC;

-- 4. Which customer type pays the most in VAT?
SELECT customer_type, ROUND(SUM(Tax_5), 2) AS total_tax
FROM walmart_sales
GROUP BY customer_type
ORDER BY total_tax DESC;


--------------------------------------------- Customer -------------------------------------------------------------------

-- 1. How many unique customer types does the data have?
SELECT COUNT(DISTINCT customer_type) AS total_cust_type FROM walmart_sales;

-- 2. How many unique payment methods does the data have?
SELECT Payment, COUNT(DISTINCT Payment) AS total_pay_method FROM walmart_sales
GROUP BY Payment;

-- 3. What is the most common customer type?
SELECT Customer_type, COUNT(Customer_type) AS total_cnt 
FROM walmart_sales
GROUP BY Customer_type
ORDER BY total_cnt DESC;

-- 4. Which customer type buys the most?
SELECT Customer_type, COUNT(Customer_type) AS total_cnt 
FROM walmart_sales
GROUP BY Customer_type
ORDER BY total_cnt DESC;

-- 5. What is the gender of most of the customers?
SELECT gender, COUNT(*) AS total_gender_cnt
FROM walmart_sales
GROUP BY gender
ORDER BY total_gender_cnt DESC;

-- 6. What is the gender distribution per branch?
SELECT branch, gender, COUNT(*) AS total_gender_cnt
FROM walmart_sales
GROUP BY branch, gender
ORDER BY branch, total_gender_cnt DESC;

-- 7. Which time of the day do customers give most ratings?
SELECT time_of_day, COUNT(rating) AS total_no_rating 
FROM walmart_sales
GROUP BY time_of_day;

-- 8. Which time of the day do customers give most ratings per branch?
SELECT time_of_day, branch, COUNT(rating) AS total_no_rating 
FROM walmart_sales
GROUP BY time_of_day, branch
ORDER BY time_of_day, branch, total_no_rating DESC;

-- 9. Which day of the week has the best average rating?
SELECT day_name, ROUND(AVG(rating), 2) AS total_no_rating 
FROM walmart_sales
GROUP BY day_name;

-- 10. Which day of the week has the best average rating per branch?
SELECT day_name, branch, ROUND(AVG(rating), 2) AS total 
FROM walmart_sales
GROUP BY day_name, branch
ORDER BY day_name, branch, total DESC;

