
/*
====================================================================================================
Script Name:    load_silver_layer.sql
Description:    Stored procedure to orchestrate the ETL process from the Bronze (Raw) layer 
                to the Silver (Standardized/Cleansed) layer. 
                
                This script handles:
                - Truncation of target Silver tables.
                - Data cleansing (trimming, case normalization, structural string handling).
                - Data quality checks (date casting validations, derived calculation updates).
                - Deduplication using row numbers.
                - Execution time tracking and error handling.

====================================================================================================
*/

create or alter procedure importing as
begin
declare @start_time datetime, @end_time datetime, @batch_start_time datetime, @batch_end_time datetime
begin try

 set @batch_start_time=getdate();

Print'========================='
Print'Modify table 1:crm_cust_info'
Print'========================'

set @start_time =getdate();
print'-------------------------'
Print'>>truncating the table silver.crm_cust_info'
print'-------------------------'
truncate table silver.crm_cust_info

print'-------------------------'
Print'>>inserting data into table silver.crm_cust_info'
print'-------------------------'
insert into  silver.crm_cust_info (cst_id , cst_key,first_name,last_name,Martial_status,cst_gndr)
 select 
 cst_id,
 cst_key,
 trim(cst_first_name) as first_name,
 trim(cst_last_name) as last_name,
 case when upper(trim(cst_martial_status)) = 'M' THEN 'Married'
 when upper(trim(cst_martial_status)) = 'S' THEN 'Single'
 else 'unknown'
 end Martial_status,

  case when cst_gndr = 'M' THEN 'Male'
 when upper(trim(cst_gndr)) = 'F' THEN 'Female'
 else 'unknown'
 end cst_gndr
 from(
select 
*,
row_number() over( partition by cst_key order by cst_create_date desc) flag_list
from bronze.crm_cust_info
where cst_id is not null)k
where flag_list = 1 
set @end_time=getdate();

print'====================================='
print'table loading time' + cast(datediff(second,@start_time,@end_time) as nvarchar) +'seconds'
print'====================================='

Print'========================='
Print'Modify table 2:crm_prd_info'
Print'========================'

set @start_time =getdate();

print'-------------------------'
Print'>>truncating the table silver.crm_prd_info'
print'-------------------------'
truncate table silver.crm_prd_info
print'-------------------------'
Print'>>inserting data into table: silver.crm_prd_info'
print'-------------------------'
insert into  silver.crm_prd_info(prd_id,prd_cust_id,prd_key,prd_nm,prd_cost,prd_line,prd_start_dt,prd_end_dt)
select
prd_id,
substring(prd_key,1,5) as prd_cust_id,
substring(prd_key,7,len(prd_key)) as prd_key,
prd_nm,
coalesce(prd_cost,0) as prd_cost,
case when prd_line  = 'M' THEN 'Mountain'
when prd_line = 'R' THEN 'Road'
when prd_line = 'S' THEN 'Street'
when prd_line = 'T' THEN 'Transport'
else 'N/A'
END  AS prd_line,
prd_start_dt,
dateadd(day,-1,lead(prd_start_dt) over(partition by prd_key order by prd_start_dt)) as prd_end_dt
from bronze.crm_prd_info

 set @end_time=getdate();

print'=========================='
print'table 2 loading' + cast(datediff(second,@start_time,@end_time)  as nvarchar) +'seconds'
print'=========================='

Print'========================='
Print'Modify table 3:crm_sales_details'
Print'========================'

set @start_time=getdate();

print'-------------------------'
Print'>>truncating the table silver.crm_sales_details'
print'-------------------------'
truncate table silver.crm_sales_details

print'-------------------------'
Print'>>inserting data into table: silver.crm_sales_details'
print'-------------------------'
insert into  silver.crm_sales_details (sls_ord_num,sls_prd_key,sls_cust_id,sls_ord_dt,sls_ship_dt,sls_due_dt,sls_sales,sls_quantity,sls_price)
select
sls_ord_num,
sls_prd_key,
sls_cust_id,
case when len(sls_ord_dt) !=8 or len(sls_ord_dt) <=0 then null
else cast(cast(sls_ord_dt as varchar) as date)
end sls_ord_dt,

case when len(sls_ship_dt) !=8 or len(sls_ship_dt)  <=0 then null
else cast(cast(sls_ship_dt as varchar) as date)
end sls_shp_dt,

