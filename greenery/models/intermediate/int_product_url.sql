WITH stg_events AS (
    SELECT *
    FROM {{ref('stg_events')}}
)
SELECT DISTINCT product_id
        , page_url
FROM stg_events
WHERE product_id IS NOT NULL 
