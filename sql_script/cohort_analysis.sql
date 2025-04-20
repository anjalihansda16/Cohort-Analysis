-- ShopTrendz Cohort Analysis: SQL Script to Analyze Customer Retention, Revenue Retention, and CLV by Product Category
-- Purpose: Support the case study to improve retention and revenue in high-value product categories using sales data (Oct 2020 - Sep 2021)


select *
from sales


-- 1. Data Exploration and EDA
-- Purpose: Understand the dataset's structure, volume, time range, and key distributions to inform cohort analysis

-- 1.1 Data Volume and Time Range
-- Description: Summarize total rows, date range, unique customers, and orders to confirm dataset scope
select 
	count(*) as total_rows,
	min(order_date) as min_date,
	max(order_date) as max_date,
	count(distinct cust_id) as customer_count,
	count(distinct order_id) as order_count
from sales;

-- 1.2 Product Category Distribution
-- Description: Analyze order count, customer count, and revenue by category to identify high-value categories
-- Filters: Use completed orders with positive revenue to ensure data quality
select 
	category,
	count(distinct order_id) as order_count,
	count(distinct cust_id) as customer_count, 
	round(sum(total), 2) as total_revenue
from sales
where status = 'complete'
and total > 0
group by category
order by total_revenue desc;

-- 1.3 Order Status Distribution
-- Description: Check the distribution of order statuses to understand data completeness (e.g., % complete vs. canceled)
select 
	status,
	count(*) as order_count,
	round(cast(count(*) as float) * 100 / sum(count(*)) over(), 2) as pct_of_total
from sales 
group by status
order by order_count desc;

-- 2. Data Quality Checks
-- Purpose: Validate data integrity for cohort analysis by checking for missing values, invalid values, and duplicates

-- 2.1 Missing and Invalid Values
-- Description: Count null values in key columns to ensure data completeness
select 
	sum(case when cust_id is null then 1 else 0 end) as null_cust_id, 
	sum(case when order_date is null then 1 else 0 end) as null_order_date,
	sum(case when status is null then 1 else 0 end) as null_status,
	sum(case when total is null then 1 else 0 end) as null_total,
	sum(case when category is null then 1 else 0 end) as null_category
from sales; 

-- 2.2 Data Quality for Cohort Metrics
-- Description: Check for invalid totals, quantities, and duplicate order IDs in completed orders
-- Filters: Focus on completed orders to align with cohort analysis
select 
	sum(case when total is null or total <= 0 then 1 else 0 end) as invalid_total,
	sum(case when qty_ordered is null or qty_ordered <= 0 then 1 else 0 end) as invalid_ordered,
	sum(case when order_id is null then 1 else 0 end) as null_order_id,
	count(*) - count(distinct order_id) as duplicate_order_id
from sales
where status = 'complete';

-- 2.3 Duplicates
-- Description: Identify duplicate order IDs to ensure unique orders for accurate counting
select *
from sales 
where order_id in 
(select 
	order_id
from sales
group by order_id
having count(*) > 1
)
order by order_id;

-- 3. Cohort Feasibility
-- Purpose: Assess the suitability of product categories for cohort analysis by examining customer and order volumes
-- Description: Summarize customer count, order count, and revenue by category for completed orders in the cohort period
-- Filters: Limit to Oct 2020 - Mar 2021 to ensure a 6-month analysis window
select 
	category as product_category,
	count(distinct cust_id) as customer_count,
	count(distinct order_id) as order_count,
	round(sum(total), 2) as total_revenue
from sales
where status = 'complete'
and order_date between '2020-10-01' and '2021-03-31'
and total > 0 and total is not null
group by category
order by customer_count desc;

-- 4. Cohort Analyses
-- Purpose: Analyze customer retention, revenue retention, and CLV by product category cohorts to identify high-value categories

