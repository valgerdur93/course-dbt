WITH int_order_items AS (
    SELECT *
    FROM {{ref('int_order_items')}}
)
SELECT order_id
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
FROM int_order_items