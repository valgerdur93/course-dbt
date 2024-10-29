


with fact_page_views as (
    SELECT *
    FROM {{ref('fact_page_views')}}
),
dim_products as (
    SELECT *
    FROM {{ref('dim_products')}}
),
sessions_page_views as (
    select product_id
            , count(distinct session_id)  as sessions_page_views
    from fact_page_views
    group by product_id
),
sessions_add_to_cart as (
    select product_id
            , count(distinct session_id) as sessions_add_to_cart
    from fact_page_views
    where added_to_cart > 0
    group by product_id
), 
sessions_checkout as (
    select product_id
            , count(distinct session_id) as sessions_checkout
            , sum(quantity) as quantity
    from fact_page_views
    where is_purchased > 0
    group by product_id
)
select pv.product_id
        , p.name as product_name
        , ifnull(sessions_page_views,0) as sessions_page_views
        , ifnull(sessions_add_to_cart,0) as sessions_add_to_cart
        , ifnull(sessions_checkout,0) as sessions_checkout
        , ifnull(quantity, 0) as quantity
from sessions_page_views as pv
left join sessions_add_to_cart as ac on pv.product_id = ac.product_id
left join sessions_checkout as co on pv.product_id = co.product_id
inner join dim_products as p on p.product_id = pv.product_id
