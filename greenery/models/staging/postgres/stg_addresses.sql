
WITH raw_addresses AS (
  SELECT *
  FROM {{source('postgres','addresses')}}
)

SELECT 
    address_id,
    address,
    zipcode,
    state,
    country
FROM raw_addresses