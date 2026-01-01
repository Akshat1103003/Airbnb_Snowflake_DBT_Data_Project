{% set obt_config = [
    {
        'table': ref('silver_bookings'),
        'alias': 'silver_bookings'
    },
    {
        'table': ref('silver_listings'),
        'alias': 'silver_listings',
        'join_condition': 'silver_bookings.listing_id = silver_listings.listing_id',
        'exclude_columns': ['listing_id', 'created_at']
    },
    {
        'table': ref('silver_hosts'),
        'alias': 'silver_hosts',
        'join_condition': 'silver_listings.host_id = silver_hosts.host_id',
        'exclude_columns': ['host_id', 'created_at']
    }
] %}

SELECT
    {{ obt_config[0].alias }}.*
    {% for config in obt_config[1:] %}
        {% if config.get('exclude_columns') %}
    , {{ config.alias }}.* EXCLUDE ({{ config.exclude_columns | join(', ') }})
        {% else %}
    , {{ config.alias }}.*
        {% endif %}
    {% endfor %}
FROM
    {{ obt_config[0].table }} AS {{ obt_config[0].alias }}
    {% for config in obt_config[1:] %}
    LEFT JOIN {{ config.table }} AS {{ config.alias }}
        ON {{ config.join_condition }}
    {% endfor %}