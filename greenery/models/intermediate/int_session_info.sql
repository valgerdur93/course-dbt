WITH stg_events AS (
    SELECT *
    FROM {{ref('stg_events')}}
),

-- Session start and end timestamp for all sessions from the events table
session_time AS (
    SELECT session_id
        ,min(created_at) as session_start_at
        ,max(created_at) as session_end_at
    FROM stg_events
    GROUP BY session_id
),

-- Find order_id for sessions that lead to a purchase
session_orders AS (
    SELECT DISTINCT session_id
        , order_id
    FROM stg_events
    WHERE order_id IS NOT NULL  
)

-- Combine all session info
SELECT st.session_id
        , order_id
        , session_start_at
        , session_end_at
FROM session_time AS st
-- Left join since not all sessions have an order_id (not all sessions lead to a purchase)
LEFT JOIN session_orders AS so ON so.session_id = st.session_id
