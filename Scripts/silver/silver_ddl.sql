/*
===============================================================================
Script Name   : DDL Script - Silver Layer Table Creation
Description   : Creates cleaned, standardized tables in the Silver schema for 
                CRM and ERP datasets. Drops existing tables prior to 
                recreation to support idempotent deployment.
Target Schema : silver
Source Systems: CRM, ERP
Tables Created:
                 1. silver.crm_cust_info
                 2. silver.crm_prd_info
                 3. silver.crm_sales_details
                 4. silver.erp_loc_a101
                 5. silver.erp_cust_az12
                 6. silver.erp_px_cat_giv2
===============================================================================
*/

-- ============================================================================
-- Table: silver.crm_cust_info
-- ============================================================================
IF OBJECT_ID('silver.crm_cust_info', 'U') IS NOT NULL
    DROP TABLE silver.crm_cust_info;

CREATE TABLE silver.crm_cust_info (
    cst_id          INT,
    cst_key         NVARCHAR(80),
    first_name      NVARCHAR(80),
    last_name       NVARCHAR(80),
    Martial_status  VARCHAR(20),
    cst_gndr        VARCHAR(20),
    create_date     DATETIME2 DEFAULT GETDATE()
);

-- ============================================================================
-- Table: silver.crm_prd_info
-- ============================================================================
IF OBJECT_ID('silver.crm_prd_info', 'U') IS NOT NULL
    DROP TABLE silver.crm_prd_info;

CREATE TABLE silver.crm_prd_info (
    prd_id          INT,
    prd_cust_id     NVARCHAR(80),
    prd_key         NVARCHAR(80),
    prd_nm          NVARCHAR(80),
    prd_cost        INT,
    prd_line        NVARCHAR(40),
    prd_start_dt    DATE,
    prd_end_dt      DATE
);

-- ============================================================================
-- Table: silver.crm_sales_details
-- ============================================================================
IF OBJECT_ID('silver.crm_sales_details', 'U') IS NOT NULL
    DROP TABLE silver.crm_sales_details;

CREATE TABLE silver.crm_sales_details (
    sls_ord_num     NVARCHAR(80),
    sls_prd_key     NVARCHAR(80),
    sls_cust_id     INT,
    sls_ord_dt      DATE,
    sls_ship_dt     DATE,
    sls_due_dt      DATE,
    sls_sales       INT,
    sls_quantity    INT,
    sls_price       INT,
    create_date     DATETIME2 DEFAULT GETDATE()
);

-- ============================================================================
-- Table: silver.erp_loc_a101
-- ============================================================================
IF OBJECT_ID('silver.erp_loc_a101', 'U') IS NOT NULL
    DROP TABLE silver.erp_loc_a101;

CREATE TABLE silver.erp_loc_a101 (
    cid             NVARCHAR(89),
    country         NVARCHAR(78),
    create_date     DATETIME2 DEFAULT GETDATE()
);

-- ============================================================================
-- Table: silver.erp_cust_az12
-- ============================================================================
IF OBJECT_ID('silver.erp_cust_az12', 'U') IS NOT NULL
    DROP TABLE silver.erp_cust_az12;

CREATE TABLE silver.erp_cust_az12 (
    cid             NVARCHAR(80),
    bdate           DATE,
    gender          NVARCHAR(20),
    create_date     DATETIME2 DEFAULT GETDATE()
);

-- ============================================================================
-- Table: silver.erp_px_cat_giv2
-- ============================================================================
IF OBJECT_ID('silver.erp_px_cat_giv2', 'U') IS NOT NULL
    DROP TABLE silver.erp_px_cat_giv2;

CREATE TABLE silver.erp_px_cat_giv2 (
    id              NVARCHAR(80),
    categorie       NVARCHAR(80),
    sub_cat         NVARCHAR(40),
    maintenance     NVARCHAR(10),
    create_date     DATETIME2 DEFAULT GETDATE()
);
