WITH raw_products AS (
  SELECT *
  FROM {{source('postgres','products')}}
)

SELECT 
    product_id,
    name,
    price,
    inventory
FROM raw_products