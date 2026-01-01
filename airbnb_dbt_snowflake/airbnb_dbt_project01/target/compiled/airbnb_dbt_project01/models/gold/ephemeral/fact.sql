



SELECT
    gold_obt.BOOKING_ID, gold_obt.LISTING_ID, gold_obt.BOOKING_DATE, gold_obt.CLEANING_FEE, gold_obt.SERVICE_FEE, gold_obt.BOOKING_STATUS, gold_obt.NIGHTS_BOOKED, gold_obt.TOTAL_AMOUNT, gold_obt.CREATED_AT, gold_obt.HOST_ID, gold_obt.BEDROOMS, gold_obt.BATHROOMS, gold_obt.PRICE_PER_NIGHT, gold_obt.RESPONSE_RATE
FROM
    
        
            AIRBNB_DB.dbt_schema_gold.obt AS gold_obt
        
    
        
            LEFT JOIN airbnb_db.dbt_schema_gold.dim_listings AS gold_listings
            ON gold_obt.listing_id = gold_listings.listing_id
        
    
        
            LEFT JOIN airbnb_db.dbt_schema_gold.dim_hosts AS gold_hosts
            ON gold_listings.host_id = gold_hosts.host_id
        
    