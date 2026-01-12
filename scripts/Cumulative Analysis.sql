--Cumulative Analysis
select
    order_date,
    total_sls,
    sum(total_sls) over (order by order_date) as running_sls,
    avg(avg_price) over (order by order_date) as running_avg_price
from (
select
    datetrunc(month ,order_date) as order_date,
    sum(distinct customer_key) as total_cust,
    sum(sls_sales) as total_sls,
    avg(sls_price) as avg_price
from gold.fact_sales
where order_date IS NOT NULL
group by datetrunc(month ,order_date)
)t