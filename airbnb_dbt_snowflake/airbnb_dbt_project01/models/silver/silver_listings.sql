{{ config(
    materialized='incremental',
    unique_key='listing_id'
) }}

select 
    listing_id,
    host_id ,
    property_type,
    room_type,
    city,
    country,
    accommodates,
    bedrooms,
    bathrooms,
    price_per_night,
    {{tag_macro('price_per_night')}} as price_per_night_tag,
    CREATED_AT    
     from {{ ref('bronze_listings') }}