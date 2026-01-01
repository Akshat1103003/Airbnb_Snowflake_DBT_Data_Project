

select * from airbnb_db.staging_schema.bookings 


where 
    CREATED_AT > (select coalesce(max(CREATED_AT), '1990-01-01') from AIRBNB_DB.dbt_schema_bronze.bronze_bookings)
