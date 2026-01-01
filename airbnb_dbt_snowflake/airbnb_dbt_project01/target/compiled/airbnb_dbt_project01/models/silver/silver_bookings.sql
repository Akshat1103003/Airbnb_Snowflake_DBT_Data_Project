

select 
    BOOKING_ID,
    listing_id,
    booking_date,
    booking_amount,
    cleaning_fee,
    service_fee,
    booking_status,
    nights_booked,
    
    round(nights_booked * booking_amount, 2)
 + cleaning_fee + service_fee as total_amount,
    CREATED_AT
from AIRBNB_DB.dbt_schema_bronze.bronze_bookings