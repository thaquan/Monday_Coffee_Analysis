/*
=============================================================
Create Database and Schemas
=============================================================
Script Purpose:
    This script creates a new database named 'Monday_Coffee' after checking if it already exists. 
    If the database exists, it is dropped and recreated. Additionally, the script sets up four schemas 
    within the database: 'Monday_Coffee'.
    
WARNING:
    Running this script will drop the entire 'Monday_Coffee' database if it exists. 
    All data in the database will be permanently deleted. Proceed with caution 
    and ensure you have proper backups before running this script.
*/

USE master;
GO

-- Drop and recreate the 'Monday_Coffee' database
IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'Monday_Coffee')
BEGIN
    ALTER DATABASE Monday_Coffee SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE Monday_Coffee;
END;
GO

-- Create the 'Monday_Coffee' database
CREATE DATABASE Monday_Coffee;
GO

USE Monday_Coffee;
GO

-- Create Schemas
CREATE SCHEMA monday_coffee;
