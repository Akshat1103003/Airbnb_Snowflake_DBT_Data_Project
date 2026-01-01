

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
    
    case
        when price_per_night < 100 then 'reasonable'
        when price_per_night < 200 then 'standard'
        else 'expensive'
    end
 as price_per_night_tag,
    CREATED_AT    
     from AIRBNB_DB.dbt_schema_bronze.bronze_listings