WITH stg_products AS (
    SELECT *
    FROM {{ref('stg_products')}}
),
int_product_url AS (
    SELECT *
    FROM {{ref('int_product_url')}}
)
SELECT p.product_id  
        , name
        , price
        , inventory
        , page_url
FROM stg_products AS p
LEFT JOIN int_product_url AS u on p.product_id = u.product_id