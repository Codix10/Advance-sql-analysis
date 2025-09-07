/*
===============================================================================
Customer Report
===============================================================================
Purpose:
    - This report consolidates key customer metrics and behaviors

Highlights:
    1. Gathers essential fields such as names, ages, and transaction details.
	2. Segments customers into categories (VIP, Regular, New) and age groups.
    3. Aggregates customer-level metrics:
	   - total orders
	   - total sales
	   - total quantity purchased
	   - total products
	   - lifespan (in months)
    4. Calculates valuable KPIs:
	    - recency (months since last order)
		- average order value
		- average monthly spend
===============================================================================
*/

-- =============================================================================
-- Create Report: gold.report_customers
-- =============================================================================
create view gold.report_customers as
with base_query as
(
-- Gathers essential fields such as names, ages, and transaction details.
select 
f.order_number,
f.order_date,
f.product_key,
f.sales_amount,
f.quantity,
c.customer_key,
c.customer_number,
concat(c.first_name,' ',c.last_name)[customer_name],
datediff(year,c.birthdate,GETDATE())[age]
from gold.fact_sales f
	left join gold.dim_customers c
	on f.customer_key = c.customer_key
where order_date is not null
)

,customer_aggregation as
(
/* Aggregates customer-level metrics:
	   - total orders
	   - total sales
	   - total quantity purchased
	   - total products
	   - lifespan (in months) */
select
customer_key,
customer_number,
customer_name,
age,
count(order_number) as total_orders,
count(distinct product_key) as total_products,
sum(sales_amount)[total_spending],
sum(quantity) as total_quantity,
max(order_date) as last_order,
DATEDIFF(month,min(order_date),max(order_date)) as lifespan
from base_query
group by 
	customer_key,
	customer_number,
	customer_name,
	age
)
-- Segments customers into categories (VIP, Regular, New) and age groups.
select 
customer_key,
customer_number,
customer_name,
age,
case 
	when age between 20 and 40 then 'adults'
	when age between 40 and 60 then 'middle aged adults'
	else 'seniors'
end age_group,
total_orders,
total_products,
total_quantity,
total_spending,
case
	when lifespan >= 12 and total_spending >= 5000 then 'VIP'
	when lifespan >= 12 and total_spending <= 5000 then 'Regular'
	else 'New'
end customer_group,
last_order,
-- Calculating Recency
DATEDIFF(month,last_order,GETDATE()) as recency,
lifespan,
-- Calculating average order value
case 
	when total_orders = 0 then 0
	else total_spending / total_orders 
end average_order_value,
case 
	when lifespan = 0 then total_spending
	else total_spending / lifespan 
end average_monthly_spend
from customer_aggregation
