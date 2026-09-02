-- =========================================================================
-- BRONZE LAYER TABLES
-- =========================================================================

-- 1. Table: bronze.crm_cust_info
IF OBJECT_ID ('bronze.crm_cust_info','u') IS NOT NULL
    DROP TABLE bronze.crm_cust_info;

CREATE TABLE bronze.crm_cust_info (
    cst_id             INT,
    cst_key            NVARCHAR(80),
    cst_first_name     NVARCHAR(70),
    cst_last_name      NVARCHAR(80),
    cst_martial_status NVARCHAR(10),
    cst_gndr           NVARCHAR(10),
    cst_create_date    DATE
);
GO

-- 2. Table: bronze.crm_prd_info
IF OBJECT_ID ('bronze.crm_prd_info','u') IS NOT NULL
    DROP TABLE bronze.crm_prd_info;

CREATE TABLE bronze.crm_prd_info (
    prd_id       INT,
    prd_key      NVARCHAR(80),
    prd_nm       NVARCHAR(70),
    prd_cost     NVARCHAR(69),
    prd_line     NVARCHAR(20),
    prd_start_dt DATE,
    prd_end_dt   DATE
);
GO

-- 3. Table: bronze.crm_sales_details
IF OBJECT_ID ('bronze.crm_sales_details','u') IS NOT NULL
    DROP TABLE bronze.crm_sales_details;

CREATE TABLE bronze.crm_sales_details (
    sls_ord_num  NVARCHAR(78),
    sls_prd_key  NVARCHAR(67),
    sls_cust_id  INT,
    sls_ord_dt   NVARCHAR(56),
    sls_ship_dt  NVARCHAR(56),
    sls_due_dt   NVARCHAR(56),
    sls_sales    NVARCHAR(16),
    sls_quantity NVARCHAR(23),
    sls_price    NVARCHAR(24)
);
GO


-- =========================================================================
-- SILVER LAYER TABLES
-- =========================================================================

-- 4. Table: silver.erp_cust_az12
IF OBJECT_ID ('silver.erp_cust_az12','u') IS NOT NULL
    DROP TABLE silver.erp_cust_az12;

CREATE TABLE silver.erp_cust_az12 (
    cid    NVARCHAR(40),
    bdate  DATE,
    gender NVARCHAR(23)
);
GO

-- 5. Table: silver.erp_loc_A101
IF OBJECT_ID ('silver.erp_loc_A101' ,'u') IS NOT NULL
    DROP TABLE silver.erp_loc_A101;

CREATE TABLE silver.erp_loc_A101 (
    cid     NVARCHAR(45),
    country NVARCHAR(56)
);
GO

-- 6. Table: silver.erp_px_cat_giv2
IF OBJECT_ID ('silver.erp_px_cat_giv2' ,'u') IS NOT NULL
    DROP TABLE silver.erp_px_cat_giv2;

CREATE TABLE silver.erp_px_cat_giv2 (
    id          NVARCHAR(25),
    categorie   NVARCHAR(45),
    sub_cat     NVARCHAR(45),
    maintenance NVARCHAR(45)
);
GO