case when len(sls_due_dt)  !=8 or  len(sls_due_dt) <=0 then null
else cast(cast(sls_due_dt as varchar) as date)
end sls_due_dt,

case when sls_sales != cast(sls_price as int) * cast(sls_quantity as int) then 
abs(cast(sls_price as int)) * cast(sls_quantity as int)
else sls_sales
end sls_sales ,

case when sls_quantity != cast(sls_sales as int) / cast(sls_price as int) then 
cast(sls_sales as int) / cast(sls_price as int)
else sls_quantity 
end as sls_quantity,

case when sls_price != cast(sls_sales as int) / cast(sls_quantity as int) then 
cast(sls_sales as int) / cast(sls_quantity as int)
else sls_price 
end sls_price
from(
select
*,
row_number () over ( partition by sls_prd_key order by sls_cust_id desc) flag_list
from bronze.crm_sales_details
where sls_cust_id is not null)l
where flag_list = 1
 
set @end_time=getdate();

print'====================='
print'table 3 loading' + cast(datediff(second,@start_time,@end_time)  as nvarchar) +'seconds'
print'====================='

Print'========================='
Print'Modify table 4:erp_loc_a101'
Print'========================'

 set @start_time=getdate();

print'-------------------------'
Print'>>truncating the table silver.erp_loc_a101'
print'-------------------------'
truncate table silver.erp_loc_a101

print'-------------------------'
Print'>>insertiing data into table:silver.erp_loc_a101'
print'-------------------------'
insert into silver.erp_loc_a101 (cid,country)
select
*
from(
Select
replace(cid,'-','') as cid,
case when country in ('USA','United States''US') then 'USA'
when country in ('DE','Germany') then 'Germany'
when country   not in ('France','Germany','DE','United States','United Kingdom','USA','US','Australia','Canada') then null
when country is null or country in ('') then 'N/A'
else country
end as country
from(
select
*,
row_number() over( partition by cid  order by cid) flag_list
from  bronze.erp_loc_a101
where cid is not null)l 
where flag_list = 1)k   
where country is not null

set @end_time=getdate();

print'===================='
print'table 4 loading' +  cast(datediff(second,@start_time,@end_time)   as nvarchar) +'seconds'
print'===================='

Print'========================='
Print'Modify table 5:silver.erp_cust_az12'
Print'========================'

set @start_time=getdate();

print'-------------------------'
Print'>>truncating the table silver.erp_cust_az12'
print'-------------------------'
 truncate table silver.erp_cust_az12

print'-------------------------'
Print'>>inserting data into table:silver.erp_cust_az12'
print'-------------------------'

insert into silver.erp_cust_az12(cid,bdate,gender)
Select
*
from(select
case when cid like'NAS%' then substring(cid,4,len(cid))
else cid
end as cid,
case when bdate>'2028-01-01' then null
else  bdate
end as bdate,
case when gender in('F','Female') then 'Female'
when gender in ('M','Male') then 'Male'
when gender in ('') then 'N/A'
when gender is null then 'UN'
else gender
end as gender
from bronze.erp_cust_az12)L
where bdate is not null

set @end_time=getdate();
print'====================='
print'table 5 loading'+ cast(datediff(second,@start_time,@end_time)  as nvarchar) +'seconds'
print'====================='

Print'========================='
Print'Modify table 6:silver.erp_px_cat_giv2'
Print'========================'

print'-------------------------'
Print'>>truncating the table silver.erp_px_cat_giv2'
print'-------------------------'

set @start_time=getdate();

truncate table silver.erp_px_cat_giv2

print'-------------------------'
Print'>>inserting data into table:silver.erp_px_cat_giv2'
print'-------------------------'

insert into silver.erp_px_cat_giv2 (id,categorie,sub_cat,maintenance)
select
replace(id,'_','-'), 
categorie,
sub_cat,
miantenance
from  bronze.erp_px_cat_giv2

set @end_time=getdate();
print'===================='
print'table  6 loading' + cast(datediff(second,@start_time,@end_time)  as nvarchar) +'seconds'
print'==================='

set  @batch_end_time=getdate();

print'================================================'
print'loading duration silver layer' + cast(datediff(second,@batch_start_time,@batch_end_time) as nvarchar) + 'seconds'
print'================================================'

end try
begin catch
print'======================================='
print'error message'+ error_message()
print'error number'+ cast(error_number() as nvarchar)
print'error line'+ cast(error_line()as nvarchar)
print'======================================='
end catch
end
