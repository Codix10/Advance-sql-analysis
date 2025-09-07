select top 5 * from gold.fact_sales 
-- Change Over Time Analysis 

-- Analysing Sales Over Years

select 
Year(order_date)as Order_year, 
sum(sales_amount) as Total_sales,
sum(quantity)[Total_quantity]
from gold.fact_sales
where order_date is not null
group by Year(order_date)  
order by Year(order_date); 

-- Analysing Sales Over Years and Months

select 
Year(order_date)as Order_year, 
Month(order_date) as Order_month,
sum(sales_amount) as Total_sales,
sum(quantity)[Total_quantity]
from gold.fact_sales
where order_date is not null
group by Year(order_date), Month(order_date)  
order by Year(order_date), Month(order_date); 

-- Analysing Sales Over Seasonality 

select 
Month(order_date)as Order_month, 
sum(sales_amount) as Total_sales,
sum(quantity)[Total_quantity]
from gold.fact_sales
where order_date is not null
group by Month(order_date)  
order by Month(order_date); 