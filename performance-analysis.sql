-- Performance Analysis

with currentYearSales as
(select 
year(s.order_date) as order_year,
p.product_name,
sum(s.sales_amount) as current_sales
from gold.fact_sales s
	join gold.dim_products p
	on s.product_key = p.product_key
where year(s.order_date) is not null
group by year(s.order_date), p.product_name
)

select 
order_year,
product_name,
current_sales,
avg(current_sales) over(partition by product_name) as avg_sales,
current_sales - avg(current_sales) over(partition by product_name) as difference_avg,
case 
	when current_sales-avg(current_sales) over(partition by product_name)  > 0 then 'Above average'
	when current_sales-avg(current_sales) over(partition by product_name)  < 0 then 'Below average'
	else 'Average'
end average_change,
lag(current_sales) over(partition by product_name order by order_year) py_sales,
current_sales - lag(current_sales) over(partition by product_name order by order_year) as difference_previous_year,
case 
	when current_sales - lag(current_sales) over(partition by product_name order by order_year) > 0 then 'Increase'
	when current_sales - lag(current_sales) over(partition by product_name order by order_year) < 0 then 'Decrease'
	else 'No Change'
end previous_year_difference
from currentYearSales
order by product_name,order_year