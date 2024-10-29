
WITH stg_events AS (
    SELECT *
    FROM {{ref('stg_events')}}
),

product_events AS (
    SELECT session_id,
            user_id,
            product_id,
            {%- for event_type in get_product_event_type() %}
            case when event_type = '{{event_type}}' then 1 else 0 end as {{event_type}}
            {%- if not loop.last %},{% endif -%}
            {% endfor %}
            -- Jinja for loop and a custom made macro used instead of having to repear CASE WHEN many times
            -- Had to move the commas to the end of line instead of in front of the column names to make this work
            --, CASE WHEN event_type = 'page_view' THEN 1 ELSE 0 END AS page_views
            --, CASE WHEN event_type = 'add_to_cart' THEN 1 ELSE 0 END AS added_to_cart
    FROM stg_events
    WHERE product_id IS NOT NULL
),
-- Aggregate to get one row per session, user and product
aggregated_product_events AS (
    SELECT session_id
        , user_id
        , product_id
        , sum(page_view) AS page_views
        , sum(add_to_cart) AS added_to_cart
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

