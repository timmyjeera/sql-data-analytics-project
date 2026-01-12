--Change Over Time(Trend)
select
    year(order_date) as order_year,
    month(order_date) as order_month,
    sum(distinct customer_key) as total_cust,
    sum(sls_sales) as total_sls,
    sum(sls_quantity) as tota_qty
from gold.fact_sales
where order_date IS NOT NULL
group by year(order_date),month(order_date)
order by year(order_date),month(order_date)


select
    datetrunc(year ,order_date) as order_date,
    sum(distinct customer_key) as total_cust,
    sum(sls_sales) as total_sls,
    sum(sls_quantity) as tota_qty
from gold.fact_sales
where order_date IS NOT NULL
group by datetrunc(year ,order_date)
order by datetrunc(year ,order_date)


select
    format(order_date,'yyyy-MMM') as order_date,
    sum(distinct customer_key) as total_cust,
    sum(sls_sales) as total_sls,
    sum(sls_quantity) as tota_qty
from gold.fact_sales
where order_date IS NOT NULL
group by format(order_date,'yyyy-MMM')
order by format(order_date,'yyyy-MMM')
