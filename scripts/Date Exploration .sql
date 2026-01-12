--Date Exploration
select
    min(order_date),
    max(order_date),
    datediff(month ,min(order_date), max(order_date)) as order_range_date
from gold.fact_sales;
--Customer_Age
select
    min(birth_date),
    datediff(year, min(birth_date),getdate())     as oldest_age,
    max(birth_date),
    datediff(year, max(birth_date),getdate()) as youngest_age
from gold.dim_customer;