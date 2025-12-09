/*
===============================================================================
Script: Create products Tables
===============================================================================
Script Purpose:
    This script creates tables in the 'monday_coffee' schema, dropping existing tables 
    if they already exist.
	  Run this script to re-define the structure of 'products' Tables
===============================================================================
*/


IF OBJECT_ID('monday_coffee.products', 'U') IS NOT NULL
    DROP TABLE monday_coffee.products;

CREATE TABLE monday_coffee.products (
    product_id	    INT PRIMARY KEY,
	product_name    VARCHAR(50),	
	Price           float
);


