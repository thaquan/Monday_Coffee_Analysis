-- Easy Problems 

-- Q1: Coffee Consumers Count
-- How many people in each city are eastimated to consume coffee, given that 25% of the population does ?
SELECT 
city_name,
ROUND((population * 0.25) / 1000000, 2) AS coffee_consumers_in_millions,
city_rank
FROM monday_coffee.city
ORDER BY coffee_consumers_in_millions DESC;

-- Q2: Total Revenue from Coffee Sales
-- What is the total revenue generated from coffee sales across all cities in the last quarter of 2023?
SELECT 
SUM(total) AS total_revenue
FROM monday_coffee.sales
WHERE 
	YEAR(sale_date) = 2023
AND 
	MONTH(sale_date) IN (10, 11, 12)

SELECT 
ci.city_name,
SUM(s.total) AS total_revenue
FROM monday_coffee.sales s
LEFT JOIN monday_coffee.customers c
ON s.customer_id = c.customer_id
LEFT JOIN monday_coffee.city ci
ON c.city_id = ci.city_id
WHERE 
	YEAR(s.sale_date) = 2023
AND 
	MONTH(s.sale_date) IN (10, 11, 12)
GROUP BY ci.city_name
ORDER BY total_revenue DESC;


-- Q3: Sales Count for Each Product
-- How many units of each coffee product have been sold?
SELECT 
p.product_name,
COUNT(s.sale_id) AS total_orders
FROM monday_coffee.products p
LEFT JOIN monday_coffee.sales s
ON p.product_id = s.product_id
GROUP BY p.product_name 
ORDER BY total_orders;

-- Q4: Average Sales Amount per City
-- What is the average sales amount per customer in each city?
SELECT 
ci.city_name, 
SUM(s.total) AS total_revenue,
COUNT(DISTINCT s.customer_id) AS total_cx,
ROUND(SUM(s.total) / COUNT(DISTINCT s.customer_id), 2) AS avg_sale_per_customer
FROM monday_coffee.sales s
LEFT JOIN monday_coffee.customers c
ON s.customer_id = c.customer_id
LEFT JOIN monday_coffee.city ci
ON c.city_id = ci.city_id
GROUP BY ci.city_name
ORDER BY avg_sale_per_customer DESC;

-- Q5: City Population and Coffee Consumers
-- Provide a list of cities along with their populations and estimated coffee consumers.
-- return city_name, total current cx, estimated coffee consumers (25%)
WITH city_table AS (
	SELECT 
	city_name,
	ROUND((population * 0.25) / 1000000, 2) AS coffee_customers
	FROM monday_coffee.city
),
	customer_table AS (
SELECT 
	ci.city_name,
	COUNT(DISTINCT c.customer_id) AS unique_cx
	FROM monday_coffee.sales s
	LEFT JOIN monday_coffee.customers c
	ON s.customer_id = c.customer_id
	LEFT JOIN monday_coffee.city ci
	ON c.city_id = ci.city_id
	GROUP BY ci.city_name
)

SELECT 
ct.city_name,
cit.coffee_customers AS coffee_consumer_in_millions,
ct.unique_cx
FROM city_table cit
JOIN customer_table ct
ON cit.city_name = ct.city_name

-- Q6: Top Selling Products by City
-- What are the top 3 selling products in each city based on sales volume?

SELECT 
*
FROM (
	SELECT 
	ci.city_name,
	p.product_name,
	COUNT(s.sale_id) AS total_orders,
	DENSE_RANK() OVER (PARTITION BY ci.city_name ORDER BY COUNT(s.sale_id) DESC) AS rank
	FROM monday_coffee.sales s
	LEFT JOIN monday_coffee.products p
	ON s.product_id = p.product_id
	LEFT JOIN monday_coffee.customers c
	ON c.customer_id = s.customer_id
	LEFT JOIN monday_coffee.city ci
	ON ci.city_id = c.city_id
	GROUP BY ci.city_name, p.product_name
) t 
WHERE rank <= 3; 

-- Q.7: Customer Segmentation by City
-- Customer Segmentation by City
-- How many unique customers are there in each city who have purchased coffee products?

