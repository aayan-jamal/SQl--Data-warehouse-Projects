/*
====================================================================================
Stored Procedure: Load Bronze Layer (Source -> Bronze)
Script Purpose:
This stored procedure loads data into the 'bronze' schema from external CSV files. It performs the following actions:
- Truncates the bronze tables before loading data.
Uses the BULK INSERT command to load data from csv Files to bronze tables.
I
Parameters:
None.
This stored procedure does not accept any parameters or return any values.
Usage Example:
    EXEC bronze.load_bronze;
===========================================================================================
*/






create or ALter procedure bronze.load_bronze as
Begin
	Declare @start_time Datetime, @end_time Datetime, @batch_start_time Datetime, @batch_end_time Datetime;
	Begin try
	Set @batch_start_time = getdate();
		print'====================================================================';
		print 'Loading Bronze Layer';
		print '===================================================================';

		Print '--------------------------------------------------------------------';
		print ' Loading CRM Tables';
		Print '--------------------------------------------------------------------';

		
		set @start_time = getdate();
		print '>> Truncating Table: bronze.crm_cust_info';
		Truncate table bronze.crm_cust_info;
		print '>> Inserting a Data Into: bronze.crm_cust_info';

		Bulk insert bronze.crm_cust_info
		from 'C:\Users\jauwa\Downloads\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
		with (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		set @end_time = Getdate();

		print '>> Load Total Time Duration: ' + cast(DateDiff(second, @start_time, @end_time)As Nvarchar) + ' Seconds';
		print '>>----------------------------';


		--------------------------------------------------
		set @start_time = getdate();
		print '>> Truncating Table: bronze.crm_product_info';
		Truncate table bronze.crm_product_info;
		print '>> Inserting a Data Into: bronze.crm_product_info';

		Bulk insert bronze.crm_product_info
		from 'C:\Users\jauwa\Downloads\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
		with (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		set @end_time = Getdate();

		print '>> Load Total Time Duration: ' + cast(DateDiff(second, @start_time, @end_time)As Nvarchar) + ' Seconds';
		print '>>-------------------------';
		----------------------------------------------------
		set @start_time = getdate();
		print '>> Truncating Table: Bronze.crm_sales_details';
		Truncate Table Bronze.crm_sales_details
		print '>> Inserting a Data Into: Bronze.crm_sales_details';

		Bulk insert Bronze.crm_sales_details
		from 'C:\Users\jauwa\Downloads\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
		with (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		set @end_time = Getdate();

		print '>> Load Total Time Duration: ' + cast(DateDiff(second, @start_time, @end_time)As Nvarchar) + ' Seconds';
		print '>>-------------------------';

		-----------------------------------------------------------------
		set @start_time = getdate();
		Print '--------------------------------------------------------------------';
		print ' Loading ERP Tables';
		Print '--------------------------------------------------------------------';

		print '>> Truncating Table: bronze.erp_cust_az12';
		Truncate table bronze.erp_cust_az12
		print '>> Inserting a Data Into: bronze.erp_cust_az12';

		Bulk insert bronze.erp_cust_az12
		from 'C:\Users\jauwa\Downloads\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\CUST_AZ12.csv'
		with (
			firstrow = 2,
			fieldterminator = ',',
			Tablock
		);
		set @end_time = Getdate();

		print '>> Load Total Time Duration: ' + cast(DateDiff(second, @start_time, @end_time)As Nvarchar) + ' Seconds';
		print '>>-------------------------';
		-------------------------------------------------------------------------------
		set @start_time = getdate();
		print '>> Truncating Table: bronze.erp_loc_a101';
		Truncate table bronze.erp_loc_a101
		print '>> Inserting a Data Into: bronze.erp_loc_a101';

		Bulk insert bronze.erp_loc_a101
		from 'C:\Users\jauwa\Downloads\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\LOC_A101.csv'
		with (
			firstrow = 2,
			fieldterminator = ',',
			Tablock
		);
		set @end_time = Getdate();

		print '>> Load Total Time Duration: ' + cast(DateDiff(second, @start_time, @end_time)As Nvarchar) + ' Seconds';
		print '>>-------------------------';



		-------------------------------------------------------------------------------
		set @start_time = getdate();
		print '>> Truncating Table: bronze.erp_PX_CAT_G1V2';
		Truncate table bronze.erp_PX_CAT_G1V2
		print '>> Inserting a Data Into:bronze.erp_PX_CAT_G1V2';

		Bulk insert bronze.erp_PX_CAT_G1V2
		from 'C:\Users\jauwa\Downloads\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\PX_CAT_G1V2.csv'
		with (
			firstrow = 2,
			fieldterminator = ',',
			Tablock
	);
	set @end_time = Getdate();

		print '>> Load Total Time Duration: ' + cast(DateDiff(second, @start_time, @end_time)As Nvarchar) + ' Seconds';
		print '>>-------------------------';
		Set @batch_end_time = GETDATE();
		PRINT '==============================================='
		PRINT 'Loading Bronze Layer is Completed';
		PRINT  'Total Load Duration: ' + CAST (DATEDIFF (SECOND, @batch_start_time, @batch_end_time) AS NVARCHAR) + 'seconds';
		PRINT '=================================================='

	End Try
	Begin Catch
		PRINT '====================='
		PRINT 'ERROR OCCURED DURING LOADING BRONZE LAYER'
		PRINT 'Error Message' + ERROR_MESSAGE();
		PRINT 'Error Message' + CAST (ERROR_NUMBER() AS NVARCHAR);
		PRINT 'Error Message' + CAST (ERROR_STATE () AS NVARCHAR);
	End Catch	
END

