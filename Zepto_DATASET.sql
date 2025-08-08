select * from zepto


--Different Product categories and how many they are
select distinct category,count(*)
from zepto
group by category;


--how many products are in stock vs out of stock
select outofstock,count(*)
from zepto
group by outofstock;

--product names present multiple times

select name,count(*)
from zepto
group by name
having count(*) >1
order by count(*) desc;

--Data Cleaning

--Products with price = 0

select *
from zepto
where mrp = 0 or discountedSellingPrice = 0;-- so we dont need this row


delete from zepto
where mrp = 0;


--Convert paise into rupees 
SELECT name, mrp / 100.0 AS mrp_rupees, discountedSellingPrice / 100.0 AS selling_price_rupees
FROM zepto;;


--BUSINESS PROBLEMS

--Find the Top 10 best value products based on the Discount percentage

with ranked as(
	select name,mrp,discountpercent,
	rank() over(order by discountpercent desc) as rn
	from zepto
)
	select name,mrp,discountpercent
	from ranked
	where rn <= 10;


-- what are the products with high mrp but out of stock

select name,mrp,outofstock,category
from zepto
where outofstock = 'true'
order by mrp desc;


--calculate estimated revenue for each category

SELECT category,
       SUM(discountedSellingPrice * availableQuantity) AS estimated_revenue
FROM zepto
GROUP BY category
order by estimated_revenue;


--Find all the products where mrp is greater than 500 and discount is less than 10%

select distinct name,mrp,discountpercent
from zepto
where mrp > 500 
and discountpercent < 10
order by mrp desc,discountpercent desc;


-- identify the top 5 categories offering the highest average discount percentage

with ranked as(
	select category,avg(discountpercent) as avg_discount,
	rank() over(order by avg(discountpercent) desc)as rn
	from zepto
	group by category
)
	select category,avg_discount
	from ranked
	where rn < 5;


--Find the price per gram for products above 100kg and sort by best value

SELECT 
    name,
    discountedSellingPrice,
    weightInGms,
    (discountedSellingPrice * 1.0 / weightInGms) AS price_per_gram
FROM zepto
WHERE weightInGms > 100000
ORDER BY price_per_gram ASC;

--Group the products into categories like low,medium,bulk

select distinct name,weightInGms,
case when weightInGms < 1000 then 'low'
	when weightInGms < 5000 then 'medium'
	else 'bulk'
	end as weight_category
from zepto;	





	

