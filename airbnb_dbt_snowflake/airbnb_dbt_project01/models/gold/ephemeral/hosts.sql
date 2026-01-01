{{ config(materialized = 'table') }}

with hosts as (
    select 
        host_id,
        host_name,
        is_superhost,
        response_rate_tag,
        created_at as host_created_at    
    from {{ ref('obt') }}
)

select * from hosts