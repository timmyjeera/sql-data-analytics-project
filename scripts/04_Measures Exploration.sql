--Calculate(Big Number)
--Find total sales
select sum(sls_sales)
from gold.fact_sales;
--Find sold item
select sum(sls_quantity)
from gold.fact_sales;
--Find AVG selling price
select avg(sls_price)
from gold.fact_sales;
--Find total number of orders
select count(order_number) from gold.fact_sales;
select count(distinct order_number) from gold.fact_sales;
select * from gold.fact_sales where order_number = 'SO54496';
--Find total number of products
select count(product_id)
from gold.dim_product;
--Find total number of customers
select count(customer_key)
from gold.dim_customer;
--Find total number of customers that have placed an order
select
count(distinct customer_key)
from gold.fact_sales;

--Generate Report show all ket metric ot the business
select 'Total Sales',sum(sls_sales) from gold.fact_sales
union all
select 'Sold Item',sum(sls_quantity) from gold.fact_sales
union all
select'Average Price',avg(sls_price) from gold.fact_sales
union all
select 'Total Nr. Orders',count(distinct order_number) from gold.fact_sales
union all
select 'Total Nr. Product', count(product_key) from gold.dim_product
union all
select 'Total Nr. Customers', count(distinct customer_key) from gold.fact_sales
