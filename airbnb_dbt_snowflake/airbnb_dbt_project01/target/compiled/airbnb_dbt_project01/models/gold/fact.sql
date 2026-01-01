

SELECT
    obt.BOOKING_ID,
    obt.LISTING_ID,
    obt.BOOKING_DATE,
    obt.CLEANING_FEE,
    obt.SERVICE_FEE,
    obt.BOOKING_STATUS,
    obt.NIGHTS_BOOKED,
    obt.TOTAL_AMOUNT,
    obt.CREATED_AT,
    obt.HOST_ID,
    obt.BEDROOMS,
    obt.BATHROOMS,
    obt.PRICE_PER_NIGHT,
    obt.RESPONSE_RATE,
    -- Add snapshot columns
    dim_listings.dbt_valid_from as listing_valid_from,
    dim_listings.dbt_valid_to as listing_valid_to,
    dim_hosts.dbt_valid_from as host_valid_from,
    dim_hosts.dbt_valid_to as host_valid_to
FROM
    AIRBNB_DB.dbt_schema_gold.obt AS obt
    LEFT JOIN airbnb_db.dbt_schema_gold.dim_listings AS dim_listings
        ON obt.listing_id = dim_listings.listing_id
    LEFT JOIN airbnb_db.dbt_schema_gold.dim_hosts AS dim_hosts
        ON obt.host_id = dim_hosts.host_id