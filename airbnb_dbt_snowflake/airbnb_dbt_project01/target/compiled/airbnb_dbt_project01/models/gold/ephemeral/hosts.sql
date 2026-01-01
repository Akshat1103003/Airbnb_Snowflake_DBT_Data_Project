

with hosts as (
    select 
        host_id,
        host_name,
        is_superhost,
        response_rate_tag,
        created_at as host_created_at    
    from AIRBNB_DB.dbt_schema_gold.obt
)

select * from hosts