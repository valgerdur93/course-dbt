WITH stg_events AS (
    SELECT *
    FROM {{ref('stg_events')}}
),
-- Only look at events for products, so that is why product_id NULL is excluded
-- Data investigation showed that product_id is null for other events than page_view and add_to_cart
product_events AS (
    SELECT session_id
            , user_id
            , product_id
            , CASE WHEN event_type = 'page_view' THEN 1 ELSE 0 END AS page_views
            , CASE WHEN event_type = 'add_to_cart' THEN 1 ELSE 0 END AS added_to_cart
    FROM stg_events
    WHERE product_id IS NOT NULL
),
-- Aggregate to get one row per session, user and product
aggregated_product_events AS (
    SELECT session_id
        , user_id
        , product_id
        , sum(page_views) AS page_views
        , sum(added_to_cart) AS added_to_cart
    FROM product_events
    GROUP BY session_id
        , user_id
        , product_id    
)
-- Filter out rows where page_views = 0
SELECT session_id
        , user_id
        , product_id
        , page_views
        , added_to_cart
FROM aggregated_product_events
WHERE page_views > 0

