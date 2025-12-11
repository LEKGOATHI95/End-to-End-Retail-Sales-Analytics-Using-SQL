SELECT * FROM retail_sales.retail_sales;

-- Data Cleaning

Alter table retail_sales.retail_sales
Rename column transaction_id to transactions_id;

Alter table retail_sales.retail_sales
Rename column quantiy to quantity;

SELECT * FROM retail_sales.retail_sales
WHERE 
    transactions_id IS NULL
    OR
    sale_date IS NULL
    OR 
    sale_time IS NULL
    OR
    gender IS NULL
    OR
    category IS NULL
    OR
    quantity IS NULL
    OR
    cogs IS NULL
    OR
    total_sale IS NULL;

SET SQL_SAFE_UPDATES = 0; -- Disable safe update mode

DELETE FROM retail_sales.retail_sales
WHERE 
    transactions_id IS NULL
    OR
    sale_date IS NULL
    OR 
    sale_time IS NULL
    OR
    gender IS NULL
    OR
    category IS NULL
    OR
    quantity IS NULL
    OR
    cogs IS NULL
    OR
    total_sale IS NULL;
    
SET SQL_SAFE_UPDATES = 1; -- optional: turn it back on

-- Data Exploration

Select Count(*) as total_sales  from retail_sales.retail_sales;

-- How many uniuque customers we have ?

Select Count(distinct customer_id) as total_sales from retail_sales.retail_sales;

Select distinct category from retail_sales.retail_sales;


-- Data Analysis & Business Key Problems & Answers

-- My Analysis & Findings
-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 2 in the month of Nov-2022
-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)

-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05

Select * From retail_sales.retail_sales 
where 
sale_date = '2022-11-05';

-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10 in the month of Nov-2022

Select * from retail_sales.retail_sales 
where 
  category = 'clothing' 
  and quantity >=2 
  and sale_date Between '2022-11-01' and '2022-11-30';
  
-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category

SELECT 
    category,
    SUM(total_sale) AS net_sale,
    COUNT(*) AS total_orders
FROM retail_sales.retail_sales
group by category;

-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category

select round(avg(age),1) as average_beauty_age
from retail_sales.retail_sales
where category = 'Beauty'

-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000

Select * From retail_sales.retail_sales
where total_sale > 1000

-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category

Select gender, category,
Count(transactions_id) as total_transactions
From retail_sales.retail_sales
group by gender, category;

-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year

SELECT 
    sale_year,
    sale_month,
    avg_sale
FROM 
(    
    SELECT 
        EXTRACT(YEAR FROM sale_date) AS sale_year,
        EXTRACT(MONTH FROM sale_date) AS sale_month,
        AVG(total_sale) AS avg_sale,
        RANK() OVER(
            PARTITION BY EXTRACT(YEAR FROM sale_date) 
            ORDER BY AVG(total_sale) DESC
        ) AS rnk
    FROM retail_sales.retail_sales
    GROUP BY sale_year, sale_month
) AS t1
WHERE rnk = 1
ORDER BY sale_year, avg_sale DESC;

-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 

Select customer_id, sum(total_sale) as total_sales
from retail_sales.retail_sales
group by customer_id
order by total_sales desc
limit 5

-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category

Select 
category,
Count(Distinct customer_id) as unique_customers
from retail_sales.retail_sales
group by category
order by unique_customers DESC

-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)

WITH hourly_sale
AS
(
SELECT *,
    CASE
        WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
        WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END as shift
FROM retail_sales.retail_sales
)
SELECT 
    shift,
    COUNT(*) as total_orders    
FROM hourly_sale
GROUP BY shift

-- End 






  
  






