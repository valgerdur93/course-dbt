{% macro get_product_event_type() %}
{{ return(["page_view", "add_to_cart"]) }}
{% endmacro %}