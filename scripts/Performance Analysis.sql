--Performance Analysis
with yearly_product_sls as
    (select year(f.order_date) as order_year,
           p.product_name,
           sum(f.sls_price) as current_sls
    from gold.fact_sales f
    left join gold.dim_product p
    on f.product_key = p.product_key
    where f.order_date IS NOT NULL
    group by year(f.order_date),
             p.product_name
    )
select order_year,
       product_name,
       current_sls,
       avg(current_sls) over ( partition by product_name) as avg_cuuren_sls,
       current_sls - avg(current_sls) over ( partition by product_name) as Performance_Each_Year,
           case
                when current_sls - avg(current_sls) over ( partition by product_name) > 0 then 'Above_Avg'
                when current_sls - avg(current_sls) over ( partition by product_name) < 0 then 'Below_Avg'
                else 'Average'
           end Avg_ststus,
        lag(current_sls) over (partition by product_name order by order_year) as Pre_V_sls,
        current_sls - lag(current_sls) over (partition by product_name order by order_year) as diff_Pre_v_sls,
        case
                when current_sls - lag(current_sls) over (partition by product_name order by order_year) > 0 then 'Increase'
                when current_sls - lag(current_sls) over (partition by product_name order by order_year) < 0 then 'Decrease'
                else 'No Change'
           end Pre_V_Change
from yearly_product_sls
order by product_name, order_year