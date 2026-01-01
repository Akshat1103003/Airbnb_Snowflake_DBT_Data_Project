{% macro multiply_macro(x,y,decimal) %}
    round({{x}} * {{y}}, {{decimal}})
{% endmacro %}