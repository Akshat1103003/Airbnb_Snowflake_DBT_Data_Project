{% set incremental_flag = 1 %}
{% set incremental_column = 'CREATED_AT' %}

select * from {{ source('staging_schema', 'bookings') }} 
{% if incremental_flag == 1 %}
where 
    {{ incremental_column }} > (select coalesce(max({{ incremental_column }}), '1990-01-01') from {{ ref('bronze_bookings') }})
{% endif %}
