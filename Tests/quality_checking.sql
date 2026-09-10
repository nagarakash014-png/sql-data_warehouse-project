-------------------------------------------------------------------------------
-- DATA QUALITY AUDIT SCRIPT: BRONZE LAYER
-- Purpose : Automated checks for duplicate keys, null values, invalid dates,
--           formatting issues, and calculated field metrics across CRM & ERP tables.
-- Target  : Bronze Layer (CRM & ERP Sources)
-------------------------------------------------------------------------------

print'=============================='
 print' Data Quality Checking table 1 : bronze.crm_cust_info'
 print'=============================='

  --checking duplicacy in cst_id

 select 
 cst_id,
 count(*)
 from bronze.crm_cust_info
 group by cst_id
 having count(*)>1  or cst_id is null

 -- checking the latest in cst_id to remove the duplicates

select 
*,
row_number() over( partition by cst_key order by cst_create_date desc) flag_list
from bronze.crm_cust_info



-- checking the leading and trailling spaces in cst_first_name and cst_last_name column

select
cst_first_name
from  bronze.crm_cust_info
where cst_first_name !=trim(cst_first_name);

select
cst_last_name
from  bronze.crm_cust_info
where cst_last_name !=trim(cst_last_name);

-- checking the data quality of cst_martial_status and cst_gender column

select distinct
cst_martial_status
from bronze.crm_cust_info;

select distinct
cst_gndr
from bronze.crm_cust_info

-- checking the data quality of cst_create_date column

select 
cst_create_date 
from bronze.crm_cust_info
where len(cst_create_date) !=10 or len(cst_create_date) <=0;

select 
cst_create_date 
from bronze.crm_cust_info
where cst_create_date > '2027-01-01' or cst_create_date < '2020-01-01'

 print'=============================='
 print' Data Quality Checking table 2 : bronze.crm_prd_info'
 print'=============================='

--checking duplicacy in prd_id

select 
prd_id,
count(*)
from bronze.crm_prd_info
group by prd_id
having count(*)>1

-- checking the unique data values in prd_nm column

select distinct
prd_nm
from bronze.crm_prd_info
where prd_nm is null or prd_nm = ''

-- checking the null and negative or zero int in prd_cost

select 
prd_cost
from bronze.crm_prd_info
where prd_cost is null or prd_cost<=0

-- checking the unique data values in prd_line column

select distinct
prd_line
from  bronze.crm_prd_info

-- checking the date columns  (prd_start_dt and prd_end_dt) data quality of table crm_prd_info  
select
prd_start_dt,
prd_end_dt
from bronze.crm_prd_info
where prd_start_dt > prd_end_dt

 print'=============================='
 print' Data Quality Checking table 3 : bronze.crm_sales_details'
 print'=============================='

--checkng duplicacy in sls_cust_id

select 
sls_cust_id,
count(*)
from  bronze.crm_sales_details
group by sls_cust_id
having count(*)>1

-- checking the quality of dates column (sls_ord_dt,sls_ship_dt,sls_due_dt)

select
sls_ord_dt,
sls_ship_dt,
sls_due_dt
from bronze.crm_sales_details
where sls_ord_dt > sls_ship_dt  or sls_ord_dt >  sls_due_dt or sls_ship_dt > sls_due_dt;


select
*
from(
select
*
from(
Select
sls_ord_dt,
sls_ship_dt,
sls_due_dt
from bronze.crm_sales_details
where sls_ord_dt !=8 or sls_ord_dt<=0)l
where sls_ship_dt !=8 or sls_ship_dt<=0)k
where sls_due_dt !=8  or sls_due_dt<=0;

-- checking the data quality of  business required columns (sls_sales,sls_quantity,sls_price)

select
sls_sales,
sls_quantity,
sls_price
from bronze.crm_sales_details
where sls_sales != cast(sls_price as int) * cast(sls_quantity as int)

select
sls_sales,
sls_quantity,
sls_price
from bronze.crm_sales_details
where sls_quantity != cast(sls_sales as int) / cast(sls_price as int)

select
sls_sales,
sls_quantity,
sls_price
from bronze.crm_sales_details
where sls_price != cast(sls_sales as int) / cast(sls_quantity as int)

 print'=============================='
 print' Data Quality Checking table 4 : bronze.erp_loc_a101'
 print'=============================='

 --checking duplicacy in cid

select 
cid,
count(*)
from bronze.erp_loc_a101
group by cid
having count(*)>1

-- checking the unique data values in country column

select distinct
country
from bronze.erp_loc_a101

 print'=============================='
 print' Data Quality Checking table 5 : bronze.erp_cust_az12'
 print'=============================='

-- checking the duplicacy in cid

 select 
 cid,
 count(*)
 from bronze.erp_cust_az12
 group by cid
 having count(*)>1

 -- checking the data quality of bdate column
 select 
 bdate
 from bronze.erp_cust_az12
 where len(bdate) !=10 or len(bdate) <=0

 select 
 bdate 
 from bronze.erp_cust_az12
 where bdate >'2028-01-01'

  -- checking the unique values in column gender
 select distinct
 gender
 from bronze.erp_cust_az12

 print'=============================='
 print' Data Quality Checking table 6 : bronze.erp_px_cat_giv2'
 print'=============================='

 -- checking duplicacy in id
 select
 id,
 count(*)
 from bronze.erp_px_cat_giv2
 group by id
 having count(*)>1

 -- checking unique values in categorie

 select distinct
 categorie
 from bronze.erp_px_cat_giv2

 -- cheking the trailling and leading spaces in categorie

  select 
 categorie
 from bronze.erp_px_cat_giv2
 where categorie !=trim(categorie)

  -- cheking the trailling and leading spaces in sub_cat

 select 
sub_cat from bronze.erp_px_cat_giv2
 where sub_cat!=trim(sub_cat)

-- checking the unque values in miantenance
 select distinct
 miantenance
 from bronze.erp_px_cat_giv2
