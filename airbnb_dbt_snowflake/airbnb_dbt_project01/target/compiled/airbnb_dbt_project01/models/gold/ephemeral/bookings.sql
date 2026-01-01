

with bookings as (
    select 
        booking_id,
        booking_date as booking_created_at,
        booking_status,
        created_at    
    from AIRBNB_DB.dbt_schema_gold.obt
)

select * from bookings