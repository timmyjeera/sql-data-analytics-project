--Segment Product

/*Segment Product into cost ranges
  then count how many product fall on segment*/
with product_segment as (select product_key,
                                product_name,
                                cost,
                                case
                                    when cost < 100 then '<100'
                                    when cost between 100 and 500 then '100-500'
                                    when cost between 500 and 1000 then '500-1000'
                                    else '>1000'
                                    end cost_range
                         from gold.dim_product
                         )
select cost_range,
       count(product_key) as total_product
from product_segment
group by cost_range
order by count(product_key) desc;


with cust_spend as (
select *
from (select c.customer_key,
             sum(f.sls_sales)                                      as total_spending,
             min(f.order_date)                                     as first_order,
             max(f.order_date)                                     as lastt_order,
             datediff(month, min(f.order_date), max(f.order_date)) as date_diff
      from gold.fact_sales f
               left join gold.dim_customer c
                         on f.customer_key = c.customer_key
      group by c.customer_key) fc
)
select
cust_segment,
count(customer_key) as total_cust
from (
    select
           customer_key,
           case
               when date_diff >= 12 and total_spending > 5000 then 'VIP'
               when date_diff >= 12 and total_spending < 5000 then 'regular'
               else 'New'
           end cust_segment
    from cust_spend ) t
group by cust_segment
order by  total_cust desc


