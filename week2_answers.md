Week 2 - Answers

#Uplimit 


# Week 2
## Part 1

### What is our user repeat rate?  Repeat Rate = Users who purchased 2 or more times / users who purchased

```sql
-- All users that have made an order are in the stg_orders table
-- We start with counting the number of orders each user has done
WITH user_orders AS (
    SELECT user_id
    , COUNT(distinct order_id) as number_of_orders
    FROM raw.public.orders
    group by user_id
),
-- Label the users with 1 if they have made 2 or more orders, else 0
order_groups AS (
    SELECT user_id
            , CASE WHEN number_of_orders >= 2 THEN 1 ELSE 0 END AS two_or_more_orders
    FROM user_orders
),
-- Count how many users have purchased and how many users have purchased two or more times
user_counts AS(
    SELECT COUNT(DISTINCT user_id) as user_count
            , SUM(two_or_more_orders) as user2_count
    from order_groups
)
-- Calculate the repeat rate
SELECT user_count
        , user2_count
        , user2_count/user_count
from user_counts

```
**Answer:** 0.798387


### What are good indicators of a user who will likely purchase again? What about indicators of users who are likely NOT to purchase again? If you had more data, what features would you want to look into to answer this question?
NOTE: This is a hypothetical question vs. something we can analyze in our Greenery data set. Think about what exploratory analysis you would do to approach this question.

** Answer:**
 Good indicators of a user who will purchase again is if the user was happy with the product/products ordered.  Would be great to have data about returns and reviews from users.  I would look at number of orders, number of returns and the reviews for each customer to see if a good review and few returns result in more orders as I would expect.  

Indicators of users who are likely not to purchase again is if the user is not happy with the purchase.  So I would look at the same data as mentioned above to see if bad reviews and more returns result in less orders.  Other factors that could make the user unhappy is if the delivery time of the order is longer than expected and also if the product is too expensive.


### Product mart
The product mart uses the following models:  int_products_viewed_events, int_session_info, fact_page_views.  The reason for why I have the intermediate folder under models instead of under each mart folder is because some intermediate models will be used for different marts.

Each row in fact_page_views is for each product that a specific user looks at in a session.  The main source table for this mart table stg_events but some data transformation needed to be done.  There are 4 different event types in the stg_events table:  page_view, add_to_cart, checkout and package_shipped.  All sessions have the event page_view and this event has an associated product_id so we can see which product is being looked at.  Then a session can have an add_to_cart event which is also associated with product_id so we can see what product is being added to cart.  The checkout event corresponds to a purchase, this event does not have a product_id but instead an order_id.  This is because there will only be one checkout event for each session, so only one order if products are purchased. Note that many products can be added to cart and then they are all in the same order.  The package_shipped event also has an order_id and not a product_id. 

So we have product specific events = page_view and add_to_cart, and we have order specific events = checkout and package_shipped.

I decided to break the logic down into two intermediate models.
- In int_products_viewed_events:  In this model we count page_views and added_to_cart for each session, user and product.  We make sure that we only look at rows that have the count of page_views > 0.  I did some data investigation and the events table only has sessions that have a page_view.
- In int_session_info:   find the session start and end as well as order_id for the sessions that lead to a purchase.
- In fact_page_views:  Join int_products_viewed_events and int_session_info and stg_order_items (to get quantity)

I did not add any dimension tables in the product mart.  My thought was that the dimensions added in the core schema will be used with fact_page_views.### DAG
￼


## Part 2
### Staging Tests
Added tests for the unique identifiers for all our staging tables.  I added two tests:  unique and not_null.  These tests were added since the assumption I make about the data is that the unique identifier should be unique and not null.

I added a test called positive_values in the macros folder.  I added this test to columns I would expect to always be positive.   
- stg_order_items => quantity
- stg_orders => order_cost, shipping_cost, order_total
- product => price, inventory

### Bad data?
I did not find any bad data while running the tests mentioned above.

### How to ensure that the tests are passing regularly and how to alert stakeholders about bad data getting through?
**Answer:**  Use dbt tests for data validation, and schedule the models to run every day in dbt Cloud.  I would set up slack or email notifications vie dbt Cloud so stakeholders would get a notification when there is a failure. 


## Part 3
### Which products had their inventory change from week 1 to week 2?

```sql
-- This query gives us the products where the inventory has changed.  We can see how the inventory was 
-- when the first snapshot was taken and then when the next snapshot was taken
select *
from dev_db.dbt_valgerdursidekickhealthcom.product_inventory_snapshot

where 
	-- When the first snapshot was taken of the data
	date(dbt_updated_at) > '2024-10-10'  
        -- When the first snapshot was taken all rows had null here
    	or dbt_valid_to is not null 

```
**Answer:** These products:
- product_id = 'fb0e8be7-5ac4-4a76-a1fa-2cc4bf0b2d80' 
- product_id = '4cda01b9-62e2-46c5-830f-b7f262a58fb1'
- product_id = 'be49171b-9f72-4fc9-bf7a-9a52e259836b'
- product_id = '55c6a062-5f4a-4a8b-a8e5-05ea5e6715a3'