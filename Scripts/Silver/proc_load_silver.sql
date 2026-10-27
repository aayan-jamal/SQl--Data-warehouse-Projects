/*
=========================================================
Stored Procedure: Load Silver Layer (Bronze -> Silver)
============================================================
Script Purpose:
This stored procedure performs the ETL (Extract, Transform, Load) process to populate the 'silver' schema tables from the 'bronze' schema.
Actions Performed:
Truncates Silver tables.
Inserts transformed and cleansed data from Bronze into Silver tables.
Parameters: I
None.
This stored procedure does not accept any parameters or return any values.
Usage Example:
    EXEC Silver.load_silver;
*/

create or ALter Procedure silver.load_silver as
begin
	print '>> Truncating Table: silver.crm_cust_info';
	Truncate Table Silver.crm_cust_info;
	print '>> Inserting Data into: silver.crm_cust_info';
	insert into silver.crm_cust_info(
	cst_id,
	cst_key,
	cst_firstname,
	cst_lastname,
	cst_marital_status,
	cst_gndr,
	cst_create_Date
	)
	select 
	cst_id,
	cst_key,
	trim(cst_firstname) as cst_firstname,
	trim(cst_lastname) as cst_lastname,
	case when upper(trim(cst_marital_status)) = 'S' then 'Single' 
		 when upper(trim(cst_marital_status)) = 'M' then 'Married'
		 Else 'n\a' -- Normalize martial status value to readable format
		 End as cst_marital_status, 
	case when upper(trim(cst_gndr)) = 'F' then 'Female' 
		when upper(trim(cst_gndr)) = 'M' then 'Male'
		Else 'n\a' -- Normalize gender value to readable format
		End as cst_gndr,
	cst_create_date
	from (
	select *,
	ROW_NUMBER() over(partition by cst_id order by cst_create_date) as flag_last
	from [Bronze].[crm_cust_info]
	where cst_id is not null
	)t
	where flag_last = 1  -- selet The most recent record per customer



	---------------------------------------------------------------------
	print '>> Truncating Table: silver.crm_product_info';
	Truncate Table Silver.crm_Product_info;
	print '>> Inserting Data into: silver.crm_product_info';
	insert into silver.crm_Product_info( 
	 prd_id,
	 cat_id,
	 prd_key,
	 prd_nm,
	 prd_cost,
	 prd_line,
	 prd_start_dt,
	 prd_end_dt
	)
	select 
	 prd_id,
	 replace(SUBSTRING(prd_key, 1,5),'-', '_') as cat_id,
	 SUBSTRING(prd_key,7, len(prd_key)) as prd_key,
	 prd_nm,
	 isnull(prd_cost,0) as prd_cost,
	 case when upper(prd_line) = 'M' then 'Mountain'
	 when UPPER(prd_line) = 'R' Then 'Road'
	 when UPPER(prd_line) = 'S' Then 'Other Sales'
	 when UPPER(prd_line) = 'T' Then 'Touring'
	 Else 'n/a'
	 End as prd_line,
	 cast(prd_start_dt As Date) as prd_start_dt,
	 cast(lead(prd_start_dt) over(partition by prd_key order by prd_start_dt)- 1 As Date) as prd_end_dt_test
	from [Bronze].[crm_Product_info]




	-----------------------------------------------------------------------------------------------------------------------
	print '>> Truncating Table: silver.crm_product_info';
	Truncate Table Silver.crm_Product_info;
	print '>> Inserting Data into: silver.crm_product_info';

	insert into [Silver].[crm_Product_info](
	prd_id,
	cat_id,
	prd_key,
	prd_nm,
	prd_cost,
	prd_line,
	prd_start_dt,
	prd_end_dt
	)

	select 
		prd_id,
		replace(SUBSTRING(prd_key, 1,5), '-', '_') as cat_id,
		SUBSTRING(prd_key, 7, len(prd_key)) as prd_key,
		prd_nm,
		ISNULL(prd_cost,0) as prd_cost,
		case when UPPER(prd_line) = 'M' then 'Mountain'
		when UPPER(prd_line) = 'R' Then 'Road'
		when UPPER(prd_line) = 'S' then 'Other Sales'
		when UPPER(prd_line) = 'T' then 'Touring'
		else 'n/a'
		end as prd_line,
		cast(prd_start_dt as Date) as prd_start_dt,
		cast(lead(prd_start_dt) over(partition by prd_key order by prd_start_dt)-1 as date) as prd_end_dt
	from [Bronze].[crm_Product_info];

	-----------------------------------------------------------------------------------------------------------------
	print '>> Truncating Table: silver.crm_sales_details';
	Truncate Table Silver.crm_sales_details;
	print '>> Inserting Data into: silver.crm_sales_details';
	insert into [Silver].[crm_sales_details](
	sls_ord_num,
	sls_prd_key,
	sls_cust_id,
	sls_order_dt,
	sls_ship_dt,
	sls_due_dt,
	sls_sales,
	sls_quantity,
	sls_price
	)
	select sls_ord_num,
			sls_prd_key,
			sls_cust_id,
			case when sls_order_dt = 0 or len(sls_order_dt) != 8
			then Null
			else cast(cast(sls_order_dt as varchar) as Date) End as sls_order_dt,
			case when sls_ship_dt = 0 or len(sls_ship_dt) != 8
			then null
			else cast(cast(sls_ship_dt as varchar) as date) end as sls_ship_dt,
			case when sls_due_dt = 0 or len(sls_due_dt) != 8 then null
			else cast(cast(sls_due_dt as varchar) as date) end as sls_due_dt,
			case when sls_sales <= 0 or sls_Sales is null or sls_sales != sls_quantity * abs(sls_price)
			then sls_quantity * abs(sls_price)
			else sls_sales
			end as sls_sales,
			sls_quantity,
			case when sls_price is null or sls_price <= 0
			then sls_sales / nullif(sls_quantity,0)
			else sls_price
			end as sls_price
	from [Bronze].[crm_sales_details]

	-------------------------------------------------------------------------------------------------
	print '>> Truncating Table: silver.erp_cust_az12';
	Truncate Table Silver.erp_cust_az12;
	print '>> Inserting Data into: silver.erp_cust_az12';
	insert into silver.erp_cust_az12(
	cid, 
	bdate,
	gen
	)
	select 
	case when cid like 'NAS%' then substring(cid, 4, len(cid))
	else cid
	end as cid,
	case when bdate > getdate() then null
	else bdate
	end as BDATE,
	case when upper(trim(gen)) in ('F', 'FEMALE') then 'Female'
			when upper(trim(gen)) in ('M', 'MALE') then 'male'
			else 'n/a'
		end as GEN
	from [Bronze].[erp_cust_az12]

	-----------------------------------------------------------------------------------
	print '>> Truncating Table: silver.erp_loc_a101';
	Truncate Table Silver.erp_loc_a101;
	print '>> Inserting Data into: silver.erp_loc_a101';
	insert into [Silver].[erp_loc_a101](
	Cid,
	CNTRY
	)
	select 
	replace(cid,'-','') as Cid,
	case when upper(trim(CNTRY)) in ('US', 'USA', 'United States') then 'United States'
			when upper(trim(CNTRY)) = ' ' or CNTRY is null then 'n/a'
			when upper(trim(CNTRY)) = 'DE' then 'Germany'
		else CNTRY
		end as CNTRY
	from [Bronze].[erp_loc_a101]
	---------------------------------------------------------------------------------------------------
	print '>> Truncating Table: silver.erp_PX_CAT_G1V2';
	Truncate Table Silver.erp_PX_CAT_G1V2;
	print '>> Inserting Data into: silver.erp_PX_CAT_G1V2';
	insert into [Silver].[erp_PX_CAT_G1V2](
	ID,
	CAT,
	SUBCAT,
	MAINTENANCE
	)
	select trim(id) as id,
			trim(CAT) as CAT,
			trim(SUBCAT) as SUBCAT,
			trim(MAINTENANCE) as MAINTENANCE
			from [Bronze].[erp_PX_CAT_G1V2]
ENd 
 
