/*
=======================================================
DDL Script: Create Silver Tables
========================================================
Script Purpose:
This script creates tables in the 'silver' schema, dropping existing tables
if they already exist.
Run this script to re-define the DDL structure of 'bronze' Tables
*/

-- DDl Scripts For Csv Files

if object_id ('silver.crm_cust_info', 'U') IS NOT NULL
   Drop table silver.crm_cust_info;
create table silver.crm_cust_info(
cst_id INT,	
cst_key	NVARCHAR(25),
cst_firstname nvarchar(50),
cst_lastname nvarchar(50),
cst_marital_status nvarchar(50),
cst_gndr nvarchar(50),
cst_create_date date,
dwh_create_date datetime2 default getdate()
);
GO


if object_id ('silver.crm_Product_info', 'U') IS NOT NULL
	Drop table silver.crm_Product_info;
Create Table silver.crm_Product_info(
prd_id Int,
cat_id nvarchar(50),
prd_key nvarchar(50),
prd_nm nvarchar(50),
prd_cost int,
prd_line nvarchar(25),
prd_start_dt DATETIME,
prd_end_dt DATETIME,
dwh_create_date datetime2 default getdate()
);
GO

if object_id('silver.crm_sales_details', 'U') IS NOT NULL
	drop table silver.crm_sales_details;
create table silver.crm_sales_details(
sls_ord_num	nvarchar(50),
sls_prd_key nvarchar(50),
sls_cust_id nvarchar(50),
sls_order_dt nvarchar(50),
sls_ship_dt int,
sls_due_dt int,
sls_sales int,
sls_quantity int,
sls_price int,
dwh_create_date datetime2 default getdate()
);
GO

if object_id('silver.erp_loc_a101', 'U') IS NOT NULL
	drop table silver.erp_loc_a101;
Create table silver.erp_loc_a101(
CID nvarchar(50),
CNTRY nvarchar(50),
dwh_create_date datetime2 default getdate()
);

if object_id('silver.erp_cust_az12', 'U') IS NOT NULL
	drop table silver.erp_cust_az12;
create table silver.erp_cust_az12 (
CID	nvarchar(50),
BDATE Date,
GEN nvarchar(20),
dwh_create_date datetime2 default getdate()
);
GO

if object_id('silver.erp_PX_CAT_G1V2', 'U') IS NOT NULL
	drop table silver.erp_PX_CAT_G1V2;
create table silver.erp_PX_CAT_G1V2(
ID nvarchar(50),
CAT nvarchar(50),
SUBCAT nvarchar(50),
MAINTENANCE nvarchar(25),
dwh_create_date datetime2 default getdate()
);
GO



