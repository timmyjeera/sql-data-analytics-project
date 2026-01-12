/*
===============================================================================
Customer Report
===============================================================================
Purpose:
    - This report consolidates key customer metrics and behaviors

Highlights:
    1. Gathers essential fields such as names, ages, and transaction details.
	2. Segments customers into categories (VIP, Regular, New) and age groups.
    3. Aggregates customer-level metrics:
	   - total orders
	   - total sales
	   - total quantity purchased
	   - total products
	   - lifespan (in months)
    4. Calculates valuable KPIs:
	    - recency (months since last order)
		- average order value
		- average monthly spend
===============================================================================
*/

CREATE VIEW gold.report_customers as
with base_query as (
/*---------------------------------------------------------------------------
1) Base Query: Retrieves core columns from tables
---------------------------------------------------------------------------*/
select
    f.order_number,
    f.product_key,
    f.order_date,
    f.sls_sales,
    f.sls_quantity,
    c.customer_key,
    c.customer_no,
    CONCAT(c.first_name, ' ', c.last_name) as cust_name,
    datediff(year ,c.birth_date, getdate()) as age
from gold.fact_sales f
left join gold.dim_customer c
on f.customer_key = c.customer_key
where order_date IS NOT NULL
)

, cust_aggregation as (
/*---------------------------------------------------------------------------
	2. Segments customers into categories (VIP, Regular, New) and age groups.
---------------------------------------------------------------------------*/
select
    customer_key,
    customer_no,
    cust_name,
    age,
    count(distinct order_number) as total_order,
    sum(sls_sales) as total_sls,
    sum(sls_quantity) as total_qty,
    count(distinct product_key) as total_product,
    max(order_date) as last_order_date,
    datediff(month, min(order_date), max(order_date)) as date_diff
from base_query
group by
    customer_key,
    customer_no,
    cust_name,
    age)
select
    customer_key,
    customer_no,
    cust_name,
    age,
    case
        when age < 20 then 'under 20'
        when age between 20 and 29 then '20-29'
        when age between 30 and 39 then '30-39'
        when age between 40 and 49 then '40-49'
        else '50 and above'
    end as age_segment,
    case
        when date_diff >= 12 and total_sls > 5000 then 'VIP'
        when date_diff >= 12 and total_sls < 5000 then 'regular'
        else 'New'
    end cust_segment,
    last_order_date,
    datediff(month, last_order_date, getdate()) as recency,
    total_order,
    total_sls,
    total_qty
    total_product,
    date_diff,
--Compuate average order value(average order value)
    case
        when total_sls = 0 then 0
        else total_sls / total_order
    end as avo,
--Compuate average monthly spend
    case
        when date_diff = 0 then total_sls
        else total_sls / date_diff
        end as monthly_spend
from cust_aggregation;