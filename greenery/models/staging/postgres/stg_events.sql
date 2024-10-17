WITH raw_events AS (
  SELECT *
  FROM {{source('postgres','events')}}
)

SELECT 
    event_id,
    session_id,
    user_id,
    event_type,
    page_url,
    created_at,
    order_id,
    product_id
FROM raw_events