-- 4.1 Customer Retention by Product Category
-- Description: Calculate the percentage of customers returning each month (0-6) after their first purchase in a category
-- Logic: Define cohorts by first purchased category, count active customers per month, and compute retention rate
with first_purchase_category as
(
	select 
		cust_id,
		min(order_date) as first_purchase,
		min(category) as first_category
	from sales
	where status = 'complete'
	and order_date between '2020-10-01' and '2021-03-31'
	and total > 0 and total is not null
	group by cust_id
),
activity as
(
	select 
		s.cust_id,
		f.first_category,
		datediff(month, f.first_purchase, s.order_date) as months_since_cohort
	from sales as s 
	join first_purchase_category as f
	on s.cust_id = f.cust_id 
	where s.status = 'complete'
	and s.order_date >= f.first_purchase
	and total > 0 and total is not null
),
cohort as
(
	select 
		first_category as product_category,
		months_since_cohort,
		count(distinct cust_id) as active_in_cohort
	from activity
	group by first_category, months_since_cohort
)
select 
	product_category,
	months_since_cohort,
	first_value(active_in_cohort) over(partition by product_category order by months_since_cohort) as cohort_size,
	active_in_cohort,
	case when first_value(active_in_cohort) over(partition by product_category order by months_since_cohort) > 0 
		 then round(cast(active_in_cohort as float) * 100 / first_value(active_in_cohort) over(partition by product_category order by months_since_cohort), 2) 
		 else 0 
	end as pct_active
from cohort
where months_since_cohort <= 6
order by cohort_size desc, months_since_cohort;

-- 4.2 Revenue Retention by Product Category
-- Description: Measure the percentage of initial revenue retained each month (0-6) after the first purchase
-- Logic: Sum revenue by category and month, compare to month 0, and calculate retention rate
-- Note: Simplified to exclude AOV for clarity, as per case study focus
with first_purchase as
(
	select distinct
		cust_id,
		min(order_date) as cohort_date,
		min(category) as product_category
	from sales
	where order_date between '2020-10-01' and '2021-03-31'
	and status = 'complete'
	and total > 0 and total is not null
	group by cust_id
),
activity as 
(
	select
		f.cust_id,
		f.product_category,
		datediff(month, f.cohort_date, s.order_date) as months_since_cohort,
		s.total as revenue
	from sales as s
	join first_purchase as f
	on s.cust_id = f.cust_id
	where s.order_date >= f.cohort_date
	and status = 'complete'
	and s.total is not null
), 
cohorts as
(
	select 
		product_category,
		months_since_cohort,
		sum(revenue) as cohort_revenue
	from activity
	group by product_category, months_since_cohort
)
select 
	product_category,
	months_since_cohort,
	round(cast(first_value(cohort_revenue) over(partition by product_category order by months_since_cohort) as float), 2) as first_month_cohort_revenue,
	round(cohort_revenue, 2) as revenue_retained,
	case when first_value(cohort_revenue) over(partition by product_category order by months_since_cohort) > 0 
		 then round(cast(cohort_revenue as float) * 100 / first_value(cohort_revenue) over(partition by product_category order by months_since_cohort), 2) 
		 else 0
	end as pct_revenue_retained
from cohorts
where months_since_cohort <= 6
order by product_category;

-- 4.3 CLV by Product Category
-- Description: Calculate average CLV, purchase frequency, and AOV for customers by first purchased category
-- Logic: Sum revenue and count orders per customer over 6 months, average by category
with first_purchase_category as
(
	select 
		cust_id,
		min(order_date) as first_purchase,
		min(category) as first_category
	from sales
	where status = 'complete'
	and order_date between '2020-10-01' and '2021-03-31'
	and total > 0 and total is not null
	group by cust_id
),
customer_metrics as 
(
	select 
		f.cust_id, 
		f.first_category,
		count(distinct s.order_id) as order_count,
		sum(s.total) as clv,
		avg(s.total) as aov
	from sales as s
	join first_purchase_category as f
	on s.cust_id = f.cust_id
	where status = 'complete'
	and s.order_date >= f.first_purchase
	and s.order_date <= dateadd(month, 6, f.first_purchase)
	and s.order_date between '2020-10-01' and '2021-03-31'
	and s.total > 0 and s.total is not null
	group by f.cust_id, f.first_category
)
select 
	first_category as product_category,
	count(distinct cust_id) as cohort_size,
	round(avg(clv), 2) as avg_clv,
	round(avg(cast(order_count as float)), 2) as avg_purchase_frequency,
	round(cast(avg(case when order_count > 1 then 1.0 else 0 end) as float) * 100, 2) as repeat_purchase,
	round(avg(aov), 2) as avg_order_value
from customer_metrics
group by first_category
order by avg_clv desc;

