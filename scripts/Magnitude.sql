--country
select country,
       count(customer_key) as total_cust_country
from gold.dim_customer
group by country
order by total_cust_country desc;

--gender
select gender,
       count(customer_key) as total_cust_gender
from gold.dim_customer
group by gender
order by total_cust_gender desc;

--total product by categ
select category,
       count(product_key) as total_product
from gold.dim_product
group by category
order by total_product desc;
--avg_product_cost
select category,
       avg(cost) as avg_product_cost
from gold.dim_product
group by category
order by avg_product_cost desc;
--revanue
select
    p.category,
    sum(f.sls_sales) as total_sls
from gold.fact_sales f
left join gold.dim_product p
    on p.product_key = f.product_key
group by p.category
order by total_sls desc ;
--top spender
select c.customer_id,
       c.first_name,
       c.last_name,
       sum(f.sls_sales) as total_spending
from gold.fact_sales f
left join gold.dim_customer c
on c.customer_key = f.customer_key
group by c.customer_id,
       c.first_name,
       c.last_name
order by total_spending desc;
--item sold by country
select c.country,
       sum(f.sls_quantity) as total_sls
from gold.fact_sales f
left join gold.dim_customer c
on f.customer_key = c.customer_key
group by c.country
order by total_sls desc ;

