/*
===============================================================================
Script: Create city Tables
===============================================================================
Script Purpose:
    This script creates tables in the 'monday_coffee' schema, dropping existing tables 
    if they already exist.
	  Run this script to re-define the structure of 'city' Tables
===============================================================================
*/


IF OBJECT_ID('monday_coffee.city', 'U') IS NOT NULL
    DROP TABLE monday_coffee.city;

CREATE TABLE monday_coffee.city (
    city_id			INT PRIMARY KEY,
	city_name		VARCHAR(50),	
	population		BIGINT,
	estimated_rent	FLOAT,
	city_rank		INT
);


