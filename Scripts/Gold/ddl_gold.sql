/*
====================================================================================
DDL Script: Create Gold  Views
====================================================================================
Script Purpose:
    This script creates views for the Gold layer in the data warehouse.
    The Gold layer represents the final dimension and fact tables (Star Schema)
    Each view performs transformations and combines data from the Silver layer to produce a clean, enriched, and business-ready dataset.
Usage:
      These views can be queried directly for analytics and reporting.
================================================================================================
*/


-- Gold layer Design

'CRM'                  'ERP'

'CRM_prd_info' ------> 'erp_px_cat_g1v2'

'CRM_Cust_info -------->  erp_cust_az12'
'CRM_Cust_info ----------> erp_loc_a101


--  =========================================================================================
--  Create Dimension Tables: Gold.dim_customers
-- ======================================================================================
if object_id('gold.dim_customers', 'V') is Not null
	Drop view gold.dim_customers;
go
CREATE view gold.dim_customers as
select 
        row_number() over(order by cst_id) as customer_key,
        ci.cst_id as Customer_id,
		ci.cst_key as Customer_Number,
		ci.cst_firstname as First_Name,
		ci.cst_lastname as Last_Name,
        ce.CNTRY as Country,
		ci.cst_marital_status as Marital_Status,
		case when ci.cst_gndr != 'n/a' Then ci.cst_gndr
			else coalesce(ca.GEN, 'n/a')
		end as new_gender,
        ca.BDATE as birthdate,
		ci.cst_create_date as create_date
from silver.crm_cust_info ci
left join silver.erp_cust_az12 ca
on ci.cst_key = ca.Cid
left join silver.erp_loc_a101 ce
on ci.cst_key = ce.cid;


------------------------------------------
--  =========================================================================================
--  Create Dimension Tables: Gold.dim_products
-- ======================================================================================
if object_id('gold.dim_products', 'V') is Not null
	Drop view gold.dim_products;
go
create view gold.dim_products as
select 
		row_number() over(order by cast(p.prd_start_dt as date), p.prd_key) as Product_key,
		p.prd_id as product_id,
		p.prd_key as product_number,
		p.prd_nm as product_name,
		p.cat_id as category_id,
		pc.cat as Category,
		pc.subcat as Subcategory,
		pc.maintenance as maintenance,
		p.prd_cost as product_cost,
		p.prd_line as product_line,
		cast(p.prd_start_dt as date) as start_date
from [Silver].[crm_Product_info] p
left join [Silver].[erp_PX_CAT_G1V2] pc
on p.cat_id = pc.id
where prd_end_dt is null -- filter out all historical data

-------------------------------------------------------------------------------
--  =========================================================================================
--  Create Fact Tables: Gold.fact_sales
-- ======================================================================================
if object_id('gold.fact_sales', 'V') is Not null
	Drop view gold.fact_sales;
go
create view gold.fact_sales as
select sd.sls_ord_num as order_number,
		p.product_key,
		c.customer_key,
		sd.sls_order_dt as order_date,
		sd.sls_ship_dt as ship_date,
		sd.sls_due_dt as due_date,
		sd.sls_sales as sales_amount,
		sd.sls_quantity as quantity,
		sd.sls_price as price
from [Silver].[crm_sales_details] sd
left join gold.dim_products p
on sd.sls_prd_key = p.Product_number
left join [Gold].[dim_customers] c
on sd.sls_cust_id = c.customer_id



