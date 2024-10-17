WITH raw_order_items AS (
  SELECT *
  FROM {{source('postgres','order_items')}}
)

SELECT 
    order_id,
    product_id,
    quantity
FROM raw_order_items