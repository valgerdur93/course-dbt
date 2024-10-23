# Week 3
## Part 1

### What is our overall conversion rate?  

Conversion rate = # unique sessions with a purchase event / # total unique sessions

Don't need a new model to answer this question, I can use fact_page_views from last week.

```sql

WITH fact_page_views AS (
    SELECT *
    FROM DEV_DB.DBT_VALGERDURSIDEKICKHEALTHCOM.FACT_PAGE_VIEWS 
)
, all_sessions AS (
    SELECT session_id
            , max(is_purchased) as has_purchase_event
    FROM fact_page_views
    GROUP BY session_id
)
SELECT COUNT(DISTINCT session_id) AS total_sessions
        ,SUM(has_purchase_event) AS purchase_sessions
        , purchase_sessions/total_sessions AS conversion_rate
FROM all_sessions

```
**Answer:** 0.624567


### What is our conversion rate by product? 

Conversion rate by product = # unique sessions with a purchase event of that product / # total unique sessions that viewed the product

Don't need a new model to answer this question, I can use fact_page_views from last week.

```sql

WITH fact_page_views AS (
    SELECT *
    FROM DEV_DB.DBT_VALGERDURSIDEKICKHEALTHCOM.FACT_PAGE_VIEWS 
)
SELECT product_id
        , count(DISTINCT session_id) AS product_viewed_sessions
        , SUM(is_purchased) AS product_purchased_sessions
        , product_purchased_sessions/product_viewed_sessions AS conversion_rate
FROM fact_page_views
GROUP BY product_id
ORDER BY product_viewed_sessions

```
**Answer:** See query result


### Why might certain products be converting at higher/lower rates than others?

I would do the following data investigation:
- Check if the products converting higher have lower price
- Check if the products converting lower have been out of stock often
- Check if the products converting higher have been available in our store for a longer time (maybe we initially had specific products available and then newer producst were added later)


## Part 2

The macro get_product_event_type was created and it was used in the model int_products_views_events.


## Part 3

The macro grant was created and used and the post hook was added in dbt_project.yml.


## Part 4

The package dbt_expectations was installed and the macro expect_column_values_to_be_in_set was used as a test for the column event_type in stg_events table.


## Part 5

My DAG did not change from last week.  I did not find a way to simplify it by using macros/dbt packages.


 ## Part 6

 ## Which products had their inventory change from week 2 to week 3?

 This query gives us the products where the inventory has changed.  

```sql

select *
from dev_db.dbt_valgerdursidekickhealthcom.product_inventory_snapshot
where dbt_updated_at > '2024-10-16' and dbt_valid_to is null 

```
**Answer:**
These products:
- product_id = '55c6a062-5f4a-4a8b-a8e5-05ea5e6715a3'
- product_id = 'be49171b-9f72-4fc9-bf7a-9a52e259836b'
- product_id = 'b66a7143-c18a-43bb-b5dc-06bb5d1d3160'
- product_id = '689fb64e-a4a2-45c5-b9f2-480c2155624d'
- product_id = 'fb0e8be7-5ac4-4a76-a1fa-2cc4bf0b2d80'
- product_id = '4cda01b9-62e2-46c5-830f-b7f262a58fb1'