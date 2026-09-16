/*
===============================================================================
DDL Script: Create Gold Views
===============================================================================
Description:
    This script defines the analytical views for the Gold layer in the Data Warehouse.
    It transitions the data architecture into a Star Schema model by establishing:
    1. gold.dim_cust   - Customer Dimension (with standard gender formatting)
    2. gold.dim_prd    - Product Dimension (filtered for active products)
    3. gold.fact_sales - Sales Fact Table (linked to Customer and Product dimensions)

Usage:
    Execute this script in its entirety to deploy or refresh the Gold views.
===============================================================================
*/

-- =========================================================================
-- View 1: gold.dim_cust
-- =========================================================================

if object_id('gold.dim_cust','v') is not null
drop view gold.dim_cust
print'============================================='
print'creating view 1: gold.dim_cust'
print'============================================='

go 

create or alter view gold.dim_cust as
select
row_number()  over (order by cst_id) as cust_key,
cst_id as cust_id,
cst_key  as cust_number,
first_name,
last_name,
case when cst_gndr in ('Female','Male') then cst_gndr 
else coalesce(gender,'UN')
end as gender,
case when country in ('USA','US','United States') then 'USA'
when country is null then 'N/A'
else country
end country,
martial_status,
bdate as birth_date
from silver.crm_cust_info as s
left join silver.erp_cust_az12 as z
on s.cst_key = z.cid
left join silver.erp_loc_a101 as l
on s.cst_key  = l.cid

go

-- =========================================================================
-- View 2: gold.dim_prd
-- =========================================================================

if object_id('gold.dim_prd','v') is not null
drop view gold.dim_prd

print'============================================='
print'creating view 2: gold.dim_prd'
print'============================================='
 
 go 

create or alter  view gold.dim_prd as 
select
row_number() over(order by prd_id) product_key,
prd_id as product_id,
prd_cust_id as categorie_id ,
prd_key as product_number,
prd_nm as product_name,
prd_cost as cost,
categorie as categorie,
sub_cat as sub_categorie,
prd_line as product_line,
maintenance as  maintenance,
prd_start_dt as start_date,
prd_end_dt as end_date
from silver.crm_prd_info as s
left join  silver.erp_px_cat_giv2 as g
on s.prd_cust_id = g.id
where prd_end_dt is null

go

-- =========================================================================
-- View 3: gold.fact_sales
-- =========================================================================

if object_id('gold.fact_sales','v') is not null
drop view gold.fact_sales

print'============================================='
print'creating view 3: gold.fact_sales'
print'============================================='

go

create or alter view gold.fact_sales as
select 
sls_ord_num as order_number,
p.product_key,
cust_key,
sls_ord_dt as order_date,
sls_ship_dt as ship_date,
sls_due_dt as due_date,
sls_sales as sales,
sls_quantity as quantity,
sls_price as price
from silver.crm_sales_details as s
left join gold.dim_prd as p
on s.sls_prd_key = p.product_number
left join  gold.dim_cust as g
on s.sls_cust_id = g.cust_id

go
