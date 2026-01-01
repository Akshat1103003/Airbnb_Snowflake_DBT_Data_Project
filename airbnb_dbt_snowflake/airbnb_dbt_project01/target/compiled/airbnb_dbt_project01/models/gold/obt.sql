

SELECT
    silver_bookings.*
    
        
    , silver_listings.* EXCLUDE (listing_id, created_at)
        
    
        
    , silver_hosts.* EXCLUDE (host_id, created_at)
        
    
FROM
    AIRBNB_DB.dbt_schema_silver.silver_bookings AS silver_bookings
    
    LEFT JOIN AIRBNB_DB.dbt_schema_silver.silver_listings AS silver_listings
        ON silver_bookings.listing_id = silver_listings.listing_id
    
    LEFT JOIN AIRBNB_DB.dbt_schema_silver.silver_hosts AS silver_hosts
        ON silver_listings.host_id = silver_hosts.host_id
    