/*
==================================================================================
stored procedure: Load Bronze Layer(source->Bronze)
==================================================================================
Script Purpose:
    This stored procedure loads data into the 'bronze' schema from external csv files.
    It performs the following actions:
      -  Truncates the bronze tables before loading the data
      -  Uses the 'BULK INSERT' command to load the data from csv files to bronze tables
parameters:
None
This stored procedure does not accept any parameters or return any values.

Usage example:
  EXEC bronze.load_bronaze;
This single cmd will load the whole script bcoz of sql wrapped in the stored procedure*/


--we have to run this script on frequent basis in order to load the new content to the dwh so we create stored procedure
CREATE OR ALTER PROCEDURE bronze.load_bronze AS 
BEGIN
	DECLARE @start_time DATETIME,@end_time DATETIME; 
	DECLARE @batch_start_time DATETIME, @batch_end_time DATETIME; 
	BEGIN TRY 
		SET @batch_start_time = GETDATE(); 
		PRINT '==================================================';
		PRINT 'Loading Bronze Layer'; 
		PRINT '==================================================';
		-- -------------------------------------------------- 
		-- 1\. CRM Tables 
		-- -------------------------------------------------- 
		PRINT '--------------------------------------------------'; 
		PRINT 'Loading CRM Tables'; 
		PRINT '--------------------------------------------------';
		SET @start_time = GETDATE();
 
			-- ===================================================================== 
			-- 1\. Load: bronze.crm\_cust\_info
			-- ===================================================================== 
			PRINT'>> Truncating and Loading: bronze.crm_cust_info';
			TRUNCATE TABLE bronze.crm_cust_info; 
			-- to not get duplicate on running the query twice ..truncate fist then load into empty table

			BULK INSERT bronze.crm_cust_info 
			FROM 'C:\Users\HP\Downloads\sql-data-warehouse-project\sql-data-warehouse-project\01_datasets\source_crm\cust_info.csv' 
			WITH ( 
			FIRSTROW = 2, 
			FIELDTERMINATOR = ',', 
			TABLOCK --quires a temporary table-level lock on the destination table during the bulk load operation to boost performance by minimizing lock overhead.
			);
			SET @end_time = GETDATE();
			PRINT '>> crm_cust_info Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS VARCHAR) + ' seconds';

			SET @start_time = GETDATE();
			
			-- ===================================================================== 
			-- 2\. Load: bronze.crm\_prd\_info
			-- ===================================================================== 
			PRINT '>> Truncating and Loading: bronze.crm_prd_info'; 
			TRUNCATE TABLE bronze.crm_prd_info; 
			BULK INSERT bronze.crm_prd_info 
			FROM 'C:\Users\HP\Downloads\sql-data-warehouse-project\sql-data-warehouse-project\01_datasets\source_crm\prd_info.csv'
			WITH ( 
			FIRSTROW = 2, 
			FIELDTERMINATOR = ',', 
			TABLOCK );
			SET @end_time = GETDATE(); 
			PRINT '>> crm_prd_info Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS VARCHAR) + ' seconds';

			SET @start_time = GETDATE();
			-- =====================================================================
			-- 3\. Load: bronze.crm\_sales\_details 
			-- ===================================================================== 
			PRINT '>>Truncating and Loading: bronze.crm_sales_details'; 
			TRUNCATE TABLE bronze.crm_sales_details;
			BULK INSERT bronze.crm_sales_details
			FROM 'C:\Users\HP\Downloads\sql-data-warehouse-project\sql-data-warehouse-project\01_datasets\source_crm\sales_details.csv' 
			WITH ( 
			FIRSTROW = 2, 
			FIELDTERMINATOR = ',',
			TABLOCK 
			); 
			SET @end_time = GETDATE();
			PRINT '>>crm\_sales\_details Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS VARCHAR) + ' seconds';
	
			
			-- -------------------------------------------------- 
			-- 2\. ERP Tables -- --------------------------------------------------
			PRINT '--------------------------------------------------'; 
			PRINT 'Loading ERP Tables'; 
			PRINT '--------------------------------------------------';
			-- =====================================================================
			-- 4\. Load: bronze.erp\_cust\_az12
			-- ===================================================================== 
			SET @start_time = GETDATE();
			PRINT '>> Truncating and Loading: bronze.erp_cust_az12';
			TRUNCATE TABLE bronze.erp_cust_az12; 

			BULK INSERT bronze.erp_cust_az12 
			FROM 'C:\Users\HP\Downloads\sql-data-warehouse-project\sql-data-warehouse-project\01_datasets\source_erp\CUST_AZ12.csv'
			WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',', 
			TABLOCK
			); 
			SET @end_time = GETDATE();
			PRINT '>>erp\_cust\_az12 Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS VARCHAR) + ' seconds';
		
			-- ===================================================================== 
			-- 5\. Load: bronze.erp\_loc\_a101
			-- ===================================================================== 
			PRINT '>>Truncating and Loading: bronze.erp_loc_a101'; 
			SET @start_time = GETDATE();
			TRUNCATE TABLE bronze.erp_loc_a101; 
			BULK INSERT bronze.erp_loc_a101 
			FROM 'C:\Users\HP\Downloads\sql-data-warehouse-project\sql-data-warehouse-project\01_datasets\source_erp\LOC_A101.csv' 
			WITH ( 
			FIRSTROW = 2,
			FIELDTERMINATOR = ',', 
			TABLOCK
			); 
			SET @end_time = GETDATE();
			PRINT '>> erp_loc_a101 Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS VARCHAR) + ' seconds';
			
			-- ===================================================================== 
			-- 6\. Load: bronze.erp\_px\_cat\_g1v2 
			-- ===================================================================== 
			SET @start_time = GETDATE();
			PRINT '>> Truncating and Loading: bronze.erp_px_cat_g1v2'; 
			TRUNCATE TABLE bronze.erp_px_cat_g1v2;
			BULK INSERT bronze.erp_px_cat_g1v2
			FROM 'C:\Users\HP\Downloads\sql-data-warehouse-project\sql-data-warehouse-project\01_datasets\source_erp\PX_CAT_G1V2.csv' 
			WITH (
			FIRSTROW = 2, 
			FIELDTERMINATOR = ',', 
			TABLOCK
			);
			SET @end_time = GETDATE();
			PRINT '>> erp_px_cat_g1v2 Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS VARCHAR) + ' seconds';

		-- Batch Duration Summary 
			SET @batch_end_time = GETDATE(); 
			PRINT '=================================================='; 
			PRINT 'Loading Bronze Layer Completed';
			PRINT '>>Total Batch Duration: ' + CAST(DATEDIFF(second, @batch_start_time, @batch_end_time) AS VARCHAR) + ' seconds'; 
			PRINT '=================================================='; 
	END TRY 
	BEGIN CATCH 
			PRINT '=================================================='; 
			PRINT 'ERROR OCCURRED DURING BRONZE LOADING'; 
			PRINT 'Error Message: ' + ERROR_MESSAGE();
			PRINT 'Error Number : ' + CAST(ERROR_NUMBER() AS VARCHAR); 
			PRINT 'Error State : ' + CAST(ERROR_STATE() AS VARCHAR); 
			PRINT '=================================================='; 
	END CATCH 
END;
GO
--### **How to Execute &amp; Test**

--Run this command in a query window to trigger the whole Bronze pipeline[6]:


--  EXEC bronze.load_bronze;
EXEC bronze.load_bronze;

--HERE WE COMPLETED OUR ETL PROCESS IN BRONZE LAYER..
--WE CAN ADD MANY MORE STUFF TO ETL LIKE
--DATA QUALITY MEASURES
--SPEED