SELECT 
ci.city_name,
COUNT(DISTINCT c.customer_id) AS unique_cx
FROM monday_coffee.city ci
LEFT JOIN monday_coffee.customers c
ON ci.city_id = c.city_id
LEFT JOIN monday_coffee.sales s
ON s.customer_id = c.customer_id
WHERE 
	s.product_id IN (1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14)
GROUP BY ci.city_name;

-- Q.8
-- Average Sale vs Rent
-- Find each city and their average sale per customer and avg rent per customer

WITH city_table AS (
	SELECT 
	ci.city_name,
	SUM(s.total) AS total_revenue,
	COUNT(DISTINCT s.customer_id) AS total_cx,
	ROUND(SUM(s.total) / COUNT(DISTINCT s.customer_id), 2) AS avg_sale_pr_cx
	FROM monday_coffee.sales s
	LEFT JOIN monday_coffee.customers c
	ON s.customer_id = c.customer_id
	LEFT JOIN monday_coffee.city ci
	ON ci.city_id = c.city_id
	GROUP BY ci.city_name
), 
	city_rent AS (
	SELECT 
	city_name,
	estimated_rent
	FROM monday_coffee.city 
)

SELECT 
cr.city_name,
cr.estimated_rent,
ct.total_cx,
ct.avg_sale_pr_cx,
ROUND(cr.estimated_rent / ct.total_cx, 2) AS avg_rent_per_cx
FROM city_rent cr
LEFT JOIN city_table ct
ON cr.city_name = ct.city_name
ORDER BY avg_rent_per_cx DESC;

-- Q.9
-- Monthly Sales Growth
-- Sales growth rate: Calculate the percentage growth (or decline) in sales over different time periods (monthly)
-- by each city

WITH monthly_sales AS (
	SELECT 
	ci.city_name,
	MONTH(s.sale_date) AS 'month',
	YEAR(s.sale_date) AS 'year',
	SUM(s.total) AS total_sale
	FROM monday_coffee.sales s 
	LEFT JOIN monday_coffee.customers c
	ON s.customer_id = c.customer_id
	LEFT JOIN monday_coffee.city ci
	ON ci.city_id = c.city_id
	GROUP BY ci.city_name, MONTH(s.sale_date), YEAR(s.sale_date)
),
	growth_ratio AS (
SELECT 
	city_name,
	month, 
	year, 
	total_sale AS cr_month_sale,
	LAG(total_sale, 1) OVER (PARTITION BY city_name ORDER BY year, month) AS last_month_sale
	FROM monthly_sales
)

SELECT 
city_name, 
month, 
year,
cr_month_sale,
last_month_sale,
ROUND((cr_month_sale - last_month_sale) * 100 / last_month_sale, 2) AS growth_ratio  
FROM growth_ratio
WHERE 
	last_month_sale IS NOT NULL;

-- Q.10
-- Market Potential Analysis
-- Identify top 3 city based on highest sales, return city name, total sale, total rent, total customers, estimated coffee consumer

WITH city_table AS (
	SELECT 
	ci.city_name, 
	SUM(s.total) AS total_revenue,
	COUNT(DISTINCT s.customer_id) AS total_cx,
	ROUND(SUM(s.total) / COUNT(DISTINCT s.customer_id), 2) AS avg_sale_pr_cx
	FROM monday_coffee.sales s
	LEFT JOIN monday_coffee.customers c 
	ON c.customer_id = s.customer_id
	LEFT JOIN monday_coffee.city ci
	ON ci.city_id = c.city_id
	GROUP BY ci.city_name
), 
	city_rent AS (
	SELECT 
	city_name, 
	estimated_rent,
	ROUND((population * 0.25) / 1000000, 3) estimated_coffee_consumer_in_millions
	FROM monday_coffee.city
)

SELECT 
cr.city_name,
total_revenue,
ct.total_cx,
cr.estimated_coffee_consumer_in_millions,
ct.avg_sale_pr_cx
FROM city_rent cr
LEFT JOIN city_table ct
ON cr.city_name = ct.city_name
ORDER BY total_revenue DESC

