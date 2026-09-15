COMMIT MESSAGE:
docs(dq): add data quality and referential integrity checks for gold layer

- Add duplicate check scripts for `gold.dim_cust` and `gold.dim_prd`.
- Add a left join validation script for `gold.fact_sales` to check for orphaned records and data integration quality across dimensions.

========================================================================
SQL CODE:
========================================================================

PRINT '=====================================';
PRINT ' Data Quality Checking View 1 : gold.dim_cust';
PRINT '=====================================';

-- Checking duplicate values in view: gold.dim_cust
SELECT 
    cust_id,
    COUNT(*) AS duplicate_count
FROM gold.dim_cust
GROUP BY cust_id
HAVING COUNT(*) > 1;

PRINT '=====================================';
PRINT ' Data Quality Checking View 2 : gold.dim_prd';
PRINT '=====================================';

-- Checking duplicate values in view: gold.dim_prd
SELECT
    product_id,
    COUNT(*) AS duplicate_count
FROM gold.dim_prd
GROUP BY product_id
HAVING COUNT(*) > 1;

PRINT '=====================================';
PRINT ' Data Quality Checking View 3 : gold.fact_sales';
PRINT '=====================================';

-- Checking data integration quality (referential integrity)
SELECT
    f.*
FROM gold.fact_sales AS f
LEFT JOIN gold.dim_cust AS c
    ON f.cust_key = c.cust_key
LEFT JOIN gold.dim_prd AS p
    ON f.product_key = p.product_key
WHERE c.cust_key IS NULL 
   OR p.product_key IS NULL;
