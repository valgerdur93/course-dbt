WITH stg_promos AS (
    SELECT *
    FROM {{ref('stg_promos')}}
)
SELECT promo_id
        , discount
        , status
FROM stg_promos