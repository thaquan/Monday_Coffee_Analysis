/*
===============================================================================
Script: Create sales Tables
===============================================================================
Script Purpose:
    This script creates tables in the 'monday_coffee' schema, dropping existing tables 
    if they already exist.
	  Run this script to re-define the structure of 'sales' Tables
===============================================================================
*/


IF OBJECT_ID('monday_coffee.sales', 'U') IS NOT NULL
    DROP TABLE monday_coffee.sales;

CREATE TABLE monday_coffee.sales (
    sale_id			INT PRIMARY KEY,
	sale_date		date,
	product_id		INT,
	customer_id		INT,
	total			FLOAT,
	rating			INT,
	CONSTRAINT fk_products FOREIGN KEY (product_id) REFERENCES monday_coffee.products(product_id),
	CONSTRAINT fk_customers FOREIGN KEY (customer_id) REFERENCES monday_coffee.customers(customer_id)
);


