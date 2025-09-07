-- Cumulative Analysis

select 
order_date,
total_sales,
sum(total_sales) over( order by order_date) as running_total,
avg(average_sales) over( order by order_date) as moving_average_total 
from
(select datetrunc(year,order_date) as order_date, 
sum(sales_amount)[total_sales],
avg(sales_amount)[average_sales]
from gold.fact_sales
where order_date is not null
group by datetrunc(year,order_date)
)t

