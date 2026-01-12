--top product_sls
select top 5
    p.product_name,
    sum(f.sls_sales) as total_sls
from gold.fact_sales f
left join gold.dim_product p
    on p.product_key = f.product_key
group by p.product_name
order by total_sls desc ;

--bottom product_sls
select top 5
    p.product_name,
    sum(f.sls_sales) as total_sls
from gold.fact_sales f
left join gold.dim_product p
    on p.product_key = f.product_key
group by p.product_name
order by total_sls ;

--Ranking by window function
select *
from (
select
    p.product_name,
    sum(f.sls_sales) as total_sls,
    row_number() over (order by sum(f.sls_sales)) as ranking_product
from gold.fact_sales f
left join gold.dim_product p
    on p.product_key = f.product_key
group by p.product_name
)t
where ranking_product <= 5

 --top spender
select top 10
    c.customer_id,
       c.first_name,
       c.last_name,
       sum(f.sls_sales) as total_sls
from gold.fact_sales f
left join gold.dim_customer c
on c.customer_key = f.customer_key
group by c.customer_id,
       c.first_name,
       c.last_name
order by total_sls desc
--top 3 fewest orders placed
select top 3
    c.customer_id,
       c.first_name,
       c.last_name,
       count(f.sls_sales) as pleaced_order
from gold.fact_sales f
left join gold.dim_customer c
on c.customer_key = f.customer_key
group by c.customer_id,
       c.first_name,
       c.last_name
order by pleaced_order