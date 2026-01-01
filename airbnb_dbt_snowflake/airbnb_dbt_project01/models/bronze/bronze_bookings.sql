{{ config(materialized='incremental') }}

select * from {{ source('staging_schema', 'bookings') }} 

{% if is_incremental() %}
where 
    CREATED_AT > (select coalesce(max(CREATED_AT), '1990-01-01') from {{ this }})
{% endif %}