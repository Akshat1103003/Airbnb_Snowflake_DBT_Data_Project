{% macro trim_macro(column_name) %}
    upper(trim({{ column_name }}))
{% endmacro %}