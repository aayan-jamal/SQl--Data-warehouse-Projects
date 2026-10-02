/*
===============================================================
Create Database and Schemas
===============================================================
Script Purpose:
This script creates a new database named 'DataWarehouse' after checking if it already exists.
If the database exists, it is dropped and recreated. Additionally, the script sets up three schemas within the database: 'bronze', 'silver', and 'gold'.

WARNING:
Running this script will drop the entire 'DataWarehouse' database if it exists.
All data in the database will be permanently deleted. Proceed with caution
and ensure you have proper backups before running this script.
*/








use master;
Go

-- Drop and Recreate the 'Datawarehouse' Database
If Exists (Select 1 from sys.databases where name = 'DataWarehouse')
Begin
  Alter Database DataWarehouse set SINGLE_USER WITH ROLLBACK IMMEDIATE;
  Drop Database DataWarehouse;
End;
Go
  
-- Create the 'DataWarehouse' Database
Create Database DataWarehouse;
Go
use DataWarehouse;
Go

-- Create Schemas
CREATE SCHEMA Bronze;
Go

Create Schema Silver;
Go
  
Create Schema Gold;
