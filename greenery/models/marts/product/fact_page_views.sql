WITH stg_order_items AS (
    SELECT *
    FROM {{ref('stg_order_items')}}
)
,int_products_viewed_events AS (
    SELECT *
    FROM {{ref('int_products_viewed_events')}}
),
int_session_info AS (
    SELECT *
    FROM {{ref('int_session_info')}}
)
SELECT p.session_id
        , user_id
        , p.product_id
        , page_views
        , added_to_cart
        , CASE WHEN s.order_id IS NOT NULL THEN 1 ELSE 0 END AS is_purchased
        , s.order_id
        , quantity
        , session_start_at
        , session_end_at
-- All sessions that had an page view event
FROM int_products_viewed_events AS p
-- Get info about each session
INNER JOIN int_session_info AS s ON s.session_id = p.session_id
-- Left join to get quantity ordered of each product for an order.  
LEFT JOIN stg_order_items AS oi ON oi.order_id = s.order_id AND oi.product_id = p.product_id