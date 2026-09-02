COMMIT MESSAGE:
feat: implement orchestration procedure for bronze layer ingestion

- Create automated stored procedure bronze.table_procedure
- Orchestrate DROP, CREATE, and BULK INSERT operations for CSV data files
- Add runtime logging, execution duration metrics, and TRY-CATCH error handling

=========================================================================
SQL SCRIPT FILE CONTENT:
=========================================================================
CREATE OR ALTER PROCEDURE bronze.table_procedure AS
BEGIN
    DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME;

    BEGIN TRY
        SET @batch_start_time = GETDATE();

        PRINT '================================================='
        PRINT ' bronze Layer Loading '
        PRINT '================================================='

        PRINT '-------------------------------------------------'
        PRINT ' loading crm tables ' 
        PRINT '-------------------------------------------------'

        IF OBJECT_ID ('bronze.crm_cust_info','u') IS NOT NULL
            DROP TABLE bronze.crm_cust_info;

        PRINT '-------------------------------------------------'
        PRINT ' loadiing table : bronze.crm_cust_info '
        PRINT '-------------------------------------------------'

        CREATE TABLE bronze.crm_cust_info (
            cst_id INT,
            cst_key NVARCHAR(80),
            cst_first_name NVARCHAR(70),
            cst_last_name NVARCHAR(80),
            cst_martial_status NVARCHAR(10),
            cst_gndr NVARCHAR (10),
            cst_create_date DATE
        );

        SET @start_time = GETDATE();

        PRINT '>> Truncatting table : bronze.crm_cust_info'
        TRUNCATE TABLE bronze.crm_cust_info;

        PRINT '>> inserting data into: bronze.crm_cust_info'
        BULK INSERT bronze.crm_cust_info 
        FROM 'C:\Users\Lenovo\Downloads\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm/cust_info.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR =',',
            TABLOCK 
        );

        SET @end_time = GETDATE();
        PRINT '>> load duration ' + CAST(DATEDIFF(SECOND,@start_time,@end_time) AS NVARCHAR); 
        PRINT '==========================';

        IF OBJECT_ID ('bronze.crm_prd_info','u') IS NOT NULL
            DROP TABLE bronze.crm_prd_info;

        PRINT '-------------------------------------------------'
        PRINT ' loadiing table : bronze.crm_prd_info '
        PRINT '-------------------------------------------------'

        CREATE TABLE bronze.crm_prd_info (
            prd_id INT,
            prd_key NVARCHAR (80),
            prd_nm NVARCHAR(70),
            prd_cost NVARCHAR (69),
            prd_line NVARCHAR (20),
            prd_start_dt DATE,
            prd_end_dt DATE
        );

        SET @start_time = GETDATE();
        PRINT '>> Truncating tables: bronze.crm_prd_info'
        TRUNCATE TABLE bronze.crm_prd_info;

        PRINT '>> inserting data into : bronze.crm_prd_info'
        BULK INSERT bronze.crm_prd_info
        FROM 'C:\Users\Lenovo\Downloads\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm/prd_info.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK 
        );

        SET @end_time = GETDATE();
        PRINT '>> loadiing time ' + CAST(DATEDIFF(SECOND,@start_time , @end_time) AS NVARCHAR); 
        PRINT '==========================';

        IF OBJECT_ID ('bronze.crm_sales_details','u') IS NOT NULL
            DROP TABLE bronze.crm_sales_details;

        PRINT '-------------------------------------------------'
        PRINT ' loadiing table : bronze.crm_sales_details '
        PRINT '-------------------------------------------------'

        CREATE TABLE bronze.crm_sales_details (
            sls_ord_num NVARCHAR(78),
            sls_prd_key NVARCHAR (67),
            sls_cust_id INT,
            sls_ord_dt NVARCHAR (56),
            sls_ship_dt NVARCHAR(56),
            sls_due_dt NVARCHAR(56),
            sls_sales NVARCHAR (16),
            sls_quantity NVARCHAR(23),
            sls_price NVARCHAR(24)
        );
 
        SET @start_time = GETDATE();
        PRINT '>> Truncating table: bronze.crm_sales_details'
        TRUNCATE TABLE bronze.crm_sales_details;
 
        PRINT '>> inserting data into :bronze.crm_sales_details'
        BULK INSERT bronze.crm_sales_details
        FROM 'C:\Users\Lenovo\Downloads\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm/sales_details.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );

        SET @end_time = GETDATE();
        PRINT ' >> loading time ' + CAST(DATEDIFF(SECOND,@start_time,@end_time) AS NVARCHAR); 
        PRINT '==========================';

        PRINT '-------------------------------------------------'
        PRINT ' loading erp tables '
        PRINT '-------------------------------------------------'

        IF OBJECT_ID ('silver.erp_cust_az12','u') IS NOT NULL
            DROP TABLE silver.erp_cust_az12;

        PRINT '-------------------------------------------------'
        PRINT ' loadiing table : silver.erp_cust_az12 '
        PRINT '-------------------------------------------------'

        CREATE TABLE silver.erp_cust_az12(
            cid NVARCHAR(40),
            bdate DATE,
            gender NVARCHAR(23)
        );

        SET @start_time = GETDATE();
        PRINT '>> Truncating table: silver.erp_cust_az12'
        TRUNCATE TABLE silver.erp_cust_az12;

        PRINT '>> inserting data into :silver.erp_cust_az12'
        BULK INSERT silver.erp_cust_az12
        FROM 'C:\Users\Lenovo\Downloads\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp/cust_az12.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );

        SET @end_time = GETDATE();
        PRINT ' >>loading table ' + CAST(DATEDIFF(SECOND,@start_time,@end_time) AS NVARCHAR); 
        PRINT '===================';

        PRINT '-------------------------------------------------'
        PRINT ' loadiing table : silver.erp_loc_A101 '
        PRINT '-------------------------------------------------'

        IF OBJECT_ID ('silver.erp_loc_A101' ,'u') IS NOT NULL
            DROP TABLE silver.erp_loc_A101;

        CREATE TABLE silver.erp_loc_A101(
            cid NVARCHAR(45),
            country NVARCHAR(56)
        );

        SET @start_time = GETDATE();
        PRINT ' >> Truncating table : silver.erp_loc_A101'
        TRUNCATE TABLE silver.erp_loc_A101;

        PRINT '>> inserting data into : silver.erp_loc_A101'
        BULK INSERT silver.erp_loc_A101
        FROM 'C:\Users\Lenovo\Downloads\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp/loc_a101.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );

        SET @end_time = GETDATE();
        PRINT '>> loading table ' + CAST(DATEDIFF(SECOND,@start_time,@end_time) AS NVARCHAR);
        PRINT '====================';

        IF OBJECT_ID ('silver.erp_px_cat_giv2' ,'u') IS NOT NULL
            DROP TABLE silver.erp_px_cat_giv2;

        PRINT '-------------------------------------------------'
        PRINT ' loadiing table : silver.erp_px_cat_giv2 '
        PRINT '-------------------------------------------------'

        CREATE TABLE silver.erp_px_cat_giv2(
            id NVARCHAR (25),
            categorie NVARCHAR(45),
            sub_cat NVARCHAR(45),
            maintenance NVARCHAR (45)
        );

        SET @start_time = GETDATE();
        PRINT '>> Truncating table : silver.erp_px_cat_giv2'
        TRUNCATE TABLE silver.erp_px_cat_giv2;

        PRINT '>> inserting data into: silver.erp_px_cat_giv2'
        BULK INSERT silver.erp_px_cat_giv2
        FROM 'C:\Users\Lenovo\Downloads\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp/PX_CAT_G1V2.csv'
        WITH(
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );

        SET @end_time = GETDATE();
        PRINT '>> loading data ' + CAST(DATEDIFF(SECOND,@start_time , @end_time) AS NVARCHAR); 
        PRINT '=================';

        SET @batch_end_time = GETDATE();

        PRINT ' =================================='
        PRINT '>> LOADING BRONZE LAYER ' + CAST(DATEDIFF(SECOND,@batch_start_time , @batch_end_time) AS NVARCHAR) + ' seconds'
        PRINT ' =================================='

    END TRY

    BEGIN CATCH
        PRINT '==========================='
        PRINT '>> error occured during loading '
        PRINT 'Error Message '+ ERROR_MESSAGE();
        PRINT 'Error number' + CAST(ERROR_NUMBER() AS NVARCHAR);
        PRINT '==========================='
    END CATCH
END;
