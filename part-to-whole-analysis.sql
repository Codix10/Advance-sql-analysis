-- Which category contributes the most to total sales?

with categorySales as
(select p.category,
sum(f.sales_amount)[total_sales] 
from gold.fact_sales f
	left join gold.dim_products p
	on f.product_key = p.product_key
group by p.category
)

select 
category,
total_sales,
sum(total_sales) over() overall_sales,
concat(round((cast(total_sales as float) / sum(total_sales) over()) * 100,2),'%')[percentage_of_total]
from categorySales
order by percentage_of_total desc

-- Which Product Line Contributes the most to the Total Sales

with productSales as
(select p.product_line,
sum(f.sales_amount)[total_sales_product_line] 
from gold.fact_sales f
	left join gold.dim_products p
	on f.product_key = p.product_key
group by p.product_line
)

select 
product_line,
total_sales_product_line,
sum(total_sales_product_line) over() overall_sales,
concat(round((cast(total_sales_product_line as float) / sum(total_sales_product_line) over()) * 100,2),'%')[percentage_of_total]
from productSales
order by percentage_of_total desc