WITH int_order_items AS (
    SELECT *
    FROM {{ref('int_order_items')}}
)
SELECT user_id
        , DATE(created_at) AS order_date
        , COUNT(distinct order_id) AS orders
        , SUM(order_cost) AS order_cost
        , SUM(shipping_cost) AS shipping_cost
        , SUM(quantity) AS product_quantity
        , COUNT(DISTINCT product_id) AS unique_products
FROM int_order_items
GROUP BY user_id
        , order_date
ORDER BY user_id
        , order_date