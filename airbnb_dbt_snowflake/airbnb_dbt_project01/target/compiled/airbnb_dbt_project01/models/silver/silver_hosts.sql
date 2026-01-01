

select 
    host_id,
    host_name,
    host_since,
    is_superhost,
    response_rate,
    case
        when response_rate > 90 then 'high Response Rate'
        when response_rate > 75 then 'Medium Response Rate'
        when response_rate > 50 then 'Low Response Rate'
        else 'Poor Response Rate'
    end as response_rate_tag,
    created_at 
from AIRBNB_DB.dbt_schema_bronze.bronze_hosts


where 
    created_at > (select coalesce(max(created_at), '1990-01-01') from AIRBNB_DB.dbt_schema_silver.silver_hosts)
