WITH raw_promos AS (
  SELECT *
  FROM {{source('postgres','promos')}}
)

SELECT 
    promo_id,
    discount,
    status
FROM raw_promos