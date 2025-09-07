-- Data Segmentation

with costRange as
(select 
product_key,
product_name,
cost,
case 
	when cost < 100 then 'Below 100'
	when cost between 100 and 500 then 'Between 100 & 500'
	when cost between 500 and 1000 then 'Between 500 & 1000'
	else 'Above 1000'
end cost_range
from gold.dim_products
)

select
cost_range,
count(product_key) total_products
from costRange
group by cost_range 
order by sum(product_key) desc

-- Group Customers into three segments based on their spending behaviours 
-- VIP : at least 12 months of history and spending more than 5,000 
-- Regular : at least 12 months of history but spending 5,000 or less 
-- New : purchase lifespan less than 12 months 
-- And find the total number

with customer_spending as
(select 
c.customer_key,
sum(f.sales_amount) as total_spending,
min(order_date) as first_order,
max(order_date) as last_order,
DATEDIFF(month,min(order_date),max(order_date)) as lifespan
from gold.fact_sales f
	left join gold.dim_customers c
	on f.customer_key = c.customer_key
group by c.customer_key
)


select
customer_group,
count(customer_key) as customer_count 
from 
(select 
customer_key,
total_spending,
lifespan,
case
	when lifespan >= 12 and total_spending >= 5000 then 'VIP'
	when lifespan >= 12 and total_spending <= 5000 then 'Regular'
	else 'New'
end customer_group
from customer_spending
)t
group by customer_group 
order by customer_count desc

