{{ config(materialized='ephemeral') }}

{% set fact_config = [
    {
        'table': ref('obt'),
        'columns': 'gold_obt.BOOKING_ID, gold_obt.LISTING_ID, gold_obt.BOOKING_DATE, gold_obt.CLEANING_FEE, gold_obt.SERVICE_FEE, gold_obt.BOOKING_STATUS, gold_obt.NIGHTS_BOOKED, gold_obt.TOTAL_AMOUNT, gold_obt.CREATED_AT, gold_obt.HOST_ID, gold_obt.BEDROOMS, gold_obt.BATHROOMS, gold_obt.PRICE_PER_NIGHT, gold_obt.RESPONSE_RATE',
        'alias': 'gold_obt'
    },
    {
        'table': ref('dim_listings'),
        'alias': 'gold_listings',
        'join_condition': 'gold_obt.listing_id = gold_listings.listing_id AND gold_obt.created_at >= gold_listings.dbt_valid_from AND gold_obt.created_at < gold_listings.dbt_valid_to'
    },
    {
        'table': ref('dim_hosts'),
        'alias': 'gold_hosts',
        'join_condition': 'gold_listings.host_id = gold_hosts.host_id AND gold_obt.created_at >= gold_hosts.dbt_valid_from AND gold_obt.created_at < gold_hosts.dbt_valid_to',
        'exclude_columns': ['host_id', 'created_at']
    }
] %}

SELECT
    {{ fact_config[0]['columns'] }}
FROM
    {{ ref('obt') }} AS gold_obt
    LEFT JOIN {{ ref('dim_listings') }} AS gold_listings
        ON gold_obt.listing_id = gold_listings.listing_id
        AND gold_obt.created_at >= gold_listings.dbt_valid_from  
        AND gold_obt.created_at < gold_listings.dbt_valid_to     
    LEFT JOIN {{ ref('dim_hosts') }} AS gold_hosts
        ON gold_listings.host_id = gold_hosts.host_id
        AND gold_obt.created_at >= gold_hosts.dbt_valid_from    
        AND gold_obt.created_at < gold_hosts.dbt_valid_to       
