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
        'join_condition': 'gold_obt.listing_id = gold_listings.listing_id'
    },
    {
        'table': ref('dim_hosts'),
        'alias': 'gold_hosts',
        'join_condition': 'gold_listings.host_id = gold_hosts.host_id',
        'exclude_columns': ['host_id', 'created_at']
    }
] %}

SELECT
    {{ fact_config[0]['columns'] }}
FROM
    {% for config in fact_config %}
        {% if loop.first %}
            {{ config['table'] }} AS {{ config['alias'] }}
        {% else %}
            LEFT JOIN {{ config['table'] }} AS {{ config['alias'] }}
            ON {{ config['join_condition'] }}
        {% endif %}
    {% endfor %}