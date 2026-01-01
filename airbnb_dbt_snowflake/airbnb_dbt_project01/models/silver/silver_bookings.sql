{{ config(
    materialized='incremental',
    unique_key='BOOKING_ID'
) }}

select 
    BOOKING_ID,
    listing_id,
    booking_date,
    booking_amount,
    cleaning_fee,
    service_fee,
    booking_status,
    nights_booked,
    {{ multiply_macro('nights_booked', 'booking_amount', 2) }} + cleaning_fee + service_fee as total_amount,
    CREATED_AT
from {{ ref("bronze_bookings") }}