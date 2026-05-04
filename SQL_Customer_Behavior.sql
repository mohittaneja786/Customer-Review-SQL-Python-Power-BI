--  SELECT Top 20* FROM dbo.customer

--1. What is the total revvenue genereated by males vs female customers

select gender,
		sum(purchase_amount) as total_revenue
	from dbo.customer
	group by gender


--2. which customers used a discount but still spent more than average purchase amount

select customer_id,
		purchase_amount
	from dbo.customer
	where discount_applied = 'Yes'
	and purchase_amount > (select avg(purchase_amount) from dbo.customer)


--3 which are the top 5 items with the highest average review rating

select TOP 5 item_purchased,
		round(avg(review_rating),1)
from dbo.customer
	group by item_purchased
	order by avg(review_rating) desc
	

-- 4 What is the average purchase amount for customers who used express shipping vs standard shipping?

select avg(purchase_amount) As Express_Shipping, shipping_type
from dbo.customer
where shipping_type in ('Express', 'Standard')
group by shipping_type


-- 5.Does the subscription status of customers have any impact on their average purchase amount? 
	--compare the average purchase amount for customers with different subscription statuses.

	select subscription_status, 
		   count(customer_id) As Total_Customers,
		   avg(purchase_amount) As Average_Purchase_Amount,
		   SUM(purchase_amount) As Total_Purchase_Amount
	from dbo.customer
		group by subscription_status


-- 6. select the top 5 items have the highest average review rating among customers who applied a discount 
		
		select TOP 5 item_purchased,
			ROUND(100 * SUM(case when discount_applied = 'Yes' Then 1 else 0 END)/count(*),2) As discount_percentage
		from dbo.customer
		group by item_purchased
		order by discount_percentage desc



-- 7  for each customer segment (new, returning, loyal), calculate the total number of purchases and the average purchase amount.

with customer_segments as (
	select purchase_frequency_days,
		Case 
		when purchase_frequency_days >7 Then 'New'
		when purchase_frequency_days >7 and purchase_frequency_days <= 10 then 'Returning'
		--when purchase_frequency_days >90 and purchase_frequency_days <= 120 then 'Loyal'
		else 'Loyal' END as customer_segment
	from dbo.customer
)
select count(*) as total_purchases,
       customer_segment
from customer_segments
group by customer_segment


-- 8. determine the top 3 most popular items in each category based on the number of customers who purchased them.
with item_rankings as (
select category,
		item_purchased,
		count(customer_id) as Total_customers,
		Row_number () over (partition by category order by count(customer_id) desc) as item_rank
from dbo.customer
group by category, item_purchased
		)

select item_rank, category, item_purchased, Total_customers
from item_rankings
where item_rank <= 3



--9. for customers who have made more than 5 previous purchases, analyze the relationship between their subscription status and the likelihood of being a repeat customer.

select subscription_status,
		count(customer_id) as repeat_customer
from dbo.customer
where previous_purchases > 5
group by subscription_status


-- 10.

	select age_group,
		 sum(purchase_amount) as total_revenue

	from dbo.customer
	group by age_group
	order by total_revenue desc
























