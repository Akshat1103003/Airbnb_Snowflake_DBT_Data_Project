{{ config(materialized = 'ephemeral') }}

with bookings as (
    select 
        booking_id,
        booking_date as booking_created_at,
        booking_status,
        created_at    
    from {{ ref('obt') }}
)

select * from bookings