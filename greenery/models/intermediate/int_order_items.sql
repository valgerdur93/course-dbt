WITH stg_orders AS (
    SELECT *
    FROM {{ref('stg_orders')}}
),
stg_order_items AS (
    SELECT *
    FROM {{ref('stg_order_items')}}
)
SELECT -- to do next week => add order_item_id as a primary key
        o.order_id
        , promo_id
        , user_id
        , address_id
        , created_at
        , product_id
        , quantity
        , order_cost
        , shipping_cost
        , order_total
        , tracking_id
        , shipping_service
        , estimated_delivery_at
        , delivered_at
        , status
FROM stg_orders AS o
INNER JOIN stg_order_items AS oi on o.order_id = oi.order_id