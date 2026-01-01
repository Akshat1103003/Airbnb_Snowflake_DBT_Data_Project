

with listings as (
    select 
        listing_id,
        property_type,
        room_type,
        city,
        country,
        price_per_night,
        price_per_night_tag,
        created_at as listing_created_at    
    from AIRBNB_DB.dbt_schema_gold.obt
)

select * from listings