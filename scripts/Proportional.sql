--Part_To_Whole(Proportional)
with sum_cat as
    (select p.category,
       sum(f.sls_price) as total_sls
    from gold.fact_sales f
    left join gold.dim_product p
    on f.product_key = p.product_key
    group by p.category
    )
select
    category,
    total_sls,
    sum(total_sls) over () as overall_sls,
    concat(round((cast(total_sls as float) / sum(total_sls) over ()) * 100, 2), '%') as percemtage_of_sls
from sum_cat
order by total_sls desc ;