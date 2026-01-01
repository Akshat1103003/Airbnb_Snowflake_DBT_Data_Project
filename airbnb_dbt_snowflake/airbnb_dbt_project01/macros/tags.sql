{% macro tag_macro(column_name) %}
    case
        when {{ column_name }} < 100 then 'reasonable'
        when {{ column_name }} < 200 then 'standard'
        else 'expensive'
    end
{% endmacro %}