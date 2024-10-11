# Week 1 
## Answers to questions

### How many users do we have?

```sql
SELECT count(DISTINCT user_id)
FROM dev_db.dbt_valgerdursidekickhealthcom.stg_users
```
**Answer:** 130 users

### On average, how many orders do we receive per hour?

```sql
WITH date_hour_cohort AS (
    SELECT CONCAT(DATE(created_at), CONCAT('-',EXTRACT(HOUR FROM created_at))) as date_hour,
           COUNT(distinct order_id) as order_count
    FROM dev_db.dbt_valgerdursidekickhealthcom.stg_orders
    GROUP BY date_hour
)
SELECT AVG(order_count)
FROM date_hour_cohort
```
**Answer:** 7.52 orders 


### On average, how long does an order take from being placed to being delivered?

```sql
WITH order_created_delivered AS (
    SELECT order_id
           , datediff('day', created_at, delivered_at) as time_create_to_delivered
    FROM dev_db.dbt_valgerdursidekickhealthcom.stg_orders
    where delivered_at is not null  -- some orders have not been delivered, we can not have these in the calculation
)
SELECT AVG(time_create_to_delivered)
FROM order_created_delivered
```
**Answer:** 3.89 days


### How many users have only made one purchase? Two purchases? Three+ purchases?

```sql
WITH user_orders AS (
    SELECT user_id
    , COUNT(distinct order_id) as number_of_orders
    FROM dev_db.dbt_valgerdursidekickhealthcom.stg_orders 
    group by user_id
),
order_groups AS (
    SELECT user_id
            , CASE 
                    WHEN number_of_orders >= 3 THEN '3+ orders' 
                    WHEN number_of_orders = 2 THEN '2 orders' 
                    ELSE '1 order'
                END AS order_cohort
    FROM user_orders
)
SELECT order_cohort
        , count(distinct user_id)
FROM order_groups
group by order_cohort
```
**Answer:** 1 order = 25 users, 2 orders = 28 users, 3+ orders = 71 user (so not all users have made an order)


### -- On average, how many unique sessions do we have per hour?

```sql
WITH date_hour_cohort AS (
    SELECT CONCAT(DATE(created_at), CONCAT('-',EXTRACT(HOUR FROM created_at))) as date_hour,
           COUNT(distinct session_id) as session_count
    FROM dev_db.dbt_valgerdursidekickhealthcom.stg_events
    GROUP BY date_hour
)
SELECT AVG(session_count)
FROM date_hour_cohort
```
**Answer:**  16.32 unique sessions