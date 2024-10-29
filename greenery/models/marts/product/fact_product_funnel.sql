


with stg_events as (
    SELECT *
    FROM {{ref('stg_events')}}
)
select event_type
        , count(distinct session_id) as sessions
from stg_events
group by event_type