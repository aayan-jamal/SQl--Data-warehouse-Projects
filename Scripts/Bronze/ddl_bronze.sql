/*
===================================================================
DDL Script: Create Bronze Tables
Script Purpose:
This script creates tables in the 'bronze' schema, dropping existing tables if they already exist.
Run this script to re-define the DDL structure of 'bronze' Tables
=======================================================================I
*/



-- DDl Scripts For Csv Files

if object_id ('bronze.crm_cust_info', 'U') IS NOT NULL
   Drop table bronze.crm_cust_info;
create table bronze.crm_cust_info(
cst_id INT,	
cst_key	NVARCHAR(25),
cst_firstname nvarchar(50),
cst_lastname nvarchar(50),
cst_marital_status nvarchar(50),
cst_gndr nvarchar(50),
cst_create_date date
);


if object_id ('bronze.crm_Product_info', 'U') IS NOT NULL
	Drop table bronze.crm_Product_info;
Create Table bronze.crm_Product_info(
prd_id Int,
prd_key nvarchar(50),
prd_nm nvarchar(50),
prd_cost int,
prd_line nvarchar(25),
prd_start_dt DATETIME,
prd_end_dt DATETIME,

);

if object_id('bronze.crm_sales_details', 'U') IS NOT NULL
	drop table bronze.crm_sales_details;
create table bronze.crm_sales_details(
sls_ord_num	nvarchar(50),
sls_prd_key nvarchar(50),
sls_cust_id nvarchar(50),
sls_order_dt nvarchar(50),
sls_ship_dt int,
sls_due_dt int,
sls_sales int,
sls_quantity int,
sls_price int
);

if object_id('bronze.erp_loc_a101', 'U') IS NOT NULL
	drop table bronze.erp_loc_a101;
Create table bronze.erp_loc_a101(
CID nvarchar(50),
CNTRY nvarchar(50)
);

if object_id('bronze.erp_cust_az12', 'U') IS NOT NULL
	drop table bronze.erp_cust_az12;
create table bronze.erp_cust_az12 (
CID	nvarchar(50),
BDATE Date,
GEN nvarchar(20)
);

if object_id('bronze.erp_PX_CAT_G1V2', 'U') IS NOT NULL
	drop table bronze.erp_PX_CAT_G1V2;
create table bronze.erp_PX_CAT_G1V2(
ID nvarchar(50),
CAT nvarchar(50),
SUBCAT nvarchar(50),
MAINTENANCE nvarchar(25)
);



