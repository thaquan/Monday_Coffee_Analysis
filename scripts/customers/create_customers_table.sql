/*
===============================================================================
Script: Create customers Tables
===============================================================================
Script Purpose:
    This script creates tables in the 'monday_coffee' schema, dropping existing tables 
    if they already exist.
	  Run this script to re-define the structure of 'customers' Tables
===============================================================================
*/


IF OBJECT_ID('monday_coffee.customers', 'U') IS NOT NULL
    DROP TABLE monday_coffee.customers;

CREATE TABLE monday_coffee.customers (
    customer_id			INT PRIMARY KEY,	
	customer_name		VARCHAR(50),	
	city_id				INT,
	CONSTRAINT fk_city FOREIGN KEY (city_id) REFERENCES city(city_id)
);


