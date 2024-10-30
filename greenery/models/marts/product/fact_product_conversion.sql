
WITH fact_page_views AS (
    SELECT *
    FROM {{ref('fact_page_views')}}
)
SELECT product_id
        , count(DISTINCT session_id) AS product_viewed_sessions
        , SUM(is_purchased) AS product_purchased_sessions
        , product_purchased_sessions/product_viewed_sessions AS conversion_rate
FROM fact_page_views
GROUP BY product_id   
