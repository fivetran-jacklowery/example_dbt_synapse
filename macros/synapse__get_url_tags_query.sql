{% macro synapse__get_url_tags_query() %}

  cleaned_json as (

      select
          source_relation,
          _fivetran_id,
          creative_id,
          replace(trim(url_tags::text, '"'),'\\','')::json as cleaned_url_tags
      from required_fields
  ), 

  unnested as (

      select 
        source_relation,
        _fivetran_id, 
        creative_id, 
        url_tag_element
      from cleaned_json
      left join lateral json_array_elements(cleaned_url_tags) as url_tag_element on True
      where cleaned_url_tags is not null
  ), 

  fields as (

      select
          source_relation,
          _fivetran_id,
          creative_id,
          url_tag_element->>'key' as key,
          url_tag_element->>'value' as value,
          url_tag_element->>'type' as type
      from unnested
  )

{% endmacro %}